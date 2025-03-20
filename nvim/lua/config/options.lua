-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Runtime Path
vim.opt.rtp:append(os.getenv('HOME') .. '/.luarocks/share/lua/5.1')
vim.opt.rtp:append(os.getenv('HOME') .. '/.luarocks/lib/luarocks/rocks-5.1')
vim.o.foldcolumn = '1'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = -1

-- Always display status line. Improves window picker behavior
vim.o.laststatus = 3

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
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
vim.g.snacks_animate = false

vim.opt.colorcolumn = '160'
vim.o.showtabline = 2

-- globally disable inlayHints
vim.lsp.handlers['textDocument/inlayHint'] = nil
vim.g.lazyvim_blink_main = true

-- don't start netrw by default
vim.g.loaded_netrwPlugin = 1
