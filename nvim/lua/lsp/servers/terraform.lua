return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        cmd = {
          'terraform-ls',
          'serve',
        },
        opts = {
          servers = {
            terraformls = {
              init_options = {
                terraform = {
                  path = '/opt/homebrew/bin/terraform',
                },
              },
              capabilities = {
                experimental = {
                  prefillRequiredFields = true,
                  showReferencesCommandId = 'client.showReferences',
                  referenceCountCodeLens = true,
                  refreshModuleProviders = true,
                  refreshModuleCalls = true,
                  refreshTerraformVersion = true,
                },
              },
              settings = {
                terraformls = {
                  timeout = 60,
                },
              },
            },
          },
        },
      })
    end,
  },
  {
    'Afourcat/treesitter-terraform-doc.nvim',
    opts = {
      command_name = 'OpenDoc',
      url_opener_command = '!open',
      jump_argument = true,
    },
  },
}
