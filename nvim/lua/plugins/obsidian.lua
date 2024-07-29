return {
  {
    'epwalsh/obsidian.nvim',
    config = function()
      require('obsidian').setup({
        version = '*',
        lazy = true,
        dependencies = {
          'nvim-lua/plenary',
        },
        workspaces = {
          {
            name = '000.zettelkasten',
            path = '~/.workspace/',
          },
        },
      })
    end,
  },
}
