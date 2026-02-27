# Install tasks

## Cross-platform (macOS + Linux): Devbox

Use **Devbox** to get the same CLI tools on both macOS and Linux. No Homebrew on Linux required.

```bash
task devbox:install-cli   # one-time: install Devbox (and Nix if needed)
task devbox:install       # install packages from devbox.json
task devbox:shell         # enter shell with all tools on PATH
```

`devbox.json` at the repo root lists cross-platform tools that mirror what `tasks/macos/install` installs via Brew, Go, and Rust where those tools exist in nixpkgs (e.g. go-task, pre-commit, jq, shellcheck, git-cliff, yamlfmt, fd, ripgrep, eza, zoxide, tmux, yazi, atuin, delta, taplo, nodejs, python3, pipx). Neovim is not in devbox; use nightly via `task common:install:core:nvim` or `task macos:install:core:nvim` (installs to `/opt/nvim` on macOS or `~/.local/nvim` with `~/.local/bin/nvim` on Linux — ensure `~/.local/bin` is on PATH). If a package fails to install, run `devbox search <name>` and adjust the package name in `devbox.json` if needed.

## Shared core: tasks/common/install/core

Runs on **macOS and Linux**. Use this for a single flow on both (fzf, Lua, Neovim nightly, profile symlinks). No Rosetta.

| Task | What it does |
|------|----------------|
| **common:install:core:all** | fzf, lua (from source), nvim nightly, profile (dirs, links, ~/.zshrc). |
| **common:install:core:nvim** | Neovim nightly (darwin → /opt/nvim, linux → ~/.local/nvim + ~/.local/bin/nvim). |

Profile links: ~/.config/nvim, yazi, tmux, terminalizer, p10k, atuin, lazygit (~/.config/lazygit). No macOS-only links (e.g. AeroSpace, Library/Application Support).

## Linux: tasks/linux/install/apt

**Debian/Ubuntu only.** Installs base OS packages via apt (e.g. build-essential, curl, jq, nodejs, python3, fzf, zoxide, pre-commit). Uses `eatmydata` when available for non-interactive install.

```bash
task linux:install:apt:all   # apt packages only
task linux:install:all      # apt + common core (recommended on Linux)
```

## macOS-only: tasks/macos/install

These run on **macOS only**. They use Homebrew, system paths, and macOS-specific installers.

| Taskfile | What it installs |
|----------|-------------------|
| **brew** | Homebrew formulae (trivy, buf, fd, tmux, wezterm, yazi, go-task, pre-commit, …), taps, fonts, casks (AeroSpace, Colima). |
| **core** | Rosetta2, fzf, Neovim nightly (same as common), profile (includes macOS-only links e.g. AeroSpace, lazygit under Library). |
| **go** | Go toolchain (darwin pkg), then `go install` for air, scc, k9s, golangci-lint, yamlfmt, gopls, shfmt, kubeconform, kustomize, controller-gen, etc. |
| **rust** | rustup, then `cargo install` for atuin, eza, fd-find, git-cliff, git-delta, ripgrep, taplo, yazi-cli, etc. |
| **java** | BFG jar, SDKMan, Java LTS, Maven. |
| **k8s** | kubebuilder, operator-sdk, kustomize, k3d, Tilt (darwin/linux binaries). |
| **docker** | Rancher Desktop (.dmg), Docker Buildx (darwin binary). |
| **hammerspoon** | Hammerspoon Spoons (macOS only). |

## Summary

- **Same on both OSes:** `task devbox:install-cli` → `task devbox:install` → `task devbox:shell`. Then `task precommit`, `devbox run precommit`, and all devbox CLIs work the same.
- **Linux (Debian/Ubuntu):** `task linux:install:all` (apt + common core), or Devbox for CLIs and `task common:install:core:all` for fzf/lua/nvim/profile. Add `~/.local/bin` to PATH for Neovim.
- **macOS only:** `task macos:install:all` (or per-area tasks) for system-wide Brew, Neovim nightly, Hammerspoon, Rancher, Java, etc. Optional if you rely on devbox for CLIs.
