# .cursor directory

Cursor agentic workflow for this repo: **plan → implement → review**.

## Layout

- **plugin.json** – Manifest for Cursor (commands, skills, agents).
- **rules/** – Workflow rules:
  - **dotfiles-cursorrules.mdc** – References project root .cursorrules; fundamental behavior and workflow.
  - **dotfiles-core.mdc** – Default flow; commands ↔ rules ↔ skills.
  - **dotfiles-brainstorm.mdc** – Clarify, propose, approve before plan.
  - **dotfiles-plan.mdc** – Bite-sized tasks, exact paths.
  - **dotfiles-debug.mdc** – 4-phase systematic debugging.
  - **dotfiles-git.mdc** – Finish branch (verify, merge/PR/keep/discard).
- **.cursorrules** (repo root) – Project-wide rules; Cursor and agents respect it. Do not edit without approval.
- **commands/** – kickoff, brainstorm, write-plan, execute-plan, systematic-debugging, finish-branch, request-code-review.
- **agents/** – planner, config, taskfile, code-reviewer.
- **skills/** – taskfile-validate.sh, pre-commit-run.sh (executable scripts).
- **plans/** – Implementation plans (`YYYY-MM-DD_<username>_<slug>.plan.md`).

## Command → Rule → Skill

Each command is tied to specific rules and (when relevant) skills. Full mapping: **AGENTIC_WORKFLOW.md**. Quick reference: **WORKFLOW_TRIGGERS.md**.
