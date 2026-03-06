#!/usr/bin/env bash
# Run pre-commit checks (e.g. task precommit or scripts/hooks/pre-commit)
set -e
cd "${DOTFILES_HOME:-$HOME/.dotfiles}"
if command -v task >/dev/null 2>&1; then
  task precommit
else
  [ -x ./scripts/hooks/pre-commit ] && ./scripts/hooks/pre-commit || true
fi
