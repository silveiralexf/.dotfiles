--- OpenCode: <leader>ot toggle, <leader>oa ask, etc.
return {
  specs = {
    { src = 'https://github.com/NickvanDyke/opencode.nvim', name = 'opencode.nvim' },
    { src = 'https://github.com/folke/snacks.nvim', name = 'snacks.nvim' },
  },
  config = function()
    local opencode = require('opencode')
    if type(opencode) ~= 'table' then return end
    vim.keymap.set('n', '<leader>ot', function() opencode.toggle() end, { desc = 'Toggle opencode' })
    vim.keymap.set({ 'n', 'v' }, '<leader>oa', function() opencode.ask() end, { desc = 'Ask opencode' })
    vim.keymap.set(
      { 'n', 'v' },
      '<leader>oA',
      function() opencode.ask('@file ') end,
      { desc = 'Ask opencode about current file' }
    )
    vim.keymap.set('n', '<leader>on', function() opencode.command('/new') end, { desc = 'New session' })
    vim.keymap.set('n', '<leader>oe', function() opencode.prompt('Explain @cursor and its context') end, { desc = 'Explain code near cursor' })
    vim.keymap.set('n', '<leader>or', function() opencode.prompt('Review @file for correctness and readability') end, { desc = 'Review file' })
    vim.keymap.set('n', '<leader>of', function() opencode.prompt('Fix these @diagnostics') end, { desc = 'Fix errors' })
    vim.keymap.set('v', '<leader>od', function() opencode.prompt('Add documentation comments for @selection') end, { desc = 'Document selection' })
    vim.keymap.set('v', '<leader>ot', function() opencode.prompt('Add tests for @selection') end, { desc = 'Test selection' })
    vim.keymap.set('v', '<leader>oo', function()
      opencode.prompt('Optimize @selection for performance and readability')
    end, { desc = 'Optimize selection' })
  end,
}
