#!/usr/bin/env bash
# WARNING: GENERATED -- DO NOT EDIT DIRECTLY
# Source: .agents/skills/pre-commit-run.sh
# Regenerate: ./scripts/generate-agents.sh

# Run pre-commit checks (e.g. task precommit or scripts/hooks/pre-commit)
set -e
cd "${DOTFILES_HOME:-$HOME/.dotfiles}"
if command -v task >/dev/null 2>&1; then
  task precommit
else
  [ -x ./scripts/hooks/pre-commit ] && ./scripts/hooks/pre-commit || true
fi
