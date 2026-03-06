---
description: Systematic debugging - root cause first, no fixes before Phase 1 complete
---
<!--
  WARNING: GENERATED FILE -- DO NOT EDIT DIRECTLY
  Source: .agents/commands/systematic-debugging.md
  Regenerate: ./scripts/generate-agents.sh
-->

@planner: We have a bug or broken behavior. Run systematic debugging.

Follow .cursor/rules/dotfiles-debug.mdc: Phase 1 (root cause) - read errors/logs; reproduce; check recent changes (git diff, config in etc/nvim/wezterm/tasks, env); narrow where it fails. Phase 2 (pattern) - compare with working examples. Phase 3 (hypothesis) - one clear hypothesis; test minimally. Phase 4 (fix) - only after root cause: minimal fix; verify. Do not suggest fixes before Phase 1 is complete. Rule reference: dotfiles-debug.mdc.
