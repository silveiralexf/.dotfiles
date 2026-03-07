---
description: Request code review - provide what changed, plan ref, BASE_SHA, HEAD_SHA
---
<!--
  WARNING: GENERATED FILE -- DO NOT EDIT DIRECTLY
  Source: .agents/commands/request-code-review.md
  Regenerate: ./scripts/generate-agents.sh
-->

@code-reviewer: Review the current changes.

Provide: **What was implemented** (brief description), **Plan reference** (e.g. .agents/plans/YYYY-MM-DD_user_slug.plan.md Task N), **BASE_SHA**, **HEAD_SHA**. Code Reviewer will check style and plan adherence; may suggest @pre-commit-run (e.g. task precommit). See .agents/agents/code-reviewer.md for request template.
