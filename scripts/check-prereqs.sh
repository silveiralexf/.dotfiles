#!/usr/bin/env bash
# Check that required tools for pre-commit are available.
# Recommended: use devbox so pre-commit, task, jq, yamlfmt, shellcheck, markdownlint are provided.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

required=(pre-commit task)
# Used by task markdownlint, yamlfmt, jsonfmt; shellcheck hook
optional=(jq yamlfmt markdownlint shellcheck)

missing=()
for util in "${required[@]}"; do
  if command -v "$util" >/dev/null 2>&1; then
    : "found $util"
  else
    missing+=("$util")
  fi
done

for util in "${optional[@]}"; do
  if command -v "$util" >/dev/null 2>&1; then
    : "found $util"
  else
    missing+=("$util")
  fi
done

if [ ${#missing[@]} -gt 0 ]; then
  echo "check-prereqs: missing: ${missing[*]}" >&2
  if command -v devbox >/dev/null 2>&1 && [ -f "${ROOT}/devbox.json" ]; then
    echo "  Recommended: devbox shell, then retry. Devbox provides pre-commit, task, jq, yamlfmt, shellcheck, markdownlint." >&2
  else
    echo "  pre-commit: brew install pre-commit (or pip install pre-commit)" >&2
    echo "  task: brew install go-task (or use devbox)" >&2
    echo "  jq: brew install jq | yamlfmt: go install github.com/google/yamlfmt/cmd/yamlfmt@latest | shellcheck: brew install shellcheck | markdownlint: use devbox" >&2
  fi
  exit 1
fi

exit 0
