return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig')['yamlls']['yaml-companion'].setup({
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
                url = 'https://www.schemastore.org/api/json/catalog.json',
              },
              schemas = require('schemastore')['yaml-companion'].yaml.schemas({
                -- select subset from the JSON schema catalog
                select = {
                  '.github/workflows/*.{yml,yaml}',
                  'kustomization.yaml',
                  '.*docker-compose.{yml,yaml}',
                  '*.compose.{yml,yaml}',
                  'https://www.schemastore.org/api/json/catalog.json',
                  'https://json.schemastore.org/github-workflow.json',
                },

                -- additional schemas (not in the catalog)
                extra = {
                  name = 'Argo CD Application',
                  url = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json',
                  fileMatch = 'argocd-application.yaml',
                  {
                    name = 'Flux GitRepository',
                    uri = 'https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/gitrepository-source-v1.json',
                  },
                  {
                    name = 'RabbitMQ Cluster',
                    uri = 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/rabbitmq.com/rabbitmqcluster_v1beta1.json',
                  },
                  {
                    name = 'GitHub Workflows',
                    uri = 'https://json.schemastore.org/github-workflow.json',
                    fileMatch = '.github/workflows/*.{yml,yaml}',
                  },
                  {
                    name = 'Taskfile',
                    uri = 'https://raw.githubusercontent.com/go-task/task/blob/main/website/static/schema.json',
                    fileMatch = {
                      'Taskfile.bootstrap.yaml',
                      '{t,T}askfile.{yml,yaml}',
                      '{t,T}askfiles/*.{yml,yaml}',
                      '{t,T}asks/*.{yml,yaml}',
                      'taskfiles/*.y*ml',
                      'tasks/*/{t,T}askfile.*.y*ml',
                    },
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
