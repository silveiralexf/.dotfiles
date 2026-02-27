return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      setup = {
        groovyls = {},
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { 'groovy' })
      vim.filetype.add({
        pattern = {
          ['.*.Jenkinsfile'] = 'groovy',
        },
      })
    end,
  },
}
