return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          setup = {
            taplo = {},
          },
        },
      })
    end,
  },
}
