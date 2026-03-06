# Lua code analysis and acceptance-driven testing (Gherkin-style)

**Goal:** Analyse Neovim, WezTerm, and other Lua configs; identify improvements; introduce acceptance-driven testing with Gherkin-style scenarios and a clear way to run and extend tests.

**Areas:** `nvim/`, `wezterm/`, `hammerspoon/`, `yazi/`, `.luacheckrc`, `tests/` (new)

---

## 1. Lua codebase overview

| Area            | Location                                                                           | Purpose                                                                 | Host API            |
| --------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------- |
| **Neovim**      | `nvim/init.lua`, `nvim/lua/{config,plugins,lsp,utils}/`                            | LazyVim + custom plugins, LSP, keymaps, options                         | `vim.*`             |
| **WezTerm**     | `wezterm/wezterm.lua`, `wezterm/config/`, `wezterm/events/`, `wezterm/extensions/` | Config loader, appearance, keymaps, events (lazygit, status, backdrops) | `wezterm.*`         |
| **Hammerspoon** | `hammerspoon/init.lua`, `config/`, `extensions/`                                   | macOS automation, keymaps, Spoons                                       | Hammerspoon Lua API |
| **Yazi**        | `yazi/init.lua`                                                                    | File manager config                                                     | YaziConfig          |

- **Neovim:** ~50+ Lua files; bootstrap via `config.lazy`; plugin specs and LSP in `lsp/`; options/keymaps/autocmds in `config/`.
- **WezTerm:** Single entry `wezterm.lua`; chainable loader in `config/init.lua`; events and extensions are required and call `setup()` or return instances.
- **Hammerspoon / Yazi:** Small number of Lua files; loader pattern similar to WezTerm.

---

## 2. Improvement opportunities

- **.luacheckrc:** `include_files` only lists `nvim/*.lua` patterns; **wezterm** and **hammerspoon** are not included. `files['wezterm/utils/backdrops.lua']` should be `wezterm/extensions/backdrops.lua` (path typo).
- **WezTerm backdrops:** Typo `inital` → `initial` in `BackDrops:init()`.
- **Hardcoded paths:** e.g. `wezterm/events/trigger-lazygit.lua` uses `LAZY_BIN = '/opt/homebrew/bin/lazygit'` (macOS-only); consider env or config.
- **Testability:** Most modules depend on global host APIs (`vim`, `wezterm`). To test logic in isolation we can: (1) extract pure functions into small modules and test those, (2) use mocks/stubs in tests, (3) treat acceptance scenarios as "contracts" and run them via a test runner that can load config in a sandbox or headless environment where feasible.
- **Consistency:** Nvim uses `map()` wrapper and LazySpec tables; WezTerm uses a loader with `:append()`. Documenting expected patterns in a short CONTRIBUTING or README in each area helps.

---

## 3. Acceptance-driven test strategy (Gherkin-style)

- **Scenarios** are written in **Gherkin** (`.feature` files): `Feature`, `Scenario`, `Given`/`When`/`Then` (and `And`).
- **Step definitions** are implemented in **Lua** and map to those steps; they can call into config modules (with mocks where needed) or assert on parsed config.
- **Runner:** Lua has no standard Gherkin runtime. Two practical options:
  - **Option A - Busted + Gherkin-like structure:** Keep `.feature` files as the single source of truth for acceptance criteria; write Busted tests that mirror each scenario (e.g. one `describe` per feature, `it('Given X When Y Then Z')`) and call shared step helpers. CI runs `busted`.
  - **Option B - Minimal feature runner:** A small Lua script that parses `.feature` files, matches steps to a registry of Lua functions, and runs them. More work but keeps strict Given/When/Then in one place.
- **Recommendation:** Start with **Option A** (Busted + `.feature` as documentation + Busted tests as the executable specification). Add a single source of truth by generating or syncing Busted tests from `.feature` later if desired.

---

## 4. What to test (acceptance level)

- **WezTerm loader:** Given a config chain, when options are appended, then no duplicate keys (or duplicates are logged); when a module returns a table, then it's merged as expected.
- **WezTerm backdrops:** Given a list of files, when cycling forward/back or setting by index, then `current_idx` and (in tests) returned state or mocks behave as specified; edge cases (empty list, index out of range).
- **WezTerm trigger-lazygit:** Given the event is registered, when triggered, then the action uses the expected binary path (or configurable value).
- **Neovim keymaps:** Given the keymaps module is loaded (or parsed), when we inspect the keymap table, then certain keys (e.g. `<leader>k`, LSP keys) are present with expected RHS or description. (Can be tested by requiring the module with a mocked `vim`.)
- **Neovim options:** Given options are applied, then a known subset (e.g. `expandtab`, `number`) has expected values.
- **Lua config loading:** Given `nvim/lua/config/lazy.lua` or `wezterm/config/init.lua`, when we require them in a test with mocks, then they don't error and (where possible) return or extend config as expected.

Scenarios should be **small and focused** (one behaviour per scenario).

---

## 5. Tasks (bite-sized)

### Task 1: Fix .luacheckrc and extend to WezTerm/Hammerspoon

**Files:** Modify: `.luacheckrc`

**Steps:**

1. Add `wezterm/**/*.lua` and `hammerspoon/**/*.lua` (or equivalent globs) to `include_files` so Luacheck runs on all Lua in those trees.
2. Replace `files['wezterm/utils/backdrops.lua']` with `files['wezterm/extensions/backdrops.lua']` and keep or adjust ignore as needed.
3. Add `wezterm` (and if needed `hs` for Hammerspoon) to `globals` so Luacheck doesn't report them as undefined.
4. Run `luacheck nvim wezterm hammerspoon` and fix any new warnings that are straightforward (or document exceptions).

### Task 2: Fix typo in WezTerm backdrops

**Files:** Modify: `wezterm/extensions/backdrops.lua`

**Steps:**

1. In `BackDrops:init()`, rename the local variable `inital` to `initial`.

### Task 3: Add tests directory and Gherkin-style feature files

**Files:** Create: `tests/README.md`, `tests/features/wezterm_loader.feature`, `tests/features/wezterm_backdrops.feature`, `tests/features/nvim_keymaps.feature` (examples)

**Steps:**

1. Create `tests/` at repo root and `tests/features/` for `.feature` files.
2. Add `tests/README.md` explaining: (1) acceptance-driven approach, (2) that `.feature` files are the human-readable spec, (3) that Busted tests (or a small runner) implement the steps.
3. Write 2-3 example `.feature` files (e.g. WezTerm loader merge behaviour, Backdrops cycle/set_img behaviour, Neovim keymap presence). Use classic Gherkin: Feature, Scenario, Given/When/Then.

### Task 4: Add Busted and step-definition layout for WezTerm

**Files:** Create: `tests/spec/wezterm_loader_spec.lua`, `tests/spec/wezterm_backdrops_spec.lua`, optional `tests/step_helpers/wezterm.lua`; Create or update: `tests/busted_runner.sh` or `Makefile`/task to run `busted tests/spec`.

**Steps:**

1. Add a way to run Busted (e.g. `luarocks install busted`, or use devbox/nix busted if available). Document in `tests/README.md`.
2. Implement WezTerm loader spec: mock `wezterm` table (minimal), require `config.init` (WezTermLoader), call `:append()` with two tables (second has one duplicate key), assert no overwrite and that duplicate is logged or preserved as per design.
3. Implement Backdrops spec: either (a) extract a pure "cycle index" / "set_img index" helper and test it, or (b) mock `wezterm` (read_dir, GLOBAL, log_error) and require backdrops, then drive `:cycle_forward`, `:cycle_back`, `:set_img` and assert on state or mock calls.
4. Add a task in `Taskfile.yml` (e.g. `test:lua` or `test:busted`) that runs the Busted specs so CI/pre-commit can call it.

### Task 5: (Optional) Neovim keymap / options specs with vim mock

**Files:** Create: `tests/spec/nvim_keymaps_spec.lua` (and optionally options), `tests/mocks/vim.lua` (minimal stub)

**Steps:**

1. Provide a minimal `vim` mock (e.g. `vim.keymap.set` recording calls, `vim.opt` as table) so that requiring `nvim/lua/config/keymaps.lua` doesn't need a real Neovim.
2. Write a Busted spec that requires keymaps (with mock) and asserts that a known key (e.g. `<leader>k`) was registered with expected RHS or desc.
3. Optionally do the same for a subset of options in `nvim/lua/config/options.lua`. Document in `tests/README.md` that Neovim tests use mocks and don't start a full Neovim.

### Task 6: Document and wire test run

**Files:** Modify: `tasks/README.md` or root `README.md`; Modify: `Taskfile.yml`

**Steps:**

1. Add a short "Testing Lua config" section: link to `tests/README.md`, how to run Busted, how to add new `.feature` and corresponding spec.
2. Ensure `task test:lua` (or chosen name) runs Busted and exits non-zero on failure so pre-commit or CI can use it.

---

## 6. Success criteria (acceptance)

- Luacheck runs on `nvim`, `wezterm`, and `hammerspoon` Lua and passes (or documented exceptions).
- Typo `inital` fixed in WezTerm backdrops.
- At least 2-3 `.feature` files exist and describe WezTerm loader, Backdrops, and (optionally) Neovim keymaps.
- Busted specs exist that implement those scenarios and pass when run with `busted tests/spec` (or equivalent).
- `task test:lua` (or similar) runs the Lua tests; README and tasks doc explain the acceptance-driven approach and how to add scenarios.

---

## 7. Out of scope (for this plan)

- Full Neovim plugin tests inside Neovim (e.g. plenary.test or luatest in-process); we focus on config and keymaps with mocks.
- Changing WezTerm lazygit path to env/config (can be a follow-up task).
- A custom Gherkin parser in Lua (Option B); we use Busted + feature files as docs.
