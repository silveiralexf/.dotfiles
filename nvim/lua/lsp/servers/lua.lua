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
    'neovim/nvim-lspconfig',
    config = function()
      require('lspconfig').setup({
        {
          'S1M0N38/love2d.nvim',
          cmd = 'LoveRun',
          opts = {},
          keys = {
            { '\\v', ft = 'lua', desc = 'LÖVE' },
            { '\\vv', '<cmd>LoveRun<cr>', ft = 'lua', desc = 'Run LÖVE' },
            { '\\vs', '<cmd>LoveStop<cr>', ft = 'lua', desc = 'Stop LÖVE' },
          },
        },
      })
    end,
  },
}
