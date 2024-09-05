-- local cfg = require('yaml-companion').setup({
--   -- Additional schemas available in Telescope picker
--   schemas = {
--   },
--
--   -- Pass any additional options that will be merged in the final LSP config
--   -- Defaults: https://github.com/someone-stole-my-name/yaml-companion.nvim/blob/main/lua/yaml-companion/config.lua
--   lspconfig = {
--     settings = {
--       yaml = {
--         validate = true,
--         schemaStore = {
--           enable = false,
--           url = '',
--         },
--         schemas = {
--           ['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*.{yml,yaml}',
--         },
--       },
--     },
--   },
-- })
--
return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = {
          codelens = true,
        },
        servers = {
          yamlls = {
            capabilities = {
              textDocument = {
                foldingRange = {
                  dynamicRegistration = true,
                  lineFoldingOnly = true,
                },
              },
            },
          },
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
            vim.list_extend(new_config.settings.yaml.schemas, require('schemastore').yaml.schemas())
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                -- Must disable built-in schemaStore support to use
                enable = true,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              schemas = require('schemastore').yaml.schemas({
                -- select subset from the JSON schema catalog
                select = {
                  '.github/workflows/*.{yml,yaml}',
                  'kustomization.yaml',
                  '.*docker-compose.{yml,yaml}',
                  '*.compose.{yml,yaml}',
                  'https://json.schemastore.org/github-workflow.json',
                },

                -- additional schemas (not in the catalog)
                extra = {
                  name = 'Argo CD Application',
                  url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
                  fileMatch = 'argocd-application.yaml',
                },
                Taskfile = {
                  url = 'https://raw.githubusercontent.com/go-task/task/blob/main/website/static/schema.json',
                  name = 'Taskfile',
                  fileMatch = {
                    '{t,T}askfile.{yml,yaml}',
                    '{t,T}askfiles/*.{yml,yaml}',
                    '{t,T}asks/*.{yml,yaml}',
                    'taskfiles/*.y*ml',
                  },
                  {
                    name = 'Flux GitRepository',
                    uri = 'https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/gitrepository-source-v1.json',
                  },
                  {
                    name = 'RabbitMQ Cluster',
                    uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/rabbitmq.com/rabbitmqcluster_v1beta1.json',
                  },
                },
              }),
            },
          },
        },
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              url = '',
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      })
    end,
  },
}
