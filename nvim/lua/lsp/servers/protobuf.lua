return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          setup = {
            protols = {
              filetypes = { 'proto' },
            },
            clangd = {
              filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
            },
          },
        },
      })
    end,
  },
}
