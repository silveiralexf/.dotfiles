return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        terraformls = {
          cmd = { 'terraform-ls', 'serve' },
          -- Omit terraform.path so terraformls uses PATH (same on macOS, Omarchy, Ubuntu)
          init_options = {
            terraform = {},
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
  },
  {
    'Afourcat/treesitter-terraform-doc.nvim',
    opts = function()
      local uname = (vim.uv and vim.uv.os_uname or vim.loop.os_uname)()
      local url_opener = (uname and uname.sysname == 'Darwin') and '!open' or '!xdg-open'
      return {
        command_name = 'OpenDoc',
        url_opener_command = url_opener,
        jump_argument = true,
      }
    end,
  },
}
