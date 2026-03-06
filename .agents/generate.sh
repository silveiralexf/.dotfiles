#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v node >/dev/null 2>&1; then
  echo "error: node is required but not found in PATH" >&2
  exit 1
fi

if [ ! -d "$SCRIPT_DIR/node_modules" ]; then
  echo "Installing .agents dependencies..."
  (cd "$SCRIPT_DIR" && npm install --silent)
fi

exec node "$SCRIPT_DIR/generate.js" "$@"
