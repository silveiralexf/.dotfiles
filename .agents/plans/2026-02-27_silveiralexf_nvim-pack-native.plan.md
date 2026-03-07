# Neovim: vim.pack-native (no LazyVim, no lazy.nvim)

**Goal:** Replace LazyVim with Neovim's built-in **vim.pack** (0.12+). No external plugin manager; lockfile and updates handled by vim.pack; modular `lua/plugins/*.lua` aggregated by our `pack.lua`.

**Why:** Isolation from upstream distro churn; semver pins and lockfile; PackChanged hooks; optional lazy loading via our autocmd layer.

---

## Constraints (mandatory)

- **Keep things working as they are** - Do not break current behavior. The vim.pack setup must provide feature parity (LSP, completion, Noice, Yazi, formatting, etc.) before we consider it done.
- **Do not change keybindings** - Preserve all existing keymaps. Migrate plugin config and lazy triggers so that the same keys and commands behave the same. No new leader or keymap scheme; match current `lua/config/keymaps.lua` and plugin-defined keymaps.
- **Work on a new branch** - All vim.pack-native work happens on a dedicated branch (e.g. `feat/nvim-pack-native`). Do **not** push these changes to `main` until the new setup is validated and working. Merge to main only after: nvim starts cleanly, keybindings match, LSP/completion/Noice/Yazi/formatting work, lockfile committed, and tests pass.

---

## vim.pack API (from pack.txt - reference)

- **Directory:** All managed plugins live under `$XDG_DATA_HOME/nvim/site/pack/core/opt/`. Subdir name = plugin `name` in spec. Managed exclusively by vim.pack.
- **Lockfile:** `$XDG_CONFIG_HOME/nvim/nvim-pack-lock.json`. JSON; track in version control; don't edit by hand. Initial install prefers lockfile revision when present.
- **Requirements:** Git ≥ 2.36; plugins are Git repos; semver tags `v<major>.<minor>.<patch>` recommended.

**vim.pack.Spec**

| Field      | Type                       | Description                                                                                   |
| ---------- | -------------------------- | --------------------------------------------------------------------------------------------- |
| `src`      | string                     | URI for `git clone` (required).                                                               |
| `name`?    | string                     | Plugin name = directory name. Default: repo name from `src`.                                  |
| `version`? | string \| vim.VersionRange | `nil` = default branch; string = branch/tag/commit; or `vim.version.range('1.0')` for semver. |
| `data`?    | any                        | Arbitrary data.                                                                               |

**Functions**

- **vim.pack.add(specs, opts?)**

  - Ensures each plugin exists on disk (clone + checkout if not).
  - Then runs `:packadd` (or custom `opts.load`) so plugin is loadable.
  - `opts.load`: `boolean` or `fun(plug_data)`. `false` = like `:packadd!` (don't load yet). Default: `false` at startup, `true` afterwards.
  - `opts.confirm`: ask before first install (default `true`).
  - Adding the same plugin again in one session is a no-op.

- **vim.pack.update(names?, opts?)**

  - Fetch and update; show confirmation buffer (pending changes `>` apply, `<` revert). `]]`/`[[` navigate; `:write` confirm, `:quit` discard.
  - `opts.force = true`: apply updates without confirmation.
  - Logs to `log` stdpath in `nvim-pack.log`.

- **vim.pack.del(names)** - Remove plugins from disk.

- **vim.pack.get(names?, opts?)** - Return list of plugin info (active, path, rev, spec, branches?, tags?).

**Events**

- **PackChangedPre** - Before changing plugin state.
- **PackChanged** - After plugin state changed.
  Event data: `kind` (install | update | delete), `spec`, `path`.

---

## What we build on top (lazy triggers)

Spec has no `event`/`ft`/`cmd`/`keys`. All plugins live in **opt**, so they are not auto-loaded. We add:

- **Eager plugins:** Call `vim.pack.add(specs, { load = true, confirm = false })` at startup for plugins that must load immediately.
- **Lazy plugins:** Call `vim.pack.add(specs, { load = false, confirm = false })` at startup so they are installed but not loaded. In `pack.lua`, for each plugin that declares `lazy = { ft = {...}, cmd = {...}, keys = {...} }`, register autocmds or keymaps that run `vim.cmd.packadd(name)` (or call `vim.pack.add({spec}, { load = true })`) when the trigger fires.

---

## Target layout (command-style)

1. **init.lua**

   - Leader, options, keymaps (minimal set that must run before plugins). **Reuse existing** `lua/config/options.lua` and `lua/config/keymaps.lua` so keybindings stay identical.
   - `vim.opt.rtp:prepend(vim.fn.stdpath('config') .. '/lua/local')` so `lua/local/` overrides/extensions load first.
   - `require('pack')` to register all vim.pack specs and lazy triggers.

2. **lua/pack.lua**

   - Glob `lua/plugins/*.lua` (and optionally `lua/lsp/*.lua`).
   - Each module returns a list of **pack specs** (and optional `lazy` table).
   - Flatten and pass to `vim.pack.add(specs, { load = false, confirm = false })` for lazy-capable plugins; for eager, use `load = true`.
   - For specs with `lazy`, register autocmds (FileType, BufReadPost) or command/callback that runs `vim.cmd.packadd(name)` when trigger fires.

3. **lua/plugins/\*.lua**

   - Each file returns `{ specs = {...}, lazy = {...} }` or just `{ specs = {...} }`.
   - `specs`: `vim.pack.Spec` table(s) (src, name?, version?).
   - `lazy`: optional `{ ft = {'lua'}, cmd = {'NoiceStats'}, keys = {'<leader>n'} }` used by pack.lua to register packadd-on-trigger.

4. **lua/local/**

   - Custom extensions (e.g. `noice-ext.lua` that tweaks Noice). Loaded first via rtp prepend.

5. **nvim-pack-lock.json**

   - Managed by vim.pack. Commit it for reproducible installs.

6. **PackChanged / PackChangedPre**
   - Use autocmds to notify or run hooks (e.g. "Noice updated - check changelog") when `ev.kind == 'update'` and `ev.spec.name` is in a critical list.

---

## Implementation tasks (bite-sized; for execute-plan and code-review)

**Plan reference:** `.cursor/plans/2026-02-27_silveiralexf_nvim-pack-native.plan.md`

### Task 1: Branch and prereqs

**Files:** (none; git only)

**Steps:** (1) Create branch `feat/nvim-pack-native`; ensure nvim config committed on it. (2) Confirm Neovim 0.12+ and Git ≥ 2.36 (doc or check).

### Task 2: Implement lua/pack.lua aggregator

**Files:** Create: `nvim/lua/pack.lua`

**Steps:** (1) Glob `lua/plugins_pack/*.lua`. (2) Each module returns `{ specs = {...}, lazy = {...} }`; flatten specs. (3) Call `vim.pack.add(eager_specs, { load = true, confirm = false })` and `vim.pack.add(lazy_specs, { load = false, confirm = false })`. (4) For specs with `lazy`, register autocmds/keymaps that run `vim.cmd.packadd(name)` (ft, cmd, keys). (5) Guard: if `vim.pack` missing, no-op or notify.

### Task 3: Rewrite init.lua (strip LazyVim, keep options/keymaps/autocmds)

**Files:** Modify: `nvim/init.lua`; Modify: `nvim/lua/config/options.lua` (remove LazyVim-only option if any)

**Steps:** (1) Set leader/localleader; `rtp:prepend(.../lua/local)`. (2) `require('config.options')`, `require('config.keymaps')`, `require('config.autocmds')`. (3) `require('pack').setup()`. (4) No `require('config.lazy')`. Optional: which-key setup after pack.

### Task 4: Add first pack plugin module(s)

**Files:** Create: `nvim/lua/plugins_pack/whichkey.lua`

**Steps:** (1) Return `{ specs = { { src = '...', name = '...' } } }` for which-key.nvim. (2) Eager so keymaps work at startup.

### Task 5: PackChanged autocmds

**Files:** Modify: `nvim/lua/pack.lua`

**Steps:** (1) Register User autocmd for `PackChanged`. (2) On `kind == 'update'` and spec.name in critical list (Noice, Yazi, treesitter), notify.

### Task 6: Document pack-native in nvim/README.md

**Files:** Modify: `nvim/README.md`

**Steps:** (1) Add "Pack-native (WIP)" note and link to this plan. (2) Update directory tree to include `pack.lua` and `plugins_pack/`.

### Task 7: First run and lockfile

**Files:** Add (if generated): `nvim/nvim-pack-lock.json`

**Steps:** (1) Start nvim; let vim.pack create/update lockfile. (2) Commit lockfile on branch.

### Task 8+: Migrate remaining plugins / lua/local / Validate

Deferred: more `plugins_pack/*.lua`, `lua/local/`, full validation before merge. Per execution order 7-9.

---

## Execution order (vim.pack-native)

0. **Branch** - Create a new branch (e.g. `feat/nvim-pack-native`). All following work stays on this branch. Do not push to `main` until the new setup is validated and working.

1. **Backup** - Ensure current nvim config is committed on the new branch; have Neovim 0.12+ and Git ≥ 2.36.

2. **init.lua** - Strip LazyVim/lazy.nvim. Keep leader and **existing** options/keymaps (source `lua/config/options.lua`, `lua/config/keymaps.lua`, `lua/config/autocmds.lua` as today so keybindings are unchanged). Add `rtp:prepend(.../lua/local)`; `require('pack')`.

3. **lua/pack.lua** - Implement aggregator: collect specs from `lua/plugins/*.lua` (and lsp if desired); call `vim.pack.add(all_specs, { load = false, confirm = false })`. For each spec with `lazy`, register autocmds/keymaps that call `vim.cmd.packadd(name)` on trigger. Optionally support an "eager" list and call `vim.pack.add(eager_specs, { load = true, confirm = false })`.

4. **lua/plugins/** - Add a few modules (e.g. noice.lua, yazi.lua, lsp.lua) that return `{ specs = { {...} }, lazy = {...} }` using real `vim.pack.Spec` (src, name, version). Use `vim.version.range('*')` or a fixed tag where needed. When wiring config, preserve existing keymaps from current plugin configs.

5. **First run** - Start nvim; let vim.pack install to `pack/core/opt/` and create/update `nvim-pack-lock.json`. Commit lockfile on the branch.

6. **PackChanged** - Register `PackChangedPre`/`PackChanged` autocmds; for `kind == 'update'` and critical plugins (Noice, Yazi, treesitter), notify or run a hook.

7. **Migrate remaining plugins** - Convert each current LazyVim/lazy plugin to a pack spec (src = GitHub URL, name = repo name or custom, version = branch/tag/range). Add lazy triggers in pack.lua where needed. **Keep keybindings and plugin options aligned with current behavior.**

8. **lua/local/** - Add overrides (e.g. noice-ext.lua). Document in nvim/README.md: add plugin, update workflow (`:lua vim.pack.update()` or selective), lockfile, and PackChanged hooks.

9. **Validate** - No LazyVim/lazy.nvim; `:checkhealth`; LSP, keymaps (unchanged), Noice, Yazi, completion work; cross-platform (macOS + Linux); `task test:lua` if applicable. Only then consider merging to `main`.

---

## LazyVim → vim.pack spec mapping

| LazyVim / lazy.nvim     | vim.pack.Spec / usage                                                                                                |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `'user/repo'`           | `{ src = 'https://github.com/user/repo' }`                                                                           |
| `name = 'custom'`       | `{ src = '...', name = 'custom' }`                                                                                   |
| `version = 'v1.2.3'`    | `{ src = '...', version = 'v1.2.3' }` or `version = vim.version.range('1.0')`                                        |
| `event = 'BufReadPost'` | No direct field; in our layer: `lazy = { event = 'BufReadPost' }` → pack.lua registers BufReadPost and runs packadd. |
| `ft = 'lua'`            | `lazy = { ft = {'lua'} }` → FileType lua → packadd.                                                                  |
| `cmd = 'NoiceStats'`    | `lazy = { cmd = {'NoiceStats'} }` → CmdUndefined or custom → packadd.                                                |

---

## Validation

- No `LazyVim` or `lazyvim.plugins` or `require('lazy')` in config.
- **Keybindings unchanged** - Same leader, same keymaps as current config.
- `nvim` starts; plugins live under `$XDG_DATA_HOME/nvim/site/pack/core/opt/`; `nvim-pack-lock.json` present and in version control.
- `:lua vim.pack.update()` shows confirmation buffer; PackChanged fires on update.
- LSP, keymaps, formatting, completion, Noice, Yazi behave as required; cross-platform; tests pass.
- **Merge to main only after** the above is satisfied on the feature branch.
