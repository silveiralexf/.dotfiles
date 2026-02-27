#!/usr/bin/env bash
# Validate that all .cursor/plans/*.plan.md filenames follow the naming convention.
# See .cursor/rules/dotfiles-plan-naming.mdc. Run from repo root.
# On failure, run scripts/rename-cursor-plans.sh to fix.

set -e

# Pattern: YYYY-MM-DD_<username>_<plan-slug>.plan.md
# Username: lowercase, dots (e.g. felipe.silveira). Slug: lowercase, hyphens, no spaces.
VALID_REGEX='^[0-9]{4}-[0-9]{2}-[0-9]{2}_[a-z0-9.]+_[a-z0-9][a-z0-9.-]*\.plan\.md$'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PLANS_DIR="${PROJECT_ROOT}/.cursor/plans"

cd "${PROJECT_ROOT}"

if [ ! -d "${PLANS_DIR}" ]; then
  exit 0
fi

invalid=()
while IFS= read -r -d '' path; do
  base="$(basename "$path")"
  if ! echo "$base" | grep -qE "${VALID_REGEX}"; then
    invalid+=("$base")
  fi
done < <(find "${PLANS_DIR}" -maxdepth 1 -name '*.plan.md' -print0 2>/dev/null || true)

if [ ${#invalid[@]} -gt 0 ]; then
  echo "cursor-plan-names: the following plan filenames do not match the convention:" >&2
  printf '  %s\n' "${invalid[@]}" >&2
  echo "See .cursor/rules/dotfiles-plan-naming.mdc. Run: task plan:rename (or scripts/rename-cursor-plans.sh)" >&2
  exit 1
fi

exit 0
