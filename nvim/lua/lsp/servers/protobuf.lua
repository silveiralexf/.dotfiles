return {
  {
    'neovim/nvim-lspconfig',
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
  },
}
