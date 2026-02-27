#!/usr/bin/env bash
# Validate Taskfile: run task --list to ensure schema and deps are valid
set -e
cd "${DOTFILES_HOME:-$HOME/.dotfiles}"
task --list >/dev/null
