return {
  {
    'lucidph3nx/nvim-sops',
    event = { 'BufEnter' },
    opts = {},
    keys = {
      { '<leader>cE', vim.cmd.SopsEncrypt, desc = 'Encrypt File' },
      { '<leader>cD', vim.cmd.SopsDecrypt, desc = 'Decrypt File' },
    },
  },
}
