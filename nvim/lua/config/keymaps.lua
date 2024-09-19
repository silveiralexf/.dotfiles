-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Wrapper for vim.keymap.set function
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Primary Leader keybindings
map('n', '<leader><tab>v', '<cmd>vnew<cr>', { desc = 'New vertically split pane' })
map('n', '<leader>fM', '<cmd>Telescope media_files<cr>', { desc = 'TelescopeFindMedia' })
map('n', '<leader>k', '<cmd>WhichKey<cr>', { desc = 'Whichkey' })
map('n', '<leader>t', '', { desc = 'NeoTest' })

-- Custom Leaders keybindings
map('n', '\\K', '<cmd>Kustomize<cr>', { desc = 'Kustomize' })

-- FzfLua
map('n', '\\z', '<cmd>FzfLua<cr>', { desc = 'FuzzyLuaFinder' })
map('n', '\\zg', '<cmd>FzfLua live_grep<cr>', { desc = 'FuzzyLuaFinder livegrep' })
map('n', '\\zf', '<cmd>FzfLua files<cr>', { desc = 'FuzzyLuaFinder files' })
map('n', '\\zk', '<cmd>FzfLua builtin<cr>', { desc = 'Which Key' })
map('n', '\\zc', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'LSP Code Actions' })
map('n', '\\zt', '<cmd>FzfLua builtin<cr>', { desc = 'Tmux Buffers' })

-- GitSigns
map('n', '\\g', '', { desc = 'GitSigns' })
map('v', '\\g', '', { desc = 'GitSigns' })
map('n', '\\gtD', '<cmd>diffthis<cr>', { desc = 'Toggle select for diff' })

-- Ollama
map('n', '\\O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('v', '\\O', '<cmd>Ollama<cr>', { desc = 'Ollama' })
map('n', '\\Oc', '<cmd>Llama<cr>', { desc = 'Ollama-Chat' })

-- Obsidian
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
