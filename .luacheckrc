std = "luajit"
globals = { "vim", "LazyVim" }
cache = true
include_files = { "nvim/*.lua", "nvim/*/*.lua", "nvim/*/*/*.lua", "*.luacheckrc" }
exclude_files = { "src/luacheck/vendor" }
