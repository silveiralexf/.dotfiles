return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          codelens = {
            enabled = true,
          },
          servers = {
            helm_ls = {
              logLevel = 'info',
              valuesFiles = {
                mainValuesFile = 'values.yaml',
                lintOverlayValuesFile = 'values.lint.yaml',
                additionalValuesFilesGlobPattern = 'values*.yaml',
              },
              command = 'helm_ls',
              filetypes = {
                'helm',
                'helmfile',
                '*helpers.tpl',
              },
              root_patterns = {
                'Chart.lock',
                'Chart.yaml',
              },
              args = {
                'serve',
              },
              yamlls = {
                LazyVim.lsp.on_attach(function(_, buffer)
                  if vim.bo[buffer].filetype == 'helm' then
                    vim.schedule(function()
                      vim.cmd('LspStop ++force yamlls')
                    end)
                  end
                end),
                enabled = true,
                diagnosticsLimit = 50,
                showDiagnosticsDirectly = false,
                path = 'yaml-language-server',
                config = {
                  schemas = {
                    kubernetes = {
                      -- 'templates/**',
                      'Chart.yaml',
                      'values.local.yaml',
                      'values.yaml',
                    },
                  },
                  completion = true,
                  hover = true,
                },
              },
            },
          },
        },
      })
    end,
  },
  {
    'towolf/vim-helm',
    event = 'VeryLazy',
  },
}
