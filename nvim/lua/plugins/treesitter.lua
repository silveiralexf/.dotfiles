--- Treesitter: syntax and textobjects.
return {
  specs = {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', name = 'nvim-treesitter' },
  },
  config = function()
    local ts = require('nvim-treesitter.configs')
    if type(ts) == 'table' and ts.setup then
      ts.setup({
        ensure_installed = {},
        auto_install = true,
        highlight = { enable = true },
      })
    end
  end,
}
