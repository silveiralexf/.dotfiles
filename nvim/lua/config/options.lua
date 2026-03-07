-- Options loaded from init.lua. User overrides at the end take precedence.

local home = vim.env.HOME or vim.fn.expand('~')

-- Runtime path (portable: macOS + Linux)
vim.opt.rtp:append(home .. '/.dotfiles/lua_modules/share/lua/5.4')
vim.opt.rtp:append(home .. '/.dotfiles/lua_modules/lib/lua/5.4')
vim.opt.rtp:append(home .. '/.dotfiles/lua_modules/share/lua/5.4/?.lua')
vim.opt.rtp:append(home .. '/.dotfiles/lua_modules/lib/lua/5.4/?.so')

-- LazyVim-style defaults (add new defaults above the "User overrides" section)
vim.opt.autowrite = true
vim.opt.clipboard = (vim.env.SSH_CONNECTION and vim.env.SSH_CONNECTION ~= '') and '' or 'unnamedplus'
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
vim.opt.foldmethod = 'indent'
vim.opt.foldtext = ''
vim.opt.formatoptions = 'jcroqlnt'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true
vim.opt.inccommand = 'nosplit'
vim.opt.jumpoptions = 'view'
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.ruler = false
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
vim.opt.shiftround = true
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smoothscroll = true
vim.opt.splitbelow = true
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.virtualedit = 'block'
vim.opt.wildmode = 'longest:full,full'
vim.opt.winminwidth = 5
vim.opt.wrap = false
vim.g.markdown_recommended_style = 0

-- User overrides (keep these; they take precedence over defaults above)
vim.o.foldcolumn = '1'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = -1
vim.o.swapfile = false
vim.opt.guicursor = ''
vim.opt.textwidth = 120
vim.opt.shiftwidth = 0
vim.opt.spelllang = 'en_us'
vim.opt.spell = false
vim.opt.backup = false
vim.opt.undodir = home .. '/.vim/undodir'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.o.laststatus = 3
vim.o.showtabline = 2
vim.g.snacks_animate = false
vim.o.winborder = 'rounded'
vim.opt.scrolloff = 8
vim.opt.isfname:append('@-@')
vim.opt.updatetime = 50
vim.lsp.handlers['textDocument/inlayHint'] = nil
vim.g.loaded_netrwPlugin = 1
