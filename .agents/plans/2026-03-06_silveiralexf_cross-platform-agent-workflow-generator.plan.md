# Plan: Cross-Platform Agentic Workflow Generator

## Goal

Create an agnostic templating system that generates agentic workflow files for multiple AI coding platforms (Cursor, OpenCode, Claude) from a single source of truth.

## Problem

Currently the dotfiles have agentic workflow only for Cursor (`.cursor/`). Want to extend to OpenCode and Claude while:
- Maintaining single source of truth
- Generating files for all platforms from templates
- Warning users that generated files should not be edited directly

## Architecture

```
.dotfiles/
├── .agents/                              # Source of truth (git committed)
│   ├── data/
│   │   ├── agents.yaml                 # Agent definitions
│   │   ├── commands.yaml                # Command definitions
│   │   ├── skills.yaml                  # Skill definitions
│   │   └── config.yaml                  # Shared config (paths, plan naming)
│   ├── templates/
│   │   ├── cursor/
│   │   │   ├── agent.md.hbs            # → .cursor/agents/*.md
│   │   │   ├── command.md.hbs          # → .cursor/commands/*.md
│   │   │   └── skill.sh.hbs           # → .cursor/skills/*.sh
│   │   ├── opencode/
│   │   │   ├── agent.md.hbs            # → .opencode/agents/*.md
│   │   │   ├── command.md.hbs          # → .opencode/commands/*.md
│   │   │   └── skill.md.hbs            # → .opencode/skills/*/SKILL.md
│   │   └── claude/
│   │       ├── agent.md.hbs             # → .claude/agents/*.md
│   │       └── skill.md.hbs             # → .claude/skills/*/SKILL.md
│   ├── plans/                          # Plan templates
│   │   ├── README.md
│   │   └── plan.md.hbs                  # Template for creating plans
│   └── generate.sh                       # Generator entrypoint
├── scripts/
│   └── generate-agent-boilerplate.sh     # Main script
├── .cursor/                             # Generated
├── .opencode/                           # Generated
│   └── plugins/                        # Gate plugin
└── .claude/                           # Generated (future)
```

## Implementation

### Task 1: Update devbox.json

- Add handlebars CLI via npm (post-install script or documented)

### Task 2: Create .agents/ Directory Structure

- `.agents/data/`
- `.agents/templates/cursor/`
- `.agents/templates/opencode/`
- `.agents/templates/claude/`
- `.agents/plans/`

### Task 3: Create Data Files (YAML)

Create `data/config.yaml`:
```yaml
paths:
  plans:
    cursor: .cursor/plans
    opencode: .opencode/plans
    claude: .claude/plans
  agents:
    cursor: .cursor/agents
    opencode: .opencode/agents
    claude: .claude/agents
  commands:
    cursor: .cursor/commands
    opencode: .opencode/commands
  skills:
    cursor: .cursor/skills
    opencode: .opencode/skills
    claude: .claude/skills
plan:
  filename_pattern: "YYYY-MM-DD_<username>_<slug>.plan.md"
  template: plan.md.hbs
```

Create `data/agents.yaml`:
- @planner (gate: true)
- @config
- @taskfile
- @code-reviewer

Create `data/commands.yaml`:
- kickoff, brainstorm, write-plan, execute-plan, systematic-debugging, finish-branch, request-code-review

Create `data/skills.yaml`:
- taskfile-validate
- pre-commit-run

### Task 4: Create Handlebars Templates

For each platform, create templates with generation banner:

```hbs
<!--
  ⚠️ GENERATED FILE - DO NOT EDIT DIRECTLY
  Generated from: {{source}}
  Run: ./scripts/generate-agent-boilerplate.sh to regenerate
  Generated: {{timestamp}}
-->
{{content}}
```

Templates needed:
- `templates/cursor/agent.md.hbs`
- `templates/cursor/command.md.hbs`
- `templates/cursor/skill.sh.hbs`
- `templates/opencode/agent.md.hbs`
- `templates/opencode/command.md.hbs`
- `templates/opencode/skill.md.hbs`
- `templates/claude/agent.md.hbs` (future)
- `templates/claude/skill.md.hbs` (future)
- `plans/plan.md.hbs`

### Task 5: Create generate.sh

Features:
- Use `yq` + `handlebars` CLI
- Add generation banner with timestamp and source file
- Support selective regeneration (by platform or type)
- Show file diff of changes

### Task 6: Create scripts/generate-agent-boilerplate.sh

Wrapper with:
- Dependency checks (yq, handlebars)
- Usage help
- Call `.agents/generate.sh`

### Task 7: Create OpenCode Gate Plugin

Create `.opencode/plugins/gate.js`:
- Hook `session.compacted` event
- Validate plan adherence
- Show gate status in UI

### Task 8: Add to Pre-commit/Taskfile

Add task to run generator before commits.

### Task 9: Update AGENTS.md

Reference both `.cursor/` and `.opencode/` workflows.

## Dependencies

- `yq` - Available in devbox
- `handlebars` - Install via npm: `npm install -g handlebars`

## Generation Banner Format

```markdown
<!--
  ⚠️ WARNING: This file is GENERATED from .agents/ source.
  ⚠️ DO NOT EDIT DIRECTLY - changes will be overwritten!

  To modify:
    1. Edit source files in .agents/data/ or .agents/templates/
    2. Run: ./scripts/generate-agent-boilerplate.sh
    3. Commit the generated changes

  Generated: {{timestamp}}
  Source: {{source_file}}
-->
```

## Notes

- Plans saved in `.agents/plans/` serve as templates for all platforms
- Each platform's planner agent saves plans to their respective `plans/` directory
- Generator ensures consistency across all platforms
- IDEs will warn users about editing generated files directly
