# Install tasks

## Cross-platform (macOS + Linux): Devbox

Use **Devbox** to get the same CLI tools on both macOS and Linux. No Homebrew on Linux required.

```bash
task devbox:install-cli   # one-time: install Devbox (and Nix if needed)
task devbox:install       # install packages from devbox.json
task devbox:shell         # enter shell with all tools on PATH
```

`devbox.json` at the repo root lists cross-platform tools that mirror what `tasks/macos/install` installs via Brew, Go, and Rust where those tools exist in nixpkgs (e.g. go-task, pre-commit, jq, shellcheck, git-cliff, yamlfmt, fd, ripgrep, eza, zoxide, tmux, yazi, atuin, delta, taplo, nodejs, python3, pipx). Neovim is not in devbox; use nightly via `task macos:install:core:nvim` (works on macOS and Linux; installs to `/opt/nvim` on macOS or `~/.local/nvim` with `~/.local/bin/nvim` on Linux — ensure `~/.local/bin` is on PATH). Same environment on macOS and Linux. If a package fails to install, run `devbox search <name>` and adjust the package name in `devbox.json` if needed.

## macOS-only: tasks/macos/install

These run on **macOS only**. They use Homebrew, system paths, and macOS-specific installers.

| Taskfile | What it installs |
|----------|-------------------|
| **brew** | Homebrew formulae (trivy, buf, fd, tmux, wezterm, yazi, go-task, pre-commit, …), taps, fonts, casks (AeroSpace, Colima). |
| **core** | Rosetta2, fzf, Neovim nightly (macOS or Linux tarball), profile dirs and symlinks (~/.config/nvim, ~/.zshrc, lazygit, etc.). |
| **go** | Go toolchain (darwin pkg), then `go install` for air, scc, k9s, golangci-lint, yamlfmt, gopls, shfmt, kubeconform, kustomize, controller-gen, etc. |
| **rust** | rustup, then `cargo install` for atuin, eza, fd-find, git-cliff, git-delta, ripgrep, taplo, yazi-cli, etc. |
| **java** | BFG jar, SDKMan, Java LTS, Maven. |
| **k8s** | kubebuilder, operator-sdk, kustomize, k3d, Tilt (darwin/linux binaries). |
| **docker** | Rancher Desktop (.dmg), Docker Buildx (darwin binary). |
| **hammerspoon** | Hammerspoon Spoons (macOS only). |

On **Linux**, use Devbox for CLI tools. Run `task macos:install:core:nvim` for Neovim nightly (installs to `~/.local/nvim`, symlinked at `~/.local/bin/nvim`). For things not in devbox (e.g. Docker, Java, optional K8s tooling), use your distro packages or official installers; the dotfiles configs (etc/, nvim/, wezterm/, …) still apply.

## Summary

- **Same on both OSes:** `task devbox:install-cli` → `task devbox:install` → `task devbox:shell` (or `devbox shell`). Then `task precommit`, `devbox run precommit`, and all devbox-provided CLIs work the same.
- **macOS only:** Run `task macos:install:all` (or per-area tasks) when you want system-wide Brew, Neovim nightly, Hammerspoon, Rancher, Java, etc. Optional if you rely on devbox for CLIs.
