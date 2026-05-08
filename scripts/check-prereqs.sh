#!/usr/bin/env bash
# Check that required tools for pre-commit are available.

set -e

required=(pre-commit task)
optional=(jq yamlfmt shellcheck)

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
  echo "  pre-commit: brew install pre-commit (or pip install pre-commit)" >&2
  echo "  task: brew install go-task" >&2
  echo "  jq: brew install jq | yamlfmt: go install github.com/google/yamlfmt/cmd/yamlfmt@latest | shellcheck: brew install shellcheck" >&2
  exit 1
fi

exit 0
