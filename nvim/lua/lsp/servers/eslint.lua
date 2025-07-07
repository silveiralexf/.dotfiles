return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      codelens = {
        enabled = true,
      },
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = 'auto' },
            format = true,
            showDocumentation = {
              enable = true,
            },
            command = { 'vscode-eslint-language-server', '--stdio' },
            init_options = {
              configurationSection = { 'html', 'css', 'javascript' },
              embeddedLanguages = {
                css = true,
                javascript = true,
              },
              provideFormatter = true,
            },
            filetypes = {
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'typescript',
              'typescriptreact',
              'typescript.tsx',
              -- 'vue',
              -- 'svelte',
              'astro',
            },
          },
        },
      },
      setup = {
        eslint = function()
          local function get_client(buf)
            return require('lazyvim.util').lsp.get_clients({ name = 'eslint', bufnr = buf })[1]
          end

          local formatter = require('lazyvim.util').lsp.formatter({
            name = 'eslint: lsp',
            primary = true,
            priority = 200,
            filter = 'eslint',
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, 'vim.lsp._dynamic') then
            formatter.name = 'eslint: EslintFixAll'
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { 'eslint' } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, {
                  namespace = vim.lsp.diagnostic.get_namespace(client.id),
                })
                if #diag > 0 then
                  vim.cmd('EslintFixAll')
                end
              end
            end
          end

          -- register the formatter with LazyVim
          require('lazyvim.util').format.register(formatter)
        end,
      },
    },
  },
}
