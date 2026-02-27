# Workflow Triggers

Start the default flow with **@planner** and your task.

## Commands

| Command | Action |
|---------|--------|
| **kickoff** | Full workflow: plan → implement → review; use with a task description. |
| **brainstorm** | When requirements are unclear: clarify, propose approach, get approval, then write plan. |
| **write-plan** | Write implementation plan (bite-sized tasks, exact paths); no implementation yet. |
| **execute-plan** | Execute current plan: one agent per task → @code-reviewer after each → finish options. |
| **systematic-debugging** | 4-phase debugging: root cause first, no fixes before Phase 1 complete. |
| **finish-branch** | Verify (`task precommit`), then present merge / PR / keep / discard. |
| **request-code-review** | Ask @code-reviewer with what changed, plan ref, BASE_SHA, HEAD_SHA. |

## Kickoff (full workflow)

```
@planner: Task: [Your change, e.g. "Add wezterm keybinding for X" or "Add new alias in etc/profile/aliases"]

Follow dotfiles workflow. Plan → implement (config or taskfile) → @code-reviewer. At completion: task precommit then finish-branch options.
```

## Example

```
@planner: Task: Add a new keybinding in wezterm to open lazygit

Follow dotfiles workflow from .cursor/rules/dotfiles-core.mdc.
```

## Direct agent use

- **@config** - for edits in etc/, nvim/, wezterm/, hammerspoon/, yazi/, tmux/, scripts/
- **@taskfile** - for Taskfile.yml or tasks/*.yml
- **@code-reviewer** - request review with: what changed, plan reference, BASE_SHA, HEAD_SHA
