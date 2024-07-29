return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          servers = {
            dockerls = {},
            docker_compose_language_service = {},
          },
          linters_by_ft = {
            dockerfile = { 'hadolint' },
          },
        },
      })
    end,
  },
}
