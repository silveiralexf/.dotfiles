-- vim: ft=lua tw=80

std = 'luajit'
globals = { 'vim', 'LazyVim', 'YaziConfig' }
cache = true
include_files = { 'nvim/*.lua', 'nvim/*/*.lua', 'nvim/*/*/*.lua', '*.luacheckrc' }
exclude_files = { 'src/luacheck/vendor' }
max_line_length = 150
max_comment_line_length = 200
files['wezterm/utils/backdrops.lua'] = { ignore = { '212' } }

-- Rerun tests only if their modification time changed
cache = true

-- Don't report unused self arguments of methods
self = false

-- ignore = {
--   '631', -- max_line_length
--   '212/_.*', -- unused argument, for vars with "_" prefix
-- }
