--- Run plugin setup/config after vim.pack has loaded all plugins.
--- Each lua/plugins/*.lua may export config = function(); we call them in order below.
--- LSP server configs are in lua/lsp/servers/*.lua and are registered here.

local PACK_PLUGIN_DIR = 'plugins'

local function run_plugin_configs()
  local config = vim.fn.stdpath('config')
  local plugin_dir = config .. '/lua/' .. PACK_PLUGIN_DIR
  local pattern = plugin_dir .. '/*.lua'
  local files = vim.fn.glob(pattern, true, true) or {}
  -- Order matters: luarocks first (so rocks are available), then colorscheme, then rest
  local order = {
    'luarocks',
    'colorscheme',
    'yazi',
    'fzf',
    'git',
    'lsp',
    'dressing',
    'noice',
    'lualine',
    'treesitter',
    'conform',
    'editor',
    'indent',
    'trouble',
    'tmux',
    'luasnip',
    'nvim-nio',
    'formatting',
    'lazydev',
    'go',
    'neotest',
    'cloak',
    'kcl',
    'matchup',
    'mini',
    'modelmate',
    'snacks',
    'opencode',
    'quickfix',
    'sops',
    'undotree',
    'wakatime',
    'yaml-companion',
    'zig',
  }
  local seen = {}
  for _, name in ipairs(order) do
    seen[name] = true
    local ok, mod = pcall(require, PACK_PLUGIN_DIR .. '.' .. name)
    if ok and type(mod) == 'table' and type(mod.config) == 'function' then
      pcall(mod.config)
    end
  end
  for _, path in ipairs(files) do
    local basename = vim.fn.fnamemodify(path, ':t:r')
    if basename and basename ~= '' and not seen[basename] then
      local ok, mod = pcall(require, PACK_PLUGIN_DIR .. '.' .. basename)
      if ok and type(mod) == 'table' and type(mod.config) == 'function' then
        pcall(mod.config)
      end
    end
  end
end

run_plugin_configs()

-- Register and enable LSP configs from lua/lsp/servers/*.lua (vim.lsp.config / vim.lsp.enable)
local server_files = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/lsp/servers/*.lua', true, true)
for _, path in ipairs(server_files or {}) do
  local name = vim.fn.fnamemodify(path, ':t:r')
  local mod_name = 'lsp.servers.' .. name
  local ok, mod = pcall(require, mod_name)
  if not ok or type(mod) ~= 'table' then
    goto continue
  end
  for _, spec in ipairs(mod) do
    if type(spec) ~= 'table' then
      goto continue_inner
    end
    local opts = spec.opts
    if type(opts) == 'function' then
      local ok_opts, result = pcall(opts, nil, {})
      opts = (ok_opts and result) or nil
    end
    if type(opts) == 'table' and opts.servers then
      for srv_name, srv_config in pairs(opts.servers) do
        pcall(function()
          vim.lsp.config(srv_name, srv_config)
          vim.lsp.enable(srv_name)
        end)
      end
    end
    ::continue_inner::
  end
  ::continue::
end
