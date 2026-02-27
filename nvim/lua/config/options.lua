-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Runtime Path (portable: macOS + Linux)
local home = vim.env.HOME or vim.fn.expand('~')
vim.opt.rtp:append(home .. '/.luarocks/share/lua/5.1')
vim.opt.rtp:append(home .. '/.luarocks/lib/luarocks/rocks-5.1')
vim.o.foldcolumn = '1'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = -1

vim.o.swapfile = false
vim.o.termguicolors = true
vim.opt.guicursor = ''
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.textwidth = 120
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0

vim.opt.spelllang = 'en_us'
vim.opt.spell = false

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.backup = false
vim.opt.undodir = home .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Always display status line. Improves window picker behavior
vim.o.laststatus = 3
vim.o.showtabline = 2
vim.g.snacks_animate = false
vim.o.winborder = 'rounded'

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')
vim.opt.updatetime = 50

-- globally disable inlayHints
vim.lsp.handlers['textDocument/inlayHint'] = nil

-- don't start netrw by default
vim.g.loaded_netrwPlugin = 1
