return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        html = {
          filetypes = { 'htmldjango', 'gohtmltmpl', 'gotmpl' },
        },
        htmx = {
          filetypes = { 'htmldjango', 'gohtmltmpl', 'gotmpl' },
        },
      },
    },
  },
}
