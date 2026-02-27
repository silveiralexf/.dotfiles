-- Busted spec for WezTerm config loader (implements wezterm_loader.feature scenarios).
-- Run with: busted tests/spec/wezterm_loader_spec.lua (describe/it/assert are provided by Busted)

-- Repo root (assume we run from repo root or tests/spec)
local repo_root = os.getenv('DOTFILES_HOME') or (os.getenv('HOME') and (os.getenv('HOME') .. '/.dotfiles')) or '.'
local wezterm_path = repo_root .. '/wezterm/?.lua'

describe('WezTerm config loader', function()
  local loader
  local log_warn_calls

  before_each(function()
    log_warn_calls = {}
    package.loaded['wezterm'] = {
      log_warn = function(_, key)
        table.insert(log_warn_calls, key)
      end,
    }
    package.loaded['config'] = nil
    package.loaded['config.init'] = nil
    package.path = package.path .. ';' .. wezterm_path
    local config = require('config.init')
    loader = config:init()
  end)

  after_each(function()
    package.loaded['wezterm'] = nil
    package.loaded['config'] = nil
  end)

  it('Scenario: Appending options merges new keys into config', function()
    loader:append({ font_size = 12 })
    loader:append({ line_height = 1.2 })
    assert.is_equal(12, loader.options.font_size)
    assert.is_equal(1.2, loader.options.line_height)
  end)

  it('Scenario: Appending duplicate key does not overwrite and is reported', function()
    loader:append({ font_size = 12 })
    loader:append({ font_size = 14 })
    assert.is_equal(12, loader.options.font_size)
    assert.is_true(#log_warn_calls >= 1)
  end)
end)
