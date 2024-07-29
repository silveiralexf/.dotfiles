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
              diagnostics = {
                globals = {
                  'after_each',
                  'before_each',
                  'describe',
                  'it',
                  'require',
                  'vim',
                },
              },
            },
          },
        },
      },
      setup = {
        lua_ls = function() end,
      },
    },
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
