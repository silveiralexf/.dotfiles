<!-- markdownlint-disable MD041 -->

# dotfiles

## 💻 What's in here?

| Name                                   | Description                                                                                                                                       |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [nvim](./nvim/README.md)               | LazyVim Configs                                                                                                                                   |
| [wezterm](./wezterm/README.md)         | Wezterm configs                                                                                                                                   |
| [hammerspoon](./hammerspoon/README.md) | Hammerspoon configs, custom shortcuts/keybindings, and personal Spoons                                                                            |
| [tmux](./tmux/README.md)               | Tmux configs and plugins                                                                                                                          |
| [yazi](./yazi/README.md)               | Yazi configs                                                                                                                                      |
| [etc](./etc/config)                    | Shell profile, rcfiles, aliases, exports and functions and config files in general                                                                |
| [scripts](./scritps/)                  | Misc scripts for every-day stuff                                                                                                                  |
| [tasks](./tasks/)                      | Taskfiles to automate install and configuration steps; see [tasks/README.md](./tasks/README.md) for devbox (macOS + Linux) vs macos-only installs |

## 🔨 How to Install?

Install steps and setup configuration are automated with [Taskfile runner](https://github.com/go-task/task/).

This is the only requirement that needs to be manually installed, all the
remaining dependencies are controlled and customized from the main [Taskfile.yml](./Taskfile.yml).

### Optional: Devbox (cross-platform + reproducible tools)

[Devbox](https://www.jetify.com/devbox/docs/) provides the same CLI tools on **macOS and Linux**, so dotfiles tooling works on both without Homebrew on Linux. It also keeps tools isolated and reproducible. After installing Devbox once:

```bash
task devbox:install-cli   # one-time: install Devbox CLI
task devbox:install       # install deps from devbox.json
task devbox:shell         # enter shell with tools on PATH (or: devbox shell)
```

Inside the devbox shell you can run `task precommit` or `devbox run precommit`. The `.devbox/` directory is gitignored.

Run `task` to view the complete list of tasks currently available:

```bash
task: Available tasks for this project:
* changelog:                                  Generates CHANGELOG
* hooks:                                      Setup git hooks locally
* jsonfmt:                                    Format JSON with jq (sort keys, validate)
* list:                                       Lists available commands
* markdownlint:                               Lint Markdown with markdownlint-cli (.markdownlint.yaml)
* precommit:                                  Verifies and fix requirements for new commits
* yamlfmt:                                    Format YAML files with yamlfmt (install with: go install github.com/google/yamlfmt/cmd/yamlfmt@latest)
* changelog:rewrite-history:                  Rewrite all commit messages to conventional format (DESTRUCTIVE; backup first, then force-push)
* common:install:core:all:                    Setup shell, core settings and tools (cross-platform)
* common:install:core:fzf:                    Install FuzzyFinder
* common:install:core:lua:                    Install Lua from source (for Neovim etc.)
* common:install:core:nvim:                   Install Neovim nightly (macOS or Linux)
* common:install:core:nvim:darwin:            Install Neovim nightly on macOS
* common:install:core:nvim:linux:             Install Neovim nightly on Linux
* common:install:core:profile:                Setup shell profile settings (cross-platform)
* devbox:install:                             Install devbox dependencies (run once after clone or when devbox.json changes)
* devbox:install-cli:                         Install Devbox CLI (required before devbox:install; uses official install script)
* devbox:shell:                               Enter devbox shell with all dev tools on PATH
* linux:install:all:                          Install base packages and core setup on Linux (apt + common core)
* linux:install:apt:all:                      Install base OS packages (Debian/Ubuntu)
* macos:install:all:                          Install all MacOS required tools
* macos:install:brew:all:                     Brew install all packages
* macos:install:brew:all:custom:              Brew install recipes with custom steps
* macos:install:brew:all:custom:colima:       Brew install Colima
* macos:install:brew:all:deps:                Install Brew itself along with some important libs and repos
* macos:install:brew:all:fonts:               Install Nerd-Fonts
* macos:install:brew:all:regular:             Brew install regular recipes
* macos:install:core:all:                     Setup shell, core settings and tools
* macos:install:core:fzf:                     Install FuzzyFinder
* macos:install:core:nvim:                    Install Neovim nightly (macOS or Linux)
* macos:install:core:nvim:darwin:             Install Neovim nightly on macOS
* macos:install:core:nvim:linux:              Install Neovim nightly on Linux
* macos:install:core:profile:                 Setup shell profile settings
* macos:install:core:rosetta:                 Install Rosetta2
* macos:install:docker:all:                   Install Docker and container related tooling
* macos:install:docker:buildx:                Install Docker Buildx
* macos:install:docker:rancher:               Install Rancher Desktop
* macos:install:go:all:                       Install Go and all required modules/utils
* macos:install:go:all:deps:                  Download and Install Go installer
* macos:install:go:all:modules:               Install required go modules
* macos:install:hammerspoon:all:              Install Hammerspoon plugins
* macos:install:hammerspoon:all:spoons:       Install Spoons
* macos:install:java:all:                     Install all Java requirements and tools
* macos:install:java:all:bfg:                 Install BFG Repo-Cleaner
* macos:install:java:all:maven:               Install Maven
* macos:install:java:all:sdkman:              Install SDKMan and Java Latest LTS
* macos:install:k8s:all:                      Setup Kubernetes related tooling
* macos:install:k8s:k3d:                      Install K3d
* macos:install:k8s:kubebuilder:              Installs Kubebuilder
* macos:install:k8s:kustomize:                Install Kustomize
* macos:install:k8s:operator-sdk:             Install Operator-SDK
* macos:install:k8s:tilt:                     Install Tilt
* macos:install:rust:all:                     Install Rust and all required crates
* macos:install:rust:all:crates:              Install required cargo packages
* macos:install:rust:all:deps:                Install rustc and cargo
* nvim:deps:                                  Install optional Neovim deps (tree-sitter-cli; use nvim:luarocks-build for rocks if using LuaRocks plugin)
* nvim:luarocks-build:                        Run LuaRocks.nvim build once (compiles local LuaRocks; then setup() installs rocks)
* nvim:reset:                                 Backup ~/.local/share/nvim, ~/.local/state/nvim, ~/.cache/nvim with timestamped suffix (e.g. nvim.bak-YYYYMMDD-HHMMSS).
* test:lua:                                   Run Lua Gherkin features (byfeature-style output with colors) and Busted specs
* version:next:                               Calculate next semver from conventional commits since last v* tag (feat→minor, fix→patch, breaking→major)
```

## 🚀 Releases

Releases are created by pushing a **tag**:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Use **semver** (`vMAJOR.MINOR.PATCH`). The next version is computed from conventional commits since the last `v*` tag:

- **Major**: commit subject contains `!` (e.g. `feat!:`) or body contains `BREAKING CHANGE`.
- **Minor**: at least one `feat` commit.
- **Patch**: at least one `fix`, `docs`, `chore`, `ci`, etc., or any other commit (defaults to patch when there are commits).

To see the suggested next version before tagging, run from the repo root:

```bash
task version:next
```

Then create and push the tag (e.g. `v0.0.1`):

```bash
V=$(scripts/calc-next-version.sh)
git tag "$V"
git push origin "$V"
```

The release workflow runs `scripts/calc-next-version.sh` (needs only **git** and **bash**; no `jq`) to validate that the pushed tag matches the version calculated from conventional commits. It then:

1. Generates release notes (commits since the previous tag) with `git-cliff`.
2. Creates a GitHub Release with that body.
3. Regenerates the full `CHANGELOG.md` and commits it to the default branch.

All release steps use **devbox** in CI so the same tooling (`git-cliff`, `task`, etc.) is available; the version script itself does not require `jq` or any devbox packages.

If the release workflow does not run when you push a tag, ensure workflow files are on the default branch and Actions are enabled (Settings → Actions).
