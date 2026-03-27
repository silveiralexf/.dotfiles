-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Wrapper for vim.keymap.set function
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Primary Leader keybindings
map('n', '<leader><tab><tab>', '<cmd>enew<cr>', { desc = 'New empty buffer' })
map('n', '<leader><tab>v', '<cmd>vnew<cr>', { desc = 'New vertically split pane' })
map('n', '<leader>k', '<cmd>WhichKey<cr>', { desc = 'Whichkey' })
map('n', '<leader>t', '', { desc = 'NeoTest' })

-- LazyVim-style find/search (FzfLua) - space+space = find files, leader+ff/fw for files/grep
map('n', '<leader><space>', '<cmd>FzfLua files<cr>', { desc = 'Find files (FzfLua)' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>fw', '<cmd>FzfLua live_grep<cr>', { desc = 'Find word (live grep)' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Find buffers' })
map('n', '<leader>fh', '<cmd>FzfLua helptags<cr>', { desc = 'Find help' })
map('n', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { desc = 'Find keymaps' })
map('n', '<leader>fc', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'LSP code actions' })
-- Search group: leader+s = search, leader+sk = which-key, leader+s/ = search (grep)
map('n', '<leader>s', '<cmd>FzfLua live_grep<cr>', { desc = 'Search in project (grep)' })
map('n', '<leader>sk', '<cmd>WhichKey<cr>', { desc = 'Which key (keymaps)' })
map('n', '<leader>s/', '<cmd>FzfLua live_grep<cr>', { desc = 'Search (grep)' })
map('n', '<leader>sw', '<cmd>FzfLua live_grep<cr>', { desc = 'Search word' })
-- Find and replace in all files (Spectre)
map('n', '<leader>sr', function()
  local ok, spectre = pcall(require, 'spectre')
  if ok and spectre and spectre.open then
    spectre.open()
  end
end, { desc = 'Search and replace (Spectre)' })
map('n', '<leader>sR', function()
  local ok, spectre = pcall(require, 'spectre')
  if ok and spectre and spectre.open_visual then
    spectre.open_visual({ select_word = true })
  end
end, { desc = 'Search replace (word under cursor)' })
map('v', '<leader>sR', function()
  local ok, spectre = pcall(require, 'spectre')
  if ok and spectre and spectre.open_visual then
    spectre.open_visual()
  end
end, { desc = 'Search replace (selection)' })

-- Buffers
map('n', '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })
map('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })

-- Quickfix / location list
map('n', '<leader>xq', function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = 'Toggle quickfix list' })
map('n', '<leader>xl', function()
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid and winid ~= 0 then
    vim.cmd.lclose()
  else
    pcall(vim.cmd.lopen) -- E776 when no location list; avoid error
  end
end, { desc = 'Toggle location list' })
map('n', '[q', '<cmd>cprev<cr>', { desc = 'Previous quickfix' })
map('n', ']q', '<cmd>cnext<cr>', { desc = 'Next quickfix' })

-- Diagnostics (vim.diagnostic.jump() + on_jump; goto_next/goto_prev and float= are deprecated in 0.13/0.14)
local function diag_jump(count, severity)
  local opts = {
    count = count,
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
    end,
  }
  if severity then
    opts.severity = severity
  end
  vim.diagnostic.jump(opts)
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', ']d', function()
  diag_jump(1)
end, { desc = 'Next diagnostic' })
map('n', '[d', function()
  diag_jump(-1)
end, { desc = 'Prev diagnostic' })
map('n', ']e', function()
  diag_jump(1, vim.diagnostic.severity.ERROR)
end, { desc = 'Next error' })
map('n', '[e', function()
  diag_jump(-1, vim.diagnostic.severity.ERROR)
end, { desc = 'Prev error' })
map('n', ']w', function()
  diag_jump(1, vim.diagnostic.severity.WARN)
end, { desc = 'Next warning' })
map('n', '[w', function()
  diag_jump(-1, vim.diagnostic.severity.WARN)
end, { desc = 'Prev warning' })

-- Trouble keymaps are registered in lua/plugins/trouble.lua after the plugin is loaded and set up.

-- Format (conform)
map('n', '<leader>cf', function()
  local ok, conform = pcall(require, 'conform')
  if ok and conform and conform.format then
    conform.format({ async = false })
  end
end, { desc = 'Format' })
map('x', '<leader>cf', function()
  local ok, conform = pcall(require, 'conform')
  if ok and conform and conform.format then
    conform.format({ async = false })
  end
end, { desc = 'Format' })

-- Windows
map('n', '<leader>-', '<cmd>split<cr>', { desc = 'Split below' })
map('n', '<leader>|', '<cmd>vsplit<cr>', { desc = 'Split right' })
map('n', '<leader>wd', '<cmd>close<cr>', { desc = 'Close window' })
-- Ctrl+W + Left/Right/Up/Down: move focus between windows
map('n', '<C-w><Left>', '<C-w>h', { desc = 'Focus left window' })
map('n', '<C-w><Right>', '<C-w>l', { desc = 'Focus right window' })
map('n', '<C-w><Up>', '<C-w>k', { desc = 'Focus upper window' })
map('n', '<C-w><Down>', '<C-w>j', { desc = 'Focus lower window' })
-- Ctrl+W + Ctrl+arrow: resize current window
map('n', '<C-w><C-Left>', '<cmd>vertical resize -5<cr>', { desc = 'Resize window left' })
map('n', '<C-w><C-Right>', '<cmd>vertical resize +5<cr>', { desc = 'Resize window right' })
map('n', '<C-w><C-Up>', '<cmd>resize +5<cr>', { desc = 'Resize window up' })
map('n', '<C-w><C-Down>', '<cmd>resize -5<cr>', { desc = 'Resize window down' })

-- UI Toggles (leader+u): mirrors LazyVim <leader>u* - autoformat flag is checked in conform.lua BufWritePre
map('n', '<leader>uf', function()
  vim.g.autoformat = vim.g.autoformat == false
  vim.notify('Autoformat (global): ' .. (vim.g.autoformat and 'on' or 'off'))
end, { desc = 'Toggle autoformat (global)' })
map('n', '<leader>uF', function()
  vim.b.autoformat = vim.b.autoformat == false
  vim.notify('Autoformat (buffer): ' .. (vim.b.autoformat and 'on' or 'off'))
end, { desc = 'Toggle autoformat (buffer)' })
map('n', '<leader>us', function()
  vim.wo.spell = not vim.wo.spell
  vim.notify('Spell: ' .. (vim.wo.spell and 'on' or 'off'))
end, { desc = 'Toggle spell' })
map('n', '<leader>uw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Wrap: ' .. (vim.wo.wrap and 'on' or 'off'))
end, { desc = 'Toggle wrap' })
map('n', '<leader>ul', function()
  vim.wo.number = not vim.wo.number
  vim.notify('Line numbers: ' .. (vim.wo.number and 'on' or 'off'))
end, { desc = 'Toggle line numbers' })
map('n', '<leader>uL', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify('Relative numbers: ' .. (vim.wo.relativenumber and 'on' or 'off'))
end, { desc = 'Toggle relative number' })
map('n', '<leader>ud', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.notify('Diagnostics: ' .. (not enabled and 'on' or 'off'))
end, { desc = 'Toggle diagnostics' })
map('n', '<leader>uc', function()
  vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
  vim.notify('Conceallevel: ' .. vim.wo.conceallevel)
end, { desc = 'Toggle conceallevel' })
map('n', '<leader>uh', function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  vim.notify('Inlay hints: ' .. (not enabled and 'on' or 'off'))
end, { desc = 'Toggle inlay hints' })
map('n', '<leader>uT', function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    vim.notify('Treesitter highlight: off')
  else
    vim.treesitter.start()
    vim.notify('Treesitter highlight: on')
  end
end, { desc = 'Toggle treesitter highlight' })
map('n', '<leader>ub', function()
  vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
  vim.notify('Background: ' .. vim.o.background)
end, { desc = 'Toggle background' })
map('n', '<leader>ug', function()
  local ok, ibl = pcall(require, 'ibl')
  if not ok then
    return
  end
  vim.g.ibl_enabled = vim.g.ibl_enabled == false
  ibl.update({ enabled = vim.g.ibl_enabled })
  vim.notify('Indent guides: ' .. (vim.g.ibl_enabled and 'on' or 'off'))
end, { desc = 'Toggle indent guides' })

-- Git (leader+g): diffview; gitsigns hunk keys are under \g (buffer-local in git buffers)
map('n', '<leader>gh', '<cmd>DiffviewOpen<cr>', { desc = 'Diffview open' })
map('n', '<leader>gc', '<cmd>DiffviewClose<cr>', { desc = 'Diffview close' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history (current)' })

-- LSP bindings (K and gd are set buffer-local in LspAttach; these are global fallbacks/alternatives)
map('n', '@d', '<cmd>lua vim.lsp.buf.definition()<cr>', { desc = 'lsp buf definition' })
map('n', '@D', '<cmd>lua vim.lsp.buf.declaration()<cr>', { desc = 'lsp buf declaration' })
map('n', '@i', '<cmd>lua vim.lsp.buf.implementation()<cr>', { desc = 'lsp buf implementation' })
map('n', '@o', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { desc = 'lsp type definition' })
map('n', '@r', '<cmd>lua vim.lsp.buf.references()<cr>', { desc = 'lsp buf references' })
map('n', '@s', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { desc = 'lsp buf signature help' })
map('n', '@R', '<cmd>lua vim.lsp.buf.rename()<cr>', { desc = 'lsp buf rename' })
map('n', '@f', '<cmd>lua vim.lsp.buf.format({ async = false })<cr>', { desc = 'lsp buf format' })
map('n', '@a', '<cmd>lua vim.lsp.buf.code_action()<cr>', { desc = 'lsp buf code action' })

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

-- Lazygit floating terminal (from git root)
map('n', '\\gg', function()
  local root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.getcwd()) .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    root = vim.fn.getcwd()
  end
  local buf = vim.api.nvim_create_buf(false, true)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.9)
  local height = math.floor(ui.height * 0.9)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' lazygit ',
    title_pos = 'center',
  })
  vim.fn.jobstart('lazygit -p ' .. vim.fn.shellescape(root), {
    term = true,
    on_exit = function()
      vim.api.nvim_buf_delete(buf, { force = true })
    end,
  })
  vim.cmd('startinsert')
end, { desc = 'Lazygit (root)' })

-- ModelMate
map('n', '\\m', '', { desc = 'ModelMate' })
map('n', '\\mo', '<cmd>ModelLlama<cr>', { desc = 'ModelLlama-chat' })

-- CursorAgent
map('n', '\\c', '', { desc = 'CursorAgent' })
map('n', '\\ca', '<cmd>CursorOpen<cr>', { desc = 'Open (if needed), switch to Cursor Window' })
map('n', '\\cc', '<cmd>CursorClose<cr>', { desc = 'Close Cursor Window' })
map('n', '\\ct', '<cmd>CursorToggle<cr>', { desc = 'Toggle Cursor Window' })
-- EOF
