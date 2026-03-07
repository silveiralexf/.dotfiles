# nvim

<a href="https://dotfyle.com/silveiralexf/dotfiles-nvim"><img src="https://dotfyle.com/silveiralexf/dotfiles-nvim/badges/plugins?style=flat" alt="badge-plugins" /></a>
<a href="https://dotfyle.com/silveiralexf/dotfiles-nvim"><img src="https://dotfyle.com/silveiralexf/dotfiles-nvim/badges/plugin-manager?style=flat" alt="badge-plugin-manager-name" /></a>

My personal Neovim configurations.

**Pack-native (WIP):** On branch `feat/nvim-pack-native`, plugins are managed by Neovim's built-in **vim.pack** (0.12+) instead of LazyVim. See [.cursor/plans/2026-02-27_silveiralexf_nvim-pack-native.plan.md](../.cursor/plans/2026-02-27_silveiralexf_nvim-pack-native.plan.md). Entry: `init.lua` → `require('pack').setup()`; each `lua/plugins/*.lua` must return `{ specs = { { src = '...', name = '...' } }, config = function() ... end }` for pack to install and load it. **Only files that have a `specs` table with at least one entry containing `src` are installed;** files that still use the old Lazy format (`return { { 'author/name', opts = ... } }` without `specs`) are ignored and not loaded.

**Plugins with pack specs (installed/loaded):** cloak, colorscheme, conform, cursoragent, devicons, dressing, editor, fzf, formatting, git, go, indent, kcl, kustomize, lazydev, lsp, lualine, luarocks, matchup, mini, modelmate, neotest, noice, nui, nvim-nio, opencode, plenary, quickfix, spectre, sops, treesitter, trouble, tmux, undotree, wakatime, whichkey, yaml-companion, yazi, zig.

**Plugins without pack specs (intentionally not installed):** disabled.

![preview](../images/nvim_screenshot.png)

Check the reference below on how things are organized:

```bash
 .
├──  init.lua               # Entry (pack-native branch: pack; else LazyVim)
├──  lazy-lock.json
├──  lazyvim.json
├──  README.md
├──  lua
│   ├──  config
│   │   ├──  autocmds.lua    # Autocmds such as file types, LSP attach configs
│   │   ├──  keymaps.lua     # Keybindings
│   │   ├──  lazy.lua
│   │   └──  options.lua     # Neovim global options
│   │
│   ├──  pack.lua            # vim.pack aggregator (pack-native)
│   │
│   ├──  lsp
│   │   ├──  config.lua      # Language server settings
│   │   └──  servers         # Customization per language server
│   │
│   ├──  plugins             # Plugin specs { specs, lazy } (pack-native)
│   │   ├──  colorscheme.lua # Color theme
│   │   ├──  dressing.lua    # Overall aesthetics
│   │   ├──  editor.lua      # Editor settings
│   │   ├──  formatting.lua  # Formatting and visual options in general
│   │   │
│   └──  utils               # Misc utilities
│       └──  luasnip.lua
│
└──  spell                   # Spellchecker dictionary
    ├──  en.utf-8.add
    └──  en.utf-8.add.spl
```

## Portability (macOS + Linux)

This config is intended to work the same on **macOS** (work machine), **Omarchy Linux** (desktop), and **Ubuntu** (e.g. VPS). Avoid hardcoded OS paths (`/opt/homebrew`, `/home/...`) and OS-only commands; use `vim.env.HOME` / `vim.fn.expand('~')` for paths and PATH for binaries. Where behavior must differ (e.g. URL opener), use `vim.uv.os_uname().sysname` (e.g. `open` on Darwin, `xdg-open` on Linux).

## Optional dependencies (fix :checkhealth warnings)

**LuaRocks.nvim** (pack spec in `lua/plugins/luarocks.lua`) installs Lua rocks such as **jsregexp** (LuaSnip) and **fzy**. You must run its build once after the plugin is installed:

```bash
task nvim:luarocks-build
```

Then start Neovim; `luarocks-nvim` will install the rocks listed in its config. Restart Neovim afterward so `package.path` includes them.

For **tree-sitter-cli** (nvim-treesitter):

```bash
task nvim:deps
```

Or install manually: `npm install -g tree-sitter-cli@0.26.1` or `brew install tree-sitter`.

Mason "Composer not available" / "julia not available" are optional language runtimes; install with `brew install composer` or `brew install julia` only if you need PHP or Julia.

## Disclaimer

This setup assumes the following:

- **macOS or Linux** (same config for both; see Portability above).
- [WezTerm](../wezterm/README.md) as terminal.
- [Yazi](../yazi/README.md) for file navigation, instead of `NerdTree` or `NetRw`.
- [Tmux](../tmux/README.md) as terminal multiplexer.
- [LazyVim](https://www.lazyvim.org/) as package manager,
- [Mason](https://github.com/williamboman/mason.nvim/) and [vhyrro/luarocks.nvim](https://github.com/vhyrro/luarocks.nvim) for installing dependencies.
- [blink-cmp](https://github.com/Saghen/blink.cmp),
  [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
  and [tree-sitter](https://github.com/tree-sitter/tree-sitter)
  for LSP configurations, code-completion, syntax-highlighting, etc.
- [Prettier](https://prettier.io/docs/configuration/) for code formatting.

## How to install?

```bash
# Generate timestamp and random string for unique backup names
timestamp=$(date '+%Y%m%d-%H%M%S')
suffix="bak-${timestamp}"

# backup previously existing settings
[ -d ~/.config/nvim ] && mv ~/.config/nvim{,."${suffix}"}

# optional but recommended
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim{,."${suffix}"}
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim{,."${suffix}"}
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim{,."${suffix}"}

# clone the main repo and move nvim configs
# to its default location
git clone https://github.com/silveiralexf/.dotfiles
mv .dotfiles/nvim ~/.config/nvim

# To have all plugins installed just go into
# the directory and start nvim
cd ~/.local/nvim
nvim .
```

## Supported LSPs

All LSPs listed below are fully configured with syntax-highlighting,
auto-completion, formatting, linting and different tweaks:

- angularls
- bashls
- clangd
- cmake
- docker_compose_language_service
- dockerls
- eslint
- golangci_lint_ls
- gopls
- groovyls
- helm_ls
- html
- jdtls
- jsonls
- lua_ls
- marksman
- pylsp
- rust_analyzer
- taplo
- terraformls
- tflint
- tsserver
- volar
- vuels
- yamlls
- zls

### References & Inspirations

A big shout-out to thank the amazing folks, from which I borrowed ideas,
and code to use as starting point for my own personal setup:

- [github.com/yriveiro/nvim-files](https://github.com/yriveiro/nvim-files/tree/lazyvim)
- [hamptonmoore/nvim-glow](https://hamptonmoore.com/posts/nvim-glow/)
- [github.com/jpmcb/nvim-llama](https://github.com/jpmcb/nvim-llama)
