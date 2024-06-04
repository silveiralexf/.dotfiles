return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").setup({
        opts = {
          codelens = {
            enabled = true,
          },
          servers = {
            helm_ls = {
              logLevel = "info",
              valuesFiles = {
                mainValuesFile = "values.yaml",
                lintOverlayValuesFile = "values.lint.yaml",
                additionalValuesFilesGlobPattern = "values*.yaml",
              },
              command = "helm_ls",
              filetypes = {
                "helm",
                "helmfile",
                "*helpers.tpl",
              },
              root_patterns = {
                "Chart.lock",
                "Chart.yaml",
              },
              args = {
                "serve",
              },
              yamlls = {
                enabled = true,
                diagnosticsLimit = 50,
                showDiagnosticsDirectly = false,
                path = "yaml-language-server",
                config = {
                  schemas = {
                    kubernetes = "templates/**",
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
    "towolf/vim-helm",
    event = "VeryLazy",
  },
}
