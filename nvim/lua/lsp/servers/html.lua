return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')
    lspconfig.html.setup({
      filetypes = { 'htmldjango', 'gohtmltmpl', 'gotmpl' },
    })
  end,
}, {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')
    lspconfig.htmx.setup({
      filetypes = { 'htmldjango', 'gohtmltmpl', 'gotmpl' },
    })
  end,
}
