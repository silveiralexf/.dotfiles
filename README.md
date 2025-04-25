<!-- markdownlint-disable MD041 -->

# dotfiles

[![wakatime](https://wakatime.com/badge/github/silveiralexf/.dotfiles.svg)](https://wakatime.com/badge/github/silveiralexf/.dotfiles)

## 💻 What's in here?

| Name                                   | Description                                                                        |
| -------------------------------------- | ---------------------------------------------------------------------------------- |
| [nvim](./nvim/README.md)               | LazyVim Configs                                                                    |
| [wezterm](./wezterm/README.md)         | Wezterm configs                                                                    |
| [hammerspoon](./hammerspoon/README.md) | Hammerspoon configs, custom shortcuts/keybindings, and personal Spoons             |
| [tmux](./tmux/README.md)               | Tmux configs and plugins                                                           |
| [yazi](./yazi/README.md)               | Yazi configs                                                                       |
| [etc](./etc/config)                    | Shell profile, rcfiles, aliases, exports and functions and config files in general |
| [scripts](./scritps/)                  | Misc scripts for every-day stuff                                                   |
| [tasks](./tasks/)                      | Taskfiles to automate install and configuration steps                              |

## 🔨 How to Install?

Install steps and setup configuration are automated with [Taskfile runner](https://github.com/go-task/task/).

This is the only requirement that needs to be manually installed, all the
remaining dependencies are controlled and customized from the main [Taskfile.yml](./Taskfile.yml).

Run `task` to view the complete list of tasks currently available:

```bash
task: Available tasks for this project:
* changelog:                                  Generates CHANGELOG
* hooks:                                      Setup git hooks locally
* list:                                       Lists available commands
* precommit:                                  Verifies and fix requirements for new commits
* macos:install:all:                          Install all MacOS required tools
* macos:install:brew:all:                     Brew install all packages
* macos:install:brew:all:custom:              Brew install recipes with custom steps
* macos:install:brew:all:custom:colima:       Brew install Colima
* macos:install:brew:all:deps:                Install Brew itself along with some important libs and repos
* macos:install:brew:all:fonts:               Install Nerd-Fonts
* macos:install:brew:all:regular:             Brew install regular recipes
* macos:install:core:all:                     Setup shell, core settings and tools
* macos:install:core:fzf:                     Install FuzzyFinder
* macos:install:core:nvim:                    Install NVIM nightly build
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
```
