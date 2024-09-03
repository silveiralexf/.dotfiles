local util = require('lspconfig.util')

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = function(_, opts)
          opts.servers = {
            LazyVim.extend(opts.servers.vtsls, 'settings.vtsls.tsserver.globalPlugins', {
              {
                name = 'typescript-svelte-plugin',
                location = LazyVim.get_pkg_path('svelte-language-server', '/node_modules/typescript-svelte-plugin'),
                enableForWorkspaceTypeScriptVersions = true,
              },
            }),
            volar = {
              filetypes = {
                'javascript',
                'javascriptreact',
                'json',
                'typescript',
                'typescriptreact',
                'vue',
              },
              root_dir = util.root_pattern('src/App.vue'),
            },
            svelte = {
              keys = {
                {
                  '<leader>co',
                  LazyVim.lsp.action['source.organizeImports'],
                  desc = 'Organize Imports',
                },
              },
              cmd = {
                { 'svelteserver', '--stdio' },
              },
              root_dir = {
                root_dir = util.root_pattern('package.json'),
              },
              capabilities = {
                workspace = {
                  didChangeWatchedFiles = vim.fn.has('nvim-0.10') == 0 and { dynamicRegistration = true },
                },
              },
            },
          }
        end,
      })
    end,
  },
}
