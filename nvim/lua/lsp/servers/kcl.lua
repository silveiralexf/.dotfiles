return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          setup = {
            kcl = {},
          },
        },
      })
    end,
  },
}
