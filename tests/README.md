# Lua config tests (acceptance-driven, Gherkin-style)

Acceptance criteria for Neovim, WezTerm, and other Lua configs are written in **Gherkin** (`.feature` files). Executable tests are implemented with **Busted** and mirror those scenarios.

## Layout

- **`features/`** - Gherkin `.feature` files (Given/When/Then). Single source of truth for *what* we expect.
- **`spec/`** - Busted specs that implement the scenarios (the *how*). One `*_spec.lua` per feature or area.
- **`mocks/`** - Minimal stubs for `vim`, `wezterm`, etc., so we can require config modules without a real host.
- **`step_helpers/`** - Shared Lua helpers used by specs (e.g. "merge config", "cycle index").

## Running tests

```bash
# Install Busted (once)
luarocks install busted

# Run all Lua specs
busted tests/spec

# Or via task (if wired in Taskfile.yml)
task test:lua
```

## Adding a new scenario

1. Add or extend a `.feature` in `tests/features/` (Feature → Scenario → Given/When/Then).
2. Add or extend the corresponding `*_spec.lua` in `tests/spec/` that implements those steps (e.g. one `it(...)` per scenario, calling step helpers).
3. Run `busted tests/spec` and fix until green.

## Scope

- **WezTerm:** Loader merge behaviour, Backdrops cycle/set_img, event registration (e.g. trigger-lazygit). Use mocks for `wezterm.*`.
- **Neovim:** Keymap and option presence (with `vim` mock); no full Neovim process.
- **Hammerspoon / Yazi:** Can be added later following the same pattern.
