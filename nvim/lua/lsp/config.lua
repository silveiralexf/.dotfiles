return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'j-hui/fidget.nvim',
    },
  },
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mason-org/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'bzl',
        'clangd',
        'cmake',
        'gopls',
        'helm_ls',
        'jdtls',
        'jsonls',
        'marksman',
        'pylsp',
        'taplo',
      },
    },
  },
}
