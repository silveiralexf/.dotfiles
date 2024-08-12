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
            lua_ls = {
              settings = {
                Lua = {
                  completion = {
                    callSnippet = 'Both',
                  },
                  runtime = {
                    path = {
                      '?.lua',
                      '?/init.lua',
                      '?/?.lua',
                      '/home/hiphish/.luarocks/share/lua/5.4/?.lua',
                      '/home/hiphish/.luarocks/share/lua/5.4/?/init.lua',
                      '/usr/share/5.4/?.lua',
                      '/usr/share/lua/5.4/?/init.lua',
                    },
                    version = 'Lua 5.4',
                  },

                  diagnostics = {
                    globals = {
                      'after_each',
                      'before_each',
                      'describe',
                      'it',
                      'require',
                      'vim',
                      'hs',
                    },
                    workspace = {
                      library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        maxPreload = 1000,
                        preloadFileSize = 1000,
                      },
                    },
                  },
                },
              },
            },
          },
        },
      })
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'chrisgrieser/cmp_yanky',
        'hrsh7th/cmp-nvim-lua',
        'cmp',
      })
      local cmp = require('cmp')
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = 'cmp_yanky' },
        { name = 'nvim_lua' },
      }))
    end,
  },
}
