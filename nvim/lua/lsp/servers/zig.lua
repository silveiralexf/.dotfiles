return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").setup({
        opts = {
          setup = {
            zls = {},
          },
        },
      })
    end,
  },
}
