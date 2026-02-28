-- vim.pack-native: no LazyVim, no lazy.nvim. See .cursor/plans/2026-02-27_*_nvim-pack-native.plan.md

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Overrides/extensions load first (e.g. lua/local/noice-ext.lua)
vim.opt.rtp:prepend(vim.fn.stdpath('config') .. '/lua/local')

require('config.options')
require('config.keymaps')
require('config.autocmds')

require('pack').setup()

-- Plugin config/setup (colorscheme, yazi, fzf, gitsigns, LSP, lualine, etc.)
require('config.pack_after')

-- Which-key must run after pack so keymaps are visible
local which_key_ok, which_key = pcall(require, 'which-key')
if which_key_ok and which_key then
  which_key.setup({})
  -- New spec (v3): group labels for keybinding popup; plugins add child keymaps
  -- Only register groups for prefixes that don't have an empty keymap (avoids duplicate warnings for \c, \g, \m, \t, <leader>t)
  which_key.add({
    { '<leader>b', group = 'Buffer', mode = 'n' },
    { '<leader>c', group = 'Code', mode = 'n' },
    { '<leader>f', group = 'Find', mode = 'n' },
    { '<leader>g', group = 'Git', mode = 'n' },
    { '<leader>s', group = 'Search', mode = 'n' },
    { '<leader>u', group = 'Undo', mode = 'n' },
    { '<leader>w', group = 'Window', mode = 'n' },
    { '<leader>x', group = 'Quickfix', mode = 'n' },
    { '<leader>z', group = 'Zen', mode = 'n' },
    { '\\z', group = 'FzfLua', mode = 'n' },
  })
end
