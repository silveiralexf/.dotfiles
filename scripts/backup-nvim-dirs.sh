#!/usr/bin/env bash
# Backup Neovim data/cache dirs only (not config) so config stays and pack can auto-install on next start.
# Usage: ./scripts/backup-nvim-dirs.sh

set -e

timestamp=$(date '+%Y%m%d-%H%M%S')
suffix="bak-${timestamp}"

backed=0
if [ -d ~/.local/share/nvim ]; then
  mv ~/.local/share/nvim ~/.local/share/nvim."${suffix}"
  echo "Backed up ~/.local/share/nvim -> ~/.local/share/nvim.${suffix}"
  backed=1
fi
if [ -d ~/.local/state/nvim ]; then
  mv ~/.local/state/nvim ~/.local/state/nvim."${suffix}"
  echo "Backed up ~/.local/state/nvim -> ~/.local/state/nvim.${suffix}"
  backed=1
fi
if [ -d ~/.cache/nvim ]; then
  mv ~/.cache/nvim ~/.cache/nvim."${suffix}"
  echo "Backed up ~/.cache/nvim -> ~/.cache/nvim.${suffix}"
  backed=1
fi

if [ "$backed" -eq 0 ]; then
  echo "No Neovim data dirs found to backup."
else
  echo "Done. ~/.config/nvim unchanged; start nvim and pack will install plugins from scratch."
fi
