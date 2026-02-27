-- Step definitions for tests/features/wezterm_loader.feature
local runner = require('tests.runner.feature_runner')
local repo_root = os.getenv('DOTFILES_HOME') or (os.getenv('HOME') and (os.getenv('HOME') .. '/.dotfiles')) or '.'
local wezterm_path = repo_root .. '/wezterm/?.lua'

runner.register('Given', 'a fresh WezTerm loader instance', function(w)
  w.log_warn_calls = {}
  package.loaded['wezterm'] = {
    log_warn = function(_, key) table.insert(w.log_warn_calls, key) end,
  }
  package.loaded['config'] = nil
  package.loaded['config.init'] = nil
  package.path = package.path .. ';' .. wezterm_path
  local config = require('config.init')
  w.loader = config:init()
end)

runner.register('When', 'I append options', function(w, step_text)
  local tbl = runner.parse_table_in_step(step_text)
  if tbl then w.loader:append(tbl) end
end)

runner.register('And', 'I append options', function(w, step_text)
  local tbl = runner.parse_table_in_step(step_text)
  if tbl then w.loader:append(tbl) end
end)

runner.register('Then', 'the config has key "font_size" with value 12', function(w)
  assert(w.loader.options.font_size == 12, 'expected font_size 12, got ' .. tostring(w.loader.options.font_size))
end)

runner.register('And', 'the config has key "line_height" with value 1.2', function(w)
  assert(w.loader.options.line_height == 1.2, 'expected line_height 1.2, got ' .. tostring(w.loader.options.line_height))
end)

runner.register('Then', 'the config key "font_size" is still 12', function(w)
  assert(w.loader.options.font_size == 12, 'expected font_size still 12, got ' .. tostring(w.loader.options.font_size))
end)

runner.register('And', 'a duplicate config warning was logged for "font_size"', function(w)
  assert(#w.log_warn_calls >= 1, 'expected at least one log_warn call for duplicate')
end)
