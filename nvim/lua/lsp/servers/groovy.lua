return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").setup({
        opts = {
          setup = {
            groovyls = {},
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "groovy" })
      vim.filetype.add({
        pattern = {
          [".*.Jenkinsfile"] = "groovy",
        },
      })
    end,
  },
}
