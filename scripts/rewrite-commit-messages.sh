#!/usr/bin/env bash
# Normalize a single commit message (stdin -> stdout) to conventional-commit format.
# Used with: git filter-branch -f --msg-filter 'scripts/rewrite-commit-messages.sh' -- --all
# WARNING: Rewrites history (new SHAs). After running, use: git push --force-with-lease
# Make a backup first: git clone --mirror . ../.dotfiles-backup.git

# Read full message first so we can split (head/tail both read stdin)
msg=$(cat)
first_line=$(echo "$msg" | head -n1)
rest=$(echo "$msg" | tail -n +2)

[ -z "$first_line" ] && { echo; [ -n "$rest" ] && echo "$rest"; exit 0; }

# Apply same normalization rules as cliff.toml commit_preprocessors (order matters).
# Use [ \t]* for portability (BSD/macOS sed).
first_line=$(echo "$first_line" | sed \
  -e 's/^\[FIX\][ \t]*/fix: /' \
  -e 's/^\[UPDATE\][ \t]*/chore: /' \
  -e 's/^Merge pull request/chore: Merge pull request/' \
  -e 's/^Merge branch/chore: Merge branch/' \
  -e 's/^[Uu]pdates\(.*\)/chore: updates\1/' \
  -e 's/^[Uu]pdating/chore: Updating/' \
  -e 's/^Updated /chore: Updated /' \
  -e 's/^Added /chore: Added /' \
  -e 's/^Add /feat: Add /' \
  -e 's/^Fixed /fix: Fixed /' \
  -e 's/^Improved /chore: Improved /' \
  -e 's/^Small /chore: Small /' \
  -e 's/^Minor /chore: Minor /' \
  -e 's/^remove /chore: remove /' \
  -e 's/^Remove /chore: Remove /' \
  -e 's/^Initial /chore: Initial /' \
  -e 's/^Inital /chore: Initial /' \
  -e 's/^Changed /chore: Changed /' \
  -e 's/^Replaced /chore: Replaced /' \
  -e 's/^Replace /chore: Replace /' \
  -e 's/^Moved /chore: Moved /' \
  -e 's/^Update /chore: Update /' \
  -e 's/^Replacing /chore: Replacing /' \
  -e 's/^add /chore: add /' \
  -e 's/^Borrowed /chore: Borrowed /' \
  -e 's/^Dual /chore: Dual /' \
  -e 's/^i3block /chore: i3block /')

# If still not conventional (type: or type(scope):), prefix with chore:
if ! echo "$first_line" | grep -qE '^(feat|fix|chore|doc|refactor|perf|style|test|revert|ci)(\([^)]*\))?!?:'; then
  first_line="chore: $first_line"
fi

printf '%s\n' "$first_line"
[ -n "$rest" ] && printf '%s\n' "$rest"
exit 0
