#!/usr/bin/env bash
# WARNING: GENERATED -- DO NOT EDIT DIRECTLY
# Source: .agents/skills/taskfile-validate.sh
# Regenerate: ./scripts/generate-agents.sh

# Validate Taskfile: run task --list to ensure schema and deps are valid
set -e
cd "${DOTFILES_HOME:-$HOME/.dotfiles}"
task --list >/dev/null
