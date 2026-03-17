#!/usr/bin/env bash
# Generate ~/.local/share/applications/*.desktop launchers for all packages
# installed via `devbox global`.
#
# Instead of hardcoding the nix store path (which changes on every package
# update), we use the stable devbox global profile symlink exported as
# DEVBOX_GLOBAL_PREFIX, so launchers never go stale after `devbox global pull`.
#
# Usage:
#   gen-devbox-launchers.sh            # generate launchers
#   gen-devbox-launchers.sh --dry-run  # preview without writing files
#   gen-devbox-launchers.sh --clean    # remove all managed launchers
#   gen-devbox-launchers.sh --verbose  # verbose output

set -euo pipefail

# ---------------------------------------------------------------------------
# Flags
# ---------------------------------------------------------------------------
DRY_RUN=false
CLEAN=false
VERBOSE=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --clean) CLEAN=true ;;
    --verbose | -v) VERBOSE=true ;;
    --help | -h)
      grep '^# ' "$0" | head -12 | sed 's/^# //'
      exit 0
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
DEVBOX_GLOBAL_PATH="$(devbox global path 2>/dev/null)" || {
  echo "ERROR: 'devbox' not found or 'devbox global path' failed." >&2
  exit 1
}

# DEVBOX_GLOBAL_PREFIX is exported in etc/profile/exports and always points at
# the current nix profile generation — safe to use in Exec= lines.
DEVBOX_PROFILE="${DEVBOX_GLOBAL_PREFIX:-${DEVBOX_GLOBAL_PATH}/.devbox/nix/profile/default}"

if [[ ! -d "$DEVBOX_PROFILE" ]]; then
  echo "ERROR: devbox global profile not found at: $DEVBOX_PROFILE" >&2
  echo "       Run 'devbox global pull devbox.json -f' first." >&2
  exit 1
fi

DEVBOX_GLOBAL_JSON="${DEVBOX_GLOBAL_PATH}/devbox.json"
LAUNCHERS_DIR="${HOME}/.local/share/applications"

# Marker so we can identify files we own
MANAGED_MARKER="# managed-by: gen-devbox-launchers"

mkdir -p "$LAUNCHERS_DIR"

# ---------------------------------------------------------------------------
# Clean mode: remove all managed launchers
# ---------------------------------------------------------------------------
if $CLEAN; then
  echo "Removing all managed devbox launchers from ${LAUNCHERS_DIR} ..."
  count=0
  while IFS= read -r -d '' f; do
    if grep -qF "$MANAGED_MARKER" "$f" 2>/dev/null; then
      $VERBOSE && echo "  removing: $(basename "$f")"
      $DRY_RUN || rm -f "$f"
      ((count++)) || true
    fi
  done < <(find "$LAUNCHERS_DIR" -name "devbox-*.desktop" -print0 2>/dev/null)
  echo "Done. Removed ${count} launcher(s)."
  $DRY_RUN || update-desktop-database "$LAUNCHERS_DIR" 2>/dev/null || true
  exit 0
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Extract a key from a .desktop file (first match, strip trailing CR)
desktop_field() {
  local file="$1" field="$2"
  grep -m1 "^${field}=" "$file" 2>/dev/null | cut -d= -f2- | tr -d '\r'
}

# Resolve the best icon for a package.
# Priority: icon name from upstream .desktop > file in share/icons or
# share/pixmaps > generic fallback.
find_icon() {
  local pkg_name="$1" upstream_icon="$2"

  if [[ -n "$upstream_icon" ]]; then
    echo "$upstream_icon"
    return
  fi

  local icon
  for size in 256x256 128x128 64x64 48x48 32x32 scalable; do
    icon=$(find "${DEVBOX_PROFILE}/share/icons" \
      -iname "${pkg_name}.*" -path "*/${size}/*" 2>/dev/null | head -1)
    [[ -n "$icon" ]] && { echo "$icon"; return; }
  done

  icon=$(find "${DEVBOX_PROFILE}/share/pixmaps" \
    -iname "${pkg_name}.*" 2>/dev/null | head -1)
  [[ -n "$icon" ]] && { echo "$icon"; return; }

  echo "application-x-executable"
}

# ---------------------------------------------------------------------------
# Skip list — CLI-only / build-time / library packages that have no GUI value.
# Add entries here when you install new CLI tools via devbox global.
# ---------------------------------------------------------------------------
SKIP_PKGS=(
  atuin bat btop cargo cmake coreutils delta eza fd
  git-cliff glibcLocales glibcLocalesUtf8 gnupg gnused
  go-task go htop jq kubectl lua5_4 luarocks
  markdownlint-cli nodejs pass pipx pre-commit python3
  ripgrep rustc shellcheck sops sshfs taplo
  tmux tmuxp wget xclip xsel yamlfmt zoxide
)

is_skipped() {
  local name="$1"
  for s in "${SKIP_PKGS[@]}"; do
    [[ "$s" == "$name" ]] && return 0
  done
  return 1
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------
if [[ ! -f "$DEVBOX_GLOBAL_JSON" ]]; then
  echo "ERROR: devbox.json not found at: $DEVBOX_GLOBAL_JSON" >&2
  exit 1
fi

# Parse package names from devbox.json, stripping version suffixes (@latest …)
mapfile -t PACKAGES < <(
  jq -r '.packages[]' "$DEVBOX_GLOBAL_JSON" 2>/dev/null |
    sed 's/@.*//' |
    sort -u
)

echo "devbox global path : ${DEVBOX_GLOBAL_PATH}"
echo "stable profile     : ${DEVBOX_PROFILE}"
echo "launchers dir      : ${LAUNCHERS_DIR}"
echo "packages found     : ${#PACKAGES[@]}"
echo ""

generated=0
skipped_cli=0
skipped_nobin=0

for pkg in "${PACKAGES[@]}"; do

  # Skip known CLI-only packages
  if is_skipped "$pkg"; then
    $VERBOSE && echo "  [skip-cli]   $pkg"
    ((skipped_cli++)) || true
    continue
  fi

  # Most nix packages name the binary identically to the package (lower-cased)
  bin_name="${pkg,,}"

  # If the direct match isn't executable, try a prefix search
  if [[ ! -x "${DEVBOX_PROFILE}/bin/${bin_name}" ]]; then
    bin_name=$(
      find "${DEVBOX_PROFILE}/bin" -maxdepth 1 \
        -iname "${pkg,,}*" -executable 2>/dev/null |
        head -1 | xargs -r basename
    )
  fi

  if [[ -z "$bin_name" ]]; then
    $VERBOSE && echo "  [no-binary]  $pkg"
    ((skipped_nobin++)) || true
    continue
  fi

  # Check if the package ships an upstream .desktop file in the nix profile
  upstream_desktop=$(
    find "${DEVBOX_PROFILE}/share/applications" -maxdepth 1 \
      \( -iname "${pkg,,}*.desktop" -o -iname "${bin_name}*.desktop" \) \
      2>/dev/null | head -1
  )

  upstream_name=""
  upstream_comment=""
  upstream_icon=""
  upstream_categories=""
  upstream_exec_args=""
  upstream_terminal="false"

  if [[ -n "$upstream_desktop" ]]; then
    upstream_name=$(desktop_field "$upstream_desktop" "Name")
    upstream_comment=$(desktop_field "$upstream_desktop" "Comment")
    upstream_icon=$(desktop_field "$upstream_desktop" "Icon")
    upstream_categories=$(desktop_field "$upstream_desktop" "Categories")
    upstream_terminal=$(desktop_field "$upstream_desktop" "Terminal")
    raw_exec=$(desktop_field "$upstream_desktop" "Exec")
    # Strip the binary from Exec= to keep only the arguments/field codes
    upstream_exec_args=$(echo "$raw_exec" | sed "s|^[^ ]* *||")
    $VERBOSE && echo "  [upstream]   $pkg → $(basename "$upstream_desktop")"
  fi

  display_name="${upstream_name:-$pkg}"
  comment="${upstream_comment:-${pkg} (devbox global)}"
  icon=$(find_icon "$pkg" "$upstream_icon")
  categories="${upstream_categories:-Utility;}"
  terminal="${upstream_terminal:-false}"

  # Always use the stable profile path in Exec= — never a raw /nix/store hash
  exec_path="${DEVBOX_PROFILE}/bin/${bin_name}"
  exec_line="$exec_path"
  [[ -n "$upstream_exec_args" ]] && exec_line="${exec_path} ${upstream_exec_args}"

  desktop_file="${LAUNCHERS_DIR}/devbox-${pkg,,}.desktop"

  $VERBOSE && echo "  [generate]   $pkg → $(basename "$desktop_file")"

  if $DRY_RUN; then
    echo "--- DRY RUN: ${desktop_file} ---"
    cat <<DESKTOP
[Desktop Entry]
${MANAGED_MARKER}
Type=Application
Version=1.0
Name=${display_name}
Comment=${comment}
Exec=${exec_line}
Icon=${icon}
Terminal=${terminal}
Categories=${categories}
DESKTOP
    echo ""
  else
    cat >"$desktop_file" <<DESKTOP
[Desktop Entry]
${MANAGED_MARKER}
Type=Application
Version=1.0
Name=${display_name}
Comment=${comment}
Exec=${exec_line}
Icon=${icon}
Terminal=${terminal}
Categories=${categories}
DESKTOP
  fi

  ((generated++)) || true
done

echo "Summary:"
echo "  Generated           : ${generated}"
echo "  Skipped (CLI-only)  : ${skipped_cli}"
echo "  Skipped (no binary) : ${skipped_nobin}"

if ! $DRY_RUN && ((generated > 0)); then
  update-desktop-database "$LAUNCHERS_DIR" 2>/dev/null &&
    echo "  Desktop database updated."
fi
