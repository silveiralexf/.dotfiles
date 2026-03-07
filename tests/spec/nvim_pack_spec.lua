-- Busted spec: ensure every plugin configured in pack_after.lua has a spec in plugins/*.lua.
-- Run with: busted tests/spec/nvim_pack_spec.lua  (or: task test:lua)
--
-- Plugin config lives in lua/plugins/*.lua: each file returns { specs = {...}, config = function() ... end }.
-- pack_after.lua calls config() for each plugin in order; it does not require() plugins by their runtime name.
-- Workflow when adding a new plugin:
--   1. Add the spec (src, name) and config = function() ... end in lua/plugins/*.lua.
--   2. Add the plugin basename to the order list in pack_after.lua if you need a specific load order.
-- REQUIRE_TO_SPEC is used only when pack_after contains require('plugin_runtime_name'); currently unused.

local repo_root = os.getenv('DOTFILES_HOME') or (os.getenv('HOME') and (os.getenv('HOME') .. '/.dotfiles')) or '.'
local nvim_lua = repo_root .. '/nvim/lua/?.lua'
local plugins_dir = repo_root .. '/nvim/lua/plugins'
local pack_after_path = repo_root .. '/nvim/lua/config/pack_after.lua'

--- Derive pack spec name from a spec table (spec.name or from src URL).
local function spec_name(s)
  if type(s) ~= 'table' then return nil end
  if s.name and s.name ~= '' then return s.name end
  if s.src then
    local last = s.src:match('/([^/]+)$')
    if last then return (last:gsub('%.git$', '')) end
  end
  return nil
end

--- Collect all declared spec names from nvim/lua/plugins/*.lua (only entries with .src).
local function collect_declared_spec_names()
  local declared = {}
  local save_path = package.path
  package.path = nvim_lua .. ';' .. package.path
  local handle = io.popen('find "' .. plugins_dir .. '" -maxdepth 1 -name "*.lua" -type f 2>/dev/null')
  if not handle then return declared end
  local list = handle:read('*a')
  handle:close()
  for basename in (list or ''):gmatch('([^/]+)%.lua') do
    local mod_name = 'plugins.' .. basename
    package.loaded[mod_name] = nil
    local ok, mod = pcall(require, mod_name)
    if ok and type(mod) == 'table' then
      local raw = mod.specs or mod
      if type(raw) == 'table' then
        if raw.src then raw = { raw } end
        for _, s in ipairs(raw) do
          if type(s) == 'table' and s.src then
            local name = spec_name(s)
            if name then declared[name] = true end
          end
        end
      end
    end
    package.loaded[mod_name] = nil
  end
  package.path = save_path
  return declared
end

--- Require-name (from pack_after) -> spec name (as in plugins/*.lua).
local REQUIRE_TO_SPEC = {
  ['sonokai'] = 'sonokai',
  ['yazi'] = 'yazi.nvim',
  ['fzf-lua'] = 'fzf-lua',
  ['gitsigns'] = 'gitsigns.nvim',
  ['mason'] = 'mason.nvim',
  ['mason-lspconfig'] = 'mason-lspconfig.nvim',
  ['fidget'] = 'fidget.nvim',
  ['lspconfig'] = 'nvim-lspconfig',
  ['dressing'] = 'dressing.nvim',
  ['lualine'] = 'lualine.nvim',
  ['trouble'] = 'trouble.nvim',
  ['nvim-treesitter.configs'] = 'nvim-treesitter',
  ['conform'] = 'conform.nvim',
  ['colorizer'] = 'nvim-colorizer.lua',
  ['aerial'] = 'aerial.nvim',
  ['flash'] = 'flash.nvim',
  ['smartcolumn'] = 'smartcolumn.nvim',
  ['zen-mode'] = 'zen-mode.nvim',
  ['ibl'] = 'indent-blankline.nvim',
  ['ibl.hooks'] = 'indent-blankline.nvim',
  ['tmux'] = 'tmux.nvim',
  ['luasnip'] = 'LuaSnip',
  ['noice'] = 'noice.nvim',
  ['notify'] = 'nvim-notify',
}

--- Collect plugin names that pack_after.lua configures (require(...) and colorscheme(...)).
local function collect_configured_spec_names()
  local f = io.open(pack_after_path, 'r')
  if not f then return {} end
  local content = f:read('*a')
  f:close()
  local configured = {}
  -- colorscheme('sonokai')
  for name in content:gmatch("colorscheme%(['\"]([^'\"]+)['\"]") do
    configured[name] = true
  end
  -- require('...') and pcall(require, '...')
  for name in content:gmatch("require%(['\"]([^'\"]+)['\"]") do
    local spec = REQUIRE_TO_SPEC[name]
    if spec then configured[spec] = true end
  end
  for name in content:gmatch("require%,%s*['\"]([^'\"]+)['\"]") do
    local spec = REQUIRE_TO_SPEC[name]
    if spec then configured[spec] = true end
  end
  return configured
end

describe('Neovim pack: configured plugins have specs', function()
  it('every plugin configured in pack_after.lua has a spec in lua/plugins/*.lua', function()
    local declared = collect_declared_spec_names()
    local configured = collect_configured_spec_names()
    local missing = {}
    for name, _ in pairs(configured) do
      if not declared[name] then
        table.insert(missing, name)
      end
    end
    table.sort(missing)
    assert(
      #missing == 0,
      'Plugins configured in pack_after.lua but missing a spec in lua/plugins/*.lua: '
        .. table.concat(missing, ', ')
        .. '. Add a spec (src, name) to one of the plugin files.'
    )
  end)
end)

describe('Neovim pack: plugin specs shape', function()
  it('every declared spec with .src has a derivable name (spec.name or from src)', function()
    local save_path = package.path
    package.path = nvim_lua .. ';' .. package.path
    local handle = io.popen('find "' .. plugins_dir .. '" -maxdepth 1 -name "*.lua" -type f 2>/dev/null')
    if not handle then package.path = save_path return end
    local list = handle:read('*a')
    handle:close()
    local bad = {}
    for basename in (list or ''):gmatch('([^/]+)%.lua') do
      local mod_name = 'plugins.' .. basename
      package.loaded[mod_name] = nil
      local ok, mod = pcall(require, mod_name)
      if ok and type(mod) == 'table' then
        local raw = mod.specs or mod
        if type(raw) == 'table' then
          if raw.src then raw = { raw } end
          for _, s in ipairs(raw) do
            if type(s) == 'table' and s.src and not spec_name(s) then
              table.insert(bad, basename .. '.lua: spec with src=' .. tostring(s.src):sub(1, 40) .. ' has no name')
            end
          end
        end
      end
      package.loaded[mod_name] = nil
    end
    package.path = save_path
    assert(#bad == 0, table.concat(bad, '; '))
  end)
end)
