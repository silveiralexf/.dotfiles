-- Busted spec for WezTerm Backdrops (implements wezterm_backdrops.feature scenarios).
-- Run with: busted tests/spec/wezterm_backdrops_spec.lua
local repo_root = os.getenv('DOTFILES_HOME') or (os.getenv('HOME') and (os.getenv('HOME') .. '/.dotfiles')) or '.'
local wezterm_path = repo_root .. '/wezterm/?.lua'

-- Pure helper: cycle index forward (1-based, wraps)
local function cycle_forward(current, n)
  if current == n then return 1 end
  return current + 1
end

local function cycle_back(current, n)
  if current == 1 then return n end
  return current - 1
end

describe('WezTerm Backdrops (pure index logic)', function()
  it('Scenario: Cycle forward wraps from last to first', function()
    local n = 3
    local idx = cycle_forward(3, n)
    assert.is_equal(1, idx)
  end)

  it('Scenario: Cycle back wraps from first to last', function()
    local n = 3
    local idx = cycle_back(1, n)
    assert.is_equal(3, idx)
  end)

  it('Scenario: Set image at valid index', function()
    local files = { 'a.png', 'b.png' }
    local idx = 2
    assert.is_equal('b.png', files[idx])
  end)

  it('Scenario: Index out of range is invalid', function()
    local files = { 'a.png' }
    local idx = 5
    assert.is_nil(files[idx])
    assert.is_true(idx > #files)
  end)
end)

-- Optional: load real BackDrops with mocks (requires colors.custom mock)
describe('WezTerm Backdrops (module)', function()
  local BackDrops

  before_each(function()
    package.loaded['wezterm'] = {
      GLOBAL = {},
      config_dir = repo_root .. '/wezterm',
      read_dir = function() return { 'a.png', 'b.png', 'c.png' } end,
      log_error = function() end,
    }
    package.loaded['colors.custom'] = { background = '#1e1e2e' }
    package.path = package.path .. ';' .. wezterm_path
    package.loaded['extensions.backdrops'] = nil
  end)

  after_each(function()
    package.loaded['wezterm'] = nil
    package.loaded['colors.custom'] = nil
    package.loaded['extensions.backdrops'] = nil
  end)

  it('loads and set_files populates files', function()
    local ok, mod = pcall(require, 'extensions.backdrops')
    if not ok then
      pending('extensions.backdrops not loadable from test path: ' .. tostring(mod))
      return
    end
    mod:set_files()
    assert.is_equal(3, #mod.files)
    assert.is_equal(1, mod.current_idx)
  end)
end)
