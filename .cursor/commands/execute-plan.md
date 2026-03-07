<!--
  WARNING: GENERATED FILE -- DO NOT EDIT DIRECTLY
  Source: .agents/commands/execute-plan.md
  Regenerate: ./scripts/generate-agents.sh
-->
---
description: Execute plan - one agent per task, then spec check and code review
---

@planner: Execute the current plan in .agents/plans/.

Follow .cursor/rules/dotfiles-core.mdc (execute flow): read the plan; for each task delegate to @config or @taskfile with the full task text; after each task confirm work matches the plan, then @code-reviewer (what implemented, plan ref, BASE_SHA, HEAD_SHA). After all tasks: run @pre-commit-run (e.g. task precommit), then follow .cursor/rules/dotfiles-git.mdc for finish-branch options.
