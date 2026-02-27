#!/usr/bin/env bash
# Rename .cursor/plans/*.plan.md to convention: YYYY-MM-DD_<username>_<slug>.plan.md
# Usage: scripts/rename-cursor-plans.sh [--dry-run]
# Used by pre-commit to keep plan filenames consistent.

set -e
DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && { DRY_RUN=true; shift; }
if [ -n "${GIT_DIR}" ]; then
  ROOT="$(cd "$(dirname "$GIT_DIR")" && pwd)"
else
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fi
PLANS_DIR="$ROOT/.cursor/plans"

# Valid name: YYYY-MM-DD_<username>_<slug>.plan.md (exactly two underscores, three segments)
valid_name() {
  local base="$1"
  case "$base" in
    README.md) return 0 ;;
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_*_*.plan.md) return 0 ;;
    *) return 1 ;;
  esac
}

# Get default username: env CURSOR_PLAN_USER, or git user.name (lowercase, spaces -> dots)
get_username() {
  if [ -n "${CURSOR_PLAN_USER:-}" ]; then
    echo "$CURSOR_PLAN_USER"
    return
  fi
  local name
  name=$(git config user.name 2>/dev/null || echo "dotfiles")
  echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/  */./g' | tr -cd 'a-z0-9._-'
}

# Derive slug from basename: strip .plan.md, strip leading YYYY-MM-DD_, remove UUID, normalize
to_slug() {
  local base="$1"
  base="${base%.plan.md}"
  base="${base%.plan}"
  # Strip leading date so "2026-02-27_nvim-improvements" -> "nvim-improvements"
  base=$(echo "$base" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}_//')
  # Remove UUID-like suffix (e.g. -3e679162)
  base=$(echo "$base" | sed -E 's/-[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$//i')
  base=$(echo "$base" | sed -E 's/-[0-9a-f]{8}$//i')
  # Lowercase, non-alphanumeric -> hyphen
  base=$(echo "$base" | tr '[:upper:]' '[:lower:]' | tr -s ' _.' '---' | sed 's/[^a-z0-9-]/-/g' | sed 's/^-//;s/-$//')
  [ -z "$base" ] && base="plan"
  echo "$base"
}

# Use date from basename (YYYY-MM-DD_) if present, else today
get_date() {
  local base="$1"
  if echo "$base" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}_'; then
    echo "$base" | sed -E 's/^([0-9]{4}-[0-9]{2}-[0-9]{2})_.*/\1/'
  else
    date +%Y-%m-%d
  fi
}

renamed=0
username=$(get_username)

for f in "$PLANS_DIR"/*.plan.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  # Skip README and already-valid names
  if [ "$base" = "README.md" ]; then
    continue
  fi
  if valid_name "$base"; then
    continue
  fi
  slug=$(to_slug "$base")
  plan_date=$(get_date "$base")
  new_name="${plan_date}_${username}_${slug}.plan.md"
  new_path="$PLANS_DIR/$new_name"
  if [ -e "$new_path" ] && [ "$(realpath "$f" 2>/dev/null || echo "$f")" != "$(realpath "$new_path" 2>/dev/null || echo "$new_path")" ]; then
    echo "rename-cursor-plans: skip $base (target exists: $new_name)" 1>&2
    continue
  fi
  if [ "$DRY_RUN" = true ]; then
    echo "Would rename: $base -> $new_name"
  else
    old_path="$f"
    mv "$f" "$new_path"
    echo "Renamed: $base -> $new_name"
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      git add -- "$new_path" 2>/dev/null || true
      git add -- "$old_path" 2>/dev/null || true
    fi
  fi
  renamed=$((renamed + 1))
done

[ "$DRY_RUN" = true ] && [ "$renamed" -gt 0 ] && echo "Dry run: $renamed file(s) would be renamed."
exit 0
