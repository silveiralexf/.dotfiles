<!--
  WARNING: GENERATED FILE -- DO NOT EDIT DIRECTLY
  Source: .agents/commands/finish-branch.md
  Regenerate: ./scripts/generate-agents.sh
-->
---
description: Finish development branch - verify (task precommit), then merge/PR/keep/discard
---

@planner: Finish the current branch.

Follow .cursor/rules/dotfiles-git.mdc: (1) Run @pre-commit-run (e.g. `task precommit` or scripts/hooks/pre-commit); if it fails, show failures and fix first. (2) Determine base branch. (3) Present exactly four options: merge locally, push and create PR, keep branch as-is, discard (require explicit confirmation for discard). (4) Execute the user's choice; clean up worktree if merging or discarding. Rule reference: dotfiles-git.mdc. Skill: pre-commit-run.
