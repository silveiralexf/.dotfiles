-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Wrapper for vim.keymap.set function
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Primary Leader keybindings
map('n', '<leader><tab>v', '<cmd>vnew<cr>', { desc = 'New vertically split pane' })
map('n', '<leader>f', '<cmd>TelescopeFind<cr>', { desc = 'TelescopeFind' })
map('n', '<leader>fM', '<cmd>Telescope media_files<cr>', { desc = 'TelescopeFindMedia' })
map('n', '<leader>k', '<cmd>WhichKey<cr>', { desc = 'Whichkey' })
map('n', '\\f', '<cmd>FzfLua files<cr>', { desc = 'FuzzyLuaFinder files' })
map('n', '\\g', '<cmd>FzfLua live_grep<cr>', { desc = 'FuzzyLuaFinder livegrep' })
map('n', '<leader>t', '<cmd>NeoTest<cr>', { desc = 'NeoTest' })

-- Custom Leaders keybindings
map('n', '\\d', '<cmd>diffthis<cr>', { desc = 'Diff this' })
map('n', '\\w', function()
  local wp = require('window-picker')
  local picked_window_id = wp.pick_window() or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = 'Pick window' })
map('n', '\\K', '<cmd>Kustomize<cr>', { desc = 'Kustomize' })
-- GitSigns
map('n', '\\g', '', { desc = 'GitSigns' })
map('v', '\\g', '', { desc = 'GitSigns' })
map('n', '\\gtD', '<cmd>diffthis<cr>', { desc = 'Toggle select for diff' })

map('n', '\\O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('v', '\\O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('n', '\\Oc', '<cmd>Llama<cr>', { desc = 'Ollama-Chat' })
map('n', '\\o', '<cmd>Obsidian<cr>', { desc = 'Obsidian' })
map('n', '\\of', '<cmd>ObsidianSearch<cr>', { desc = 'ObsidianSearch' })
map('n', '\\on', '<cmd>ObsidianNew<cr>', { desc = 'ObsidianNew' })
map('n', '\\ot', '<cmd>ObsidianTags<cr>', { desc = 'ObsidianTags' })
map('n', '\\ox', '<cmd>ObsidianExtractNote<cr>', { desc = 'ObsidianExtractNote' })
map('n', '\\oF', function()
  if require('obsidian').util.cursor_on_markdown_link() then
    return '<cmd>ObsidianFollowLink<CR>'
  else
    return ''
  end
end, {
  noremap = false,
  expr = true,
  desc = 'ObsidianFollowLink',
})

-- EOF
