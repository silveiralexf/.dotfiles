return {
  {
    "neovim/nsp-config",
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
