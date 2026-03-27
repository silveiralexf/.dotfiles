#!/usr/bin/env bash
# Restore the most recent Neovim backup created by backup-nvim-dirs.sh.
# Current (broken) dirs are renamed with a .broken-TIMESTAMP suffix before restore.
# Usage: ./scripts/restore-nvim-dirs.sh

set -e

# Find the latest backup timestamp across all three dirs
latest=$(
  {
    ls -d ~/.local/share/nvim.bak-* 2>/dev/null
    ls -d ~/.local/state/nvim.bak-* 2>/dev/null
    ls -d ~/.cache/nvim.bak-*       2>/dev/null
  } \
  | sed 's/.*\.bak-//' \
  | sort -r \
  | head -1
)

if [ -z "$latest" ]; then
  echo "No Neovim backups found (looked for nvim.bak-* in share/state/cache)." >&2
  exit 1
fi

echo "Latest backup: bak-${latest}"
echo ""

broken_suffix="broken-$(date '+%Y%m%d-%H%M%S')"
restored=0

restore_dir() {
  local base="$1"      # e.g. ~/.local/share/nvim
  local backup="${base}.bak-${latest}"

  if [ ! -d "$backup" ]; then
    echo "  skip  ${base}  (no backup for this timestamp)"
    return
  fi

  if [ -d "$base" ]; then
    mv "$base" "${base}.${broken_suffix}"
    echo "  stashed  ${base} -> ${base##*/}.${broken_suffix}"
  fi

  mv "$backup" "$base"
  echo "  restored ${backup##*/} -> ${base##*/}"
  restored=1
}

restore_dir ~/.local/share/nvim
restore_dir ~/.local/state/nvim
restore_dir ~/.cache/nvim

echo ""
if [ "$restored" -eq 0 ]; then
  echo "Nothing restored."
else
  echo "Done. Restart Neovim."
fi
