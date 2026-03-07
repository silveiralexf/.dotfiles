#!/usr/bin/env bash
# Usage: scripts/generate-agents.sh [--platform cursor|claude|opencode] [--type agents|commands|skills]
set -e

cd "${DOTFILES_HOME:-$(pwd)}"

if ! command -v node >/dev/null 2>&1; then
  echo "error: node is required but not found in PATH" >&2
  exit 1
fi

exec .agents/generate.sh "$@"
