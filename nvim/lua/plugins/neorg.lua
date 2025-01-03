return {
  {
    'nvim-neorg/neorg',
    lazy = false,
    version = '*',
    run = ':Neorg sync-parsers',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-neorg/neorg-telescope',
    },
    config = function()
      require('neorg').setup({
        load = {
          ['core.defaults'] = {},
          ['core.journal'] = {},
          ['core.completion'] = {
            config = {
              engine = 'nvim-cmp',
            },
          },
          ['core.dirman'] = {
            config = {
              workspaces = {
                mind = '~/git/.zettelkasten',
              },
              default_workspace = 'mind',
              index = 'index.norg', -- The name of the main (root) .norg file
              use_popup = true,
            },
          },
          ['core.summary'] = {},
          ['core.concealer'] = {}, -- Adds pretty icons to your documents
          ['core.itero'] = {}, -- <M-CR> to add header/list items
          ['core.promo'] = {}, -- promotes/demotes headers, etc
          ['core.qol.toc'] = {},
          ['core.qol.todo_items'] = {},
          ['core.esupports.metagen'] = { config = { update_date = false } }, -- do not update date until https://github.com/nvim-neorg/neorg/issues/1579 fixed
        },
      })
      vim.wo.foldlevel = 99
      vim.wo.conceallevel = 2
    end,
  },
}
