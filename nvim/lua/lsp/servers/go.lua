return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").setup({
        opts = {
          servers = {
            gopls = {
              settings = {
                gopls = {
                  gofumpt = true,
                  codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                  },
                  usePlaceholders = true,
                  completeUnimported = true,
                  staticcheck = true,
                  directoryFilters = {
                    "-.git",
                    "-.cache/**",
                    "-.gocache/**",
                    "-.vscode",
                    "-.idea",
                    "-.vscode-test",
                    "-node_modules",
                  },
                  semanticTokens = true,
                },
              },

              keys = {
                -- Workaround for the lack of a DAP strategy in neotest-go
                -- https://github.com/nvim-neotest/neotest-go/issues/12
                {
                  "<leader>td",
                  "<cmd>lua require('dap-go').debug_test()<CR>",
                  desc = "Debug Nearest (Go)",
                },
              },
              root_dir = vim.fs.dirname(vim.fs.find({ "go.work", "go.mod" }, { upward = true })[1]),
            },
          },
          setup = {
            gopls = function()
              require("lazyvim.util").lsp.on_attach(function(client, _)
                if client.name == "gopls" then
                  if client.config.capabilities == nil then
                    client.config.capabilities = {
                      workspace = {
                        didChangeWatchedFiles = {
                          dynamicRegistration = true,
                        },
                      },
                    }
                  end
                  if not client.server_capabilities.semanticTokensProvider then
                    local semantic = client.config.capabilities.textDocument.semanticTokens
                    if semantic then
                      client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = {
                          tokenTypes = semantic.tokenTypes,
                          tokenModifiers = semantic.tokenModifiers,
                        },
                        range = true,
                      }
                    end
                  end
                end
              end)
            end,
          },
        },
      })
    end,
  },
}
