-- vim: ft=lua tw=80

std = 'luajit'
cache = true
include_files = {
  'nvim/*.lua', 'nvim/*/*.lua', 'nvim/*/*/*.lua', 'nvim/*/*/*/*.lua',
  'wezterm/*.lua', 'wezterm/*/*.lua', 'wezterm/*/*/*.lua',
  '*.luacheckrc',
}
exclude_files = {
  'src/luacheck/vendor',
  'hammerspoon/',  -- host globals (Keymaps, hs, etc.); enable with per-file read_globals when needed
  'yazi/',         -- host globals (ya, ui, th, Linemode)
}
globals = { 'vim', 'wezterm', 'LazyVim', 'YaziConfig' }
max_line_length = 150
max_comment_line_length = 200
files['wezterm/extensions/backdrops.lua'] = { ignore = { '212' } }
files['nvim/lua/lsp/servers/json.lua'] = { ignore = { '631' } } -- long lines in description strings

-- Rerun tests only if their modification time changed
cache = true

-- Don't report unused self arguments of methods
self = false

-- ignore = {
--   '631', -- max_line_length
--   '212/_.*', -- unused argument, for vars with "_" prefix
-- }
