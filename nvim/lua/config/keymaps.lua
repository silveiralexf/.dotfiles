-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Wrapper for vim.keymap.set function
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Primary Leader keybindings
map('n', '<leader><tab>v', '<cmd>vnew<cr>', { desc = 'New vertically split pane' })
map('n', '<leader>k', '<cmd>WhichKey<cr>', { desc = 'Whichkey' })
map('n', '<leader>t', '', { desc = 'NeoTest' })

-- LSP bindings
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { desc = 'lsp buf hover' })
map('n', '§d', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'lsp buf definition' })
map('n', '§D', '<cmd>lua vim.lsp.buf.declaration()<cr>', { desc = 'lsp buf declaration' })
map('n', '§i', '<cmd>lua vim.lsp.buf.implementation()<cr>', { desc = 'lsp buf implementation' })
map('n', '§o', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { desc = 'lsp type definition' })
map('n', '§r', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = 'lsp buf references' })
map('n', '§s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = 'lsp buf signature help' })
map('n', '§R', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'lsp buf rename' })
map('n', '§f', '<cmd>lua vim.lsp.buf.format({ async = false })<cr>', { desc = 'lsp buf format' })
map('n', '§a', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'lsp buf code action' })

-- Custom Leaders keybindings
map('n', '\\K', '<cmd>Kustomize<cr>', { desc = 'Kustomize' })

-- FzfLua
map('n', '\\z', '<cmd>FzfLua<cr>', { desc = 'FuzzyLuaFinder' })
map('n', '\\zb', '<cmd>FzfLua buffers<cr>', { desc = 'FuzzyLuaFinder buffers' })
map('n', '\\zg', '<cmd>FzfLua live_grep<cr>', { desc = 'FuzzyLuaFinder livegrep' })
map('n', '\\zf', '<cmd>FzfLua files<cr>', { desc = 'FuzzyLuaFinder files' })
map('n', '\\zk', '<cmd>FzfLua builtin<cr>', { desc = 'Which Key' })
map('n', '\\zc', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'LSP Code Actions' })
map('n', '\\zt', '<cmd>FzfLua builtin<cr>', { desc = 'Tmux Buffers' })

-- GitSigns
map('n', '\\g', '', { desc = 'GitSigns' })
map('v', '\\g', '', { desc = 'GitSigns' })
map('n', '\\gtD', '<cmd>diffthis<cr>', { desc = 'Toggle select for diff' })

-- ModelMate
map('n', '\\m', '', { desc = 'ModelMate' })
map('n', '\\mo', '<cmd>ModelLlama<cr>', { desc = 'ModelLlama-chat' })

-- CursorAgent
map('n', '\\c', '', { desc = 'CursorAgent' })
map('n', '\\ca', '<cmd>CursorOpen<cr>', { desc = 'Open (if needed), switch to Cursor Window' })
map('n', '\\cc', '<cmd>CursorClose<cr>', { desc = 'Close Cursor Window' })
map('n', '\\ct', '<cmd>CursorToggle<cr>', { desc = 'Toggle Cursor Window' })
-- EOF
