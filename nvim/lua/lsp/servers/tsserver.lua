local util = require('lspconfig.util')

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        opts = function(_, opts)
          opts.servers = {
            LazyVim.extend(opts.servers.vtsls, 'settings.vtsls.tsserver.globalPlugins', {}),
            volar = {
              filetypes = {
                'javascript',
                'javascriptreact',
                'json',
                'typescript',
                'typescriptreact',
                -- 'vue',
              },
              root_dir = util.root_pattern('src/App.vue'),
            },
          }
        end,
      })
    end,
  },
}
