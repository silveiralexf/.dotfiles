-- vim.pack-native: no LazyVim, no lazy.nvim. See .cursor/plans/2026-02-27_*_nvim-pack-native.plan.md

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Overrides/extensions load first (e.g. lua/local/noice-ext.lua)
vim.opt.rtp:prepend(vim.fn.stdpath('config') .. '/lua/local')

require('config.options')
require('config.keymaps')
require('config.autocmds')

require('pack').setup()

-- Plugin setup that must run after pack loads (preserve existing behavior)
local which_key_ok, which_key = pcall(require, 'which-key')
if which_key_ok and which_key then
  which_key.setup({})
end
