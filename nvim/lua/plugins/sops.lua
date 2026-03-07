--- SOPS: <leader>cE encrypt, <leader>cD decrypt
return {
  specs = {
    { src = 'https://github.com/lucidph3nx/nvim-sops', name = 'nvim-sops' },
  },
  config = function()
    vim.keymap.set('n', '<leader>cE', vim.cmd.SopsEncrypt, { desc = 'Encrypt File' })
    vim.keymap.set('n', '<leader>cD', vim.cmd.SopsDecrypt, { desc = 'Decrypt File' })
  end,
}
