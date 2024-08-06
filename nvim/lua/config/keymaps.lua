-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Wrapper for vim.keymap.set function
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

map('n', '<leader><tab>v', '<cmd>vnew<cr>', { desc = 'New vertically split pane' })
map('n', '<leader>s', '<cmd>TelescopeSearch<cr>', { desc = 'TelescopeSearch' })
map('n', '<leader>f', '<cmd>TelescopeFind<cr>', { desc = 'TelescopeFind' })
map('n', '<leader>fM', '<cmd>Telescope media_files<cr>', { desc = 'TelescopeFindMedia' })
map('n', '<leader>K', '<cmd>Kustomize<cr>', { desc = 'Kustomize' })
map('n', '<leader>k', '<cmd>WhichKey<cr>', { desc = 'Whichkey' })
map('n', '<leader>F', '<cmd>FzfLua<cr>', { desc = 'FuzzyLuaFinder' })
map('n', '<leader>t', '<cmd>NeoTest<cr>', { desc = 'NeoTest' })
map('n', '<leader>O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('v', '<leader>O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('n', '<leader>Oc', '<cmd>Llama<cr>', { desc = 'Ollama-Chat' })
map('n', '<leader>o', '<cmd>Obsidian<cr>', { desc = 'Obsidian' })
map('n', '<leader>of', '<cmd>ObsidianSearch<cr>', { desc = 'ObsidianSearch' })
map('n', '<leader>on', '<cmd>ObsidianNew<cr>', { desc = 'ObsidianNew' })
map('n', '<leader>ot', '<cmd>ObsidianTags<cr>', { desc = 'ObsidianTags' })
map('n', '<leader>ox', '<cmd>ObsidianExtractNote<cr>', { desc = 'ObsidianExtractNote' })
map('n', '<leader>oF', function()
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

--map("n", "<tab>h", "<cmd>tabprev<cr>", { desc = "Previous tab" })
--map("n", "<tab>l", "<cmd>tabnex<cr>", { desc = "Next tab" })
--map("n", "<tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })

map('n', '\\f', '<cmd>Neotree focus<cr>', { desc = 'Focus on Neotree' })

-- map("n", "\\e", function()
--   require("vim.diagnostic").open_float()
-- end, { desc = "Show Diagnostics" })

map('n', '\\w', function()
  local wp = require('window-picker')
  local picked_window_id = wp.pick_window() or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end, { desc = 'Pick window' })

-- EOF
