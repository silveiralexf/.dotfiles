return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}
