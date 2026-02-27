local util = require('lspconfig.util')

return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = LazyVim.extend(opts.servers.vtsls, 'settings.vtsls.tsserver.globalPlugins', {})
      opts.servers.volar = {
        filetypes = {
          'javascript',
          'javascriptreact',
          'json',
          'typescript',
          'typescriptreact',
          -- 'vue',
        },
        root_dir = util.root_pattern('src/App.vue'),
      }
    end,
  },
}
