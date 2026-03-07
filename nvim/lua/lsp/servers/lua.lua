return {
  {
    'neovim/nvim-lspconfig',
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
                -- Portable paths for macOS and Linux (same config everywhere)
                path = {
                  '?.lua',
                  '?/init.lua',
                  '?/?.lua',
                  vim.fn.expand('$HOME/.dotfiles/lua_modules/share/lua/5.4/?.lua'),
                  vim.fn.expand('$HOME/.dotfiles/lua_modules/share/lua/5.4/?/init.lua'),
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
  },
}
