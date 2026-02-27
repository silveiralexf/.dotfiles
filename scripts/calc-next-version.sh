#!/usr/bin/env bash
# Calculate next semver from conventional commits since last v* tag.
# Rules: breaking (! or BREAKING CHANGE) → major; feat → minor; fix/chore/docs/etc → patch.
# Usage: run from repo root. Output: next version (e.g. v1.2.0) to stdout.
#
# Dependencies: git, bash only (no jq). CI-safe: run in pipeline via devbox or on any runner with git.

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

# When HEAD is exactly a tag (e.g. in CI), we compute the version *for* that release:
# range = previous tag..HEAD, base = previous tag's version. Otherwise: latest tag = base, range = tag..HEAD.
CURRENT_TAG=$(git describe --tags --exact-match HEAD 2>/dev/null) || true
ALL_V_TAGS=()
while IFS= read -r t; do [[ -n "$t" ]] && ALL_V_TAGS+=("$t"); done < <(git tag -l 'v*' --sort=-v:refname 2>/dev/null || true)

if [[ -n "$CURRENT_TAG" && ${#ALL_V_TAGS[@]} -ge 2 ]]; then
  # We're on a tag; use previous tag for range so we're computing the version this release represents
  PREV_TAG="${ALL_V_TAGS[1]}"
  LAST_TAG="$PREV_TAG"
  REV_RANGE="${PREV_TAG}..HEAD"
  if [[ "$PREV_TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
  else
    MAJOR=0
    MINOR=0
    PATCH=0
  fi
elif [[ ${#ALL_V_TAGS[@]} -gt 0 ]]; then
  LAST_TAG="${ALL_V_TAGS[0]}"
  if [[ "$LAST_TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
  else
    MAJOR=0
    MINOR=0
    PATCH=0
  fi
  REV_RANGE="${LAST_TAG}..HEAD"
else
  MAJOR=0
  MINOR=0
  PATCH=0
  REV_RANGE="HEAD"
fi

# Determine bump from commits: 3=major, 2=minor, 1=patch, 0=none
MAX_BUMP=0
RE_FEAT='^feat(\([^)]*\))?!?:'
RE_OTHER='^(fix|docs|style|refactor|perf|test|chore|ci|build)(\([^)]*\))?!?:'

while IFS= read -r -d '' block; do
  [[ -z "$block" ]] && continue
  subject=$(echo "$block" | head -n1)
  body=$(echo "$block" | tail -n +2)

  # Breaking: in subject (type!: or type(scope)!:) or in body
  if [[ "$subject" == *'!'* ]] || [[ "$body" =~ BREAKING[[:space:]]*CHANGE ]]; then
    MAX_BUMP=3
    break
  fi
  if [[ "$subject" =~ $RE_FEAT ]]; then
    [[ $MAX_BUMP -lt 2 ]] && MAX_BUMP=2
  fi
  if [[ "$subject" =~ $RE_OTHER ]]; then
    [[ $MAX_BUMP -lt 1 ]] && MAX_BUMP=1
  fi
done < <(git log "$REV_RANGE" --format="%s%n%b%n%x00" 2>/dev/null || true)

# If no commits or no recognized types, still bump patch for "next" version when there are commits
COMMIT_COUNT=$(git rev-list --count "$REV_RANGE" 2>/dev/null || echo 0)
if [[ "$COMMIT_COUNT" -gt 0 && $MAX_BUMP -eq 0 ]]; then
  MAX_BUMP=1
fi

case $MAX_BUMP in
  3) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  2) MINOR=$((MINOR + 1)); PATCH=0 ;;
  1) PATCH=$((PATCH + 1)) ;;
  *) ;;
esac

echo "v${MAJOR}.${MINOR}.${PATCH}"
