--- Undo tree: <leader>U
return {
  specs = {
    { src = 'https://github.com/mbbill/undotree', name = 'undotree' },
  },
  config = function()
    vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = 'Undo tree' })
  end,
}
