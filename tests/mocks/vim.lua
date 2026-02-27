-- Minimal vim mock for testing Neovim config (keymaps, options) without Neovim.
local keymap_calls = {}
local opt_store = {}

local M = {
  keymap = {
    set = function(mode, lhs, rhs, opts)
      table.insert(keymap_calls, { mode = mode, lhs = lhs, rhs = rhs, opts = opts or {} })
    end,
  },
  opt = setmetatable({}, {
    __index = function(_, k) return opt_store[k] end,
    __newindex = function(_, k, v) opt_store[k] = v end,
  }),
  o = setmetatable({}, {
    __index = function(_, k) return opt_store[k] end,
    __newindex = function(_, k, v) opt_store[k] = v end,
  }),
  g = {},
  api = { nvim_echo = function() end },
  fn = { stdpath = function() return '/tmp' end, getchar = function() return 0 end, system = function() return '' end },
  v = { shell_error = 0 },
  uv = { fs_stat = function() return nil end },
  loop = { fs_stat = function() return nil end },
  lsp = { handlers = {} },
}

function M._get_keymap_calls()
  return keymap_calls
end

function M._reset()
  for i in pairs(keymap_calls) do keymap_calls[i] = nil end
  for k in pairs(opt_store) do opt_store[k] = nil end
end

return M
