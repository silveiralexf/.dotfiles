#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v node >/dev/null 2>&1; then
  echo "error: node is required but not found in PATH" >&2
  exit 1
fi

if [ ! -d "$REPO_ROOT/node_modules" ]; then
  echo "Installing dependencies..."
  (cd "$REPO_ROOT" && npm install --silent)
fi

export NODE_PATH="$REPO_ROOT/node_modules"
exec node "$SCRIPT_DIR/generate.js" "$@"
