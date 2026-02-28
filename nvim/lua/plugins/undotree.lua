--- Undo tree: <leader>u
return {
  specs = {
    { src = 'https://github.com/mbbill/undotree', name = 'undotree' },
  },
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Undo tree' })
  end,
}
