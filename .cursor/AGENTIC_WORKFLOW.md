# Dotfiles Agentic Workflow

Default flow for AI-assisted dotfiles changes: **plan → implement (config or taskfile) → review**.

## Rules (`.cursor/rules/`)

| Rule | Purpose |
|------|---------|
| **dotfiles-cursorrules.mdc** | References project root .cursorrules; fundamental behavior, workflow, safety. Always follow. |
| **dotfiles-core.mdc** | Default flow; command ↔ rule ↔ skill mapping; anti-patterns. |
| **dotfiles-brainstorm.mdc** | When unclear: clarify, propose, approve; then write plan. No edits until approved. |
| **dotfiles-plan.mdc** | Bite-sized tasks, exact paths (etc/, nvim/, wezterm/, tasks/, scripts/), plan naming. |
| **dotfiles-debug.mdc** | 4-phase systematic debugging; no fixes before root cause. |
| **dotfiles-git.mdc** | Finish branch: verify (pre-commit), then merge/PR/keep/discard. |

## Commands (`.cursor/commands/`)

| Command | Rule(s) | Skills |
|---------|---------|--------|
| **kickoff** | dotfiles-core, dotfiles-plan, dotfiles-git | pre-commit-run at end |
| **brainstorm** | dotfiles-brainstorm → dotfiles-plan | - |
| **write-plan** | dotfiles-plan | - |
| **execute-plan** | dotfiles-core, dotfiles-plan, dotfiles-git | pre-commit-run at end |
| **systematic-debugging** | dotfiles-debug | - |
| **finish-branch** | dotfiles-git | pre-commit-run |
| **request-code-review** | - | - (invokes @code-reviewer) |

## Skills (`.cursor/skills/`)

| Skill | When used |
|-------|-----------|
| **taskfile-validate** | After editing Taskfile.yml or tasks/*.yml; runs `task --list` to validate. |
| **pre-commit-run** | Before commit / at branch finish; runs `task precommit` or scripts/hooks/pre-commit. |

## Agents (`.cursor/agents/`)

| Agent | Role | Rules / skills |
|-------|------|----------------|
| **@planner** | Orchestrator and gatekeeper; plans and validates work. | dotfiles-core, dotfiles-plan, dotfiles-brainstorm, dotfiles-debug, dotfiles-git; pre-commit-run, taskfile-validate |
| **@config** | Implements config changes (etc/, nvim/, wezterm/, etc.). | dotfiles-plan; pre-commit-run |
| **@taskfile** | Edits Taskfile.yml and tasks/*.yml. | dotfiles-plan; taskfile-validate |
| **@code-reviewer** | Reviews changes before commit. | pre-commit-run (suggest verification) |

## Default flow

1. **If requirements unclear:** dotfiles-brainstorm → then dotfiles-plan.
2. **Plan:** Bite-sized tasks, exact paths; plans in `.cursor/plans/` (`YYYY-MM-DD_<username>_<slug>.plan.md`).
3. **Execute:** One agent per task (@config or @taskfile); after each task: @code-reviewer.
4. **On bug:** dotfiles-debug (root cause first).
5. **End of branch:** dotfiles-git; run pre-commit-run, then merge/PR/keep/discard.

## Gates

- **Plan validation:** All agents must validate with @planner before starting or when detouring.
- **Code review:** All changes must pass @code-reviewer before commit.

## Project rules (.cursorrules)

Fundamental behavior, agent workflow, and safety are defined in the project root **.cursorrules**. Always follow them. The rule **dotfiles-cursorrules.mdc** in .cursor/rules/ references and summarizes .cursorrules for the agentic workflow.

## How to use

Start with **@planner** and describe the change. See `.cursor/WORKFLOW_TRIGGERS.md` for command examples.
