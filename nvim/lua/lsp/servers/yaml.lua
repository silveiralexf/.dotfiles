return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      codelens = {
        enabled = true,
      },
      servers = {
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          -- lazy-load schema-store when needed
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
                enable = false,
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
                  url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
                  name = 'Argo CD Application',
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
                },
              }),
            },
          },
        },
      },
    },
  },
}
