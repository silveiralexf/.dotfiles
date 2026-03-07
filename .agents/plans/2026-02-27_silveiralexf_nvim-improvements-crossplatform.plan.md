# Neovim config improvements and cross-platform plan

**Goal:** Fix bugs, unify LSP/keymap patterns, and ensure the same Neovim config works on macOS (work), Omarchy Linux (desktop), and Ubuntu Linux (VPS) without OS-specific breakage.

**Areas:** nvim/

**Cross-platform requirement:** One config for all three environments; no hardcoded OS paths or OS-only commands. Prefer `vim.env.HOME` / `vim.fn.expand()`, PATH-based binaries, and runtime detection for things that must differ (e.g. URL opener).

---

## Phase 1: Bugs (must fix)

### Task 1.1: Fix Python LSP - ruff_lsp not registered

**Files:**
- Modify: `nvim/lua/lsp/servers/python.lua`

**Steps:**
1. Remove the nested plugin table inside `servers` (the second element `{ 'neovim/nvim-lspconfig', opts = { ... } }`).
2. Add `ruff_lsp = {}` (or desired opts) as a sibling of `pyright` under `servers`, so both are registered.

### Task 1.2: Fix Proto LSP - detach clangd on buffer

**Files:**
- Modify: `nvim/lua/config/autocmds.lua`

**Steps:**
1. In the `FileType proto` autocmd, remove the use of `args.data.client_id` (FileType does not provide it).
2. Keep only `vim.lsp.start({ name = 'proto', ... })` in the FileType handler.
3. Add an `LspAttach` autocmd that, when `client.name == 'proto'`, detaches any `clangd` client from the same buffer (by iterating `vim.lsp.get_clients({ bufnr = args.buf })` and calling `vim.lsp.buf_detach_client` for clangd).

### Task 1.3: Replace rust.lua dependency on missing `helpers` module

**Files:**
- Modify: `nvim/lua/lsp/servers/rust.lua`

**Steps:**
1. Replace `require('helpers').augroup('CargoCrates')` with `vim.api.nvim_create_augroup('CargoCrates', { clear = true })`.
2. Replace `require('helpers').map(...)` with `vim.keymap.set(...)` (or a local inline wrapper) for the crates keymaps.

---

## Phase 2: Cross-platform (macOS + Linux)

### Task 2.1: Use portable paths in options and lua_ls

**Files:**
- Modify: `nvim/lua/config/options.lua`
- Modify: `nvim/lua/lsp/servers/lua.lua`

**Steps:**
1. In **options.lua**: Replace `os.getenv('HOME')` with `vim.env.HOME` or `vim.fn.expand('~')` for `rtp` and `undodir` so behavior is consistent on all platforms.
2. In **lua.lua**: Replace hardcoded `/home/hiphish/.luarocks/...` and `/usr/share/...` with portable paths:
   - Use `vim.fn.expand('$HOME/.luarocks/share/lua/5.4/?.lua')` (and `?/init.lua` variant) so it works on macOS and Linux.
   - Optionally add `/usr/share/...` only when the path exists (e.g. via `vim.fn.glob`) or document that Linux system Lua paths are optional; prefer a single portable list so macOS and Linux behave the same.

### Task 2.2: Terraform - portable binary path and URL opener

**Files:**
- Modify: `nvim/lua/lsp/servers/terraform.lua`

**Steps:**
1. **terraform binary:** Replace hardcoded `path = '/opt/homebrew/bin/terraform'` with a cross-platform value:
   - Either omit `terraform.path` so terraformls uses `terraform` from PATH (same on macOS and Linux if installed via brew/apt/volta), or
   - Set `path` to `vim.fn.exepath('terraform')` or derive from PATH so it works on macOS (Homebrew), Omarchy, and Ubuntu.
2. **treesitter-terraform-doc.nvim:** Make `url_opener_command` OS-dependent:
   - On macOS: `'!open'` (or keep `'!open'`).
   - On Linux: `'!xdg-open'`.
   - Use `vim.loop.os_uname().sysname` (or `vim.uv.os_uname().sysname` on 0.10+) to choose: if `"Darwin"` then `'!open'`, else `'!xdg-open'`.

### Task 2.3: Document and enforce "no OS-specific paths" in nvim

**Files:**
- Create or modify: `nvim/README.md` or add a short "Portability" section to `tasks/README.md` (or `docs/`) under a "Neovim" subsection.

**Steps:**
1. Add a one-paragraph note: Neovim config is intended to work on macOS, Omarchy Linux, and Ubuntu; avoid hardcoded `/opt/homebrew`, `/home/...`, or OS-only commands; use `vim.env.HOME`, `vim.fn.expand()`, and PATH where possible.
2. Optionally add a small checklist in the plan or README: paths use `$HOME`/expand, binaries from PATH or runtime detection, URL opener set by OS.

---

## Phase 3: Consistency and cleanup

### Task 3.1: Unify LSP server spec style (opts.servers only)

**Files:**
- Modify: `nvim/lua/lsp/servers/lua.lua`, `nvim/lua/lsp/servers/go.lua`, and any other server file that uses `config = function() require('lspconfig').setup(...) end`.

**Steps:**
1. Convert each to the same pattern as terraform/rust: a single plugin spec with `opts = { servers = { server_name = { ... } } }` and no `config` that calls `require('lspconfig').setup()`.
2. Ensure LazyVim's merging still loads nvim-lspconfig once and merges all `opts.servers` from every file in `lsp/servers/`.

### Task 3.2: Single source of truth for LSP keymaps

**Files:**
- Modify: `nvim/lua/config/keymaps.lua`
- Modify: `nvim/lua/config/autocmds.lua`

**Steps:**
1. Decide: either (A) global LSP keymaps only in keymaps.lua, or (B) buffer-local only in LspAttach. Recommendation: keep buffer-local in LspAttach for K and gd so they only apply when LSP is attached; remove duplicate global K in keymaps.lua if it matches, or document that keymaps.lua defines fallbacks and LspAttach overrides for buffers with LSP.
2. Remove or consolidate duplicate definitions so one place is authoritative (e.g. LspAttach for K, gd; keymaps.lua for @d, @r, etc. if desired).

### Task 3.3: Autocmd and comment cleanup

**Files:**
- Modify: `nvim/lua/config/autocmds.lua`

**Steps:**
1. Fix the comment that says "Golang" for the kustomization.yaml filetype (it's YAML, not Go).
2. Optionally group autocmds by named augroup (e.g. `last_loc`, `FileType`, `LspAttach`, `ColorScheme`) for clarity and easier toggling.

---

## Phase 4: Optional polish

- **Mason:** Centralize `ensure_installed` in one place if desired; server files only add opts.
- **Which-key:** Fill empty `desc` groups for NeoTest, GitSigns, ModelMate in `keymaps.lua` so which-key shows them.
- **Tests:** Extend `tests/spec/nvim_keymaps_spec.lua` (or add) to cover LSP and FzfLua keymaps so regressions are caught.

---

## Execution order

1. Phase 1 (Tasks 1.1-1.3) - bugs first.
2. Phase 2 (Tasks 2.1-2.3) - cross-platform so macOS, Omarchy, and Ubuntu behave the same.
3. Phase 3 (Tasks 3.1-3.3) - consistency and cleanup.
4. Phase 4 - as time permits.

**Validation:** After changes, run `task test:lua` and open the same project on macOS and one Linux (e.g. Ubuntu) to confirm LSP, keymaps, and terraform/lua_ls behavior match.
