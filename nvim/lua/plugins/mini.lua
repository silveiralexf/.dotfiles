return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.surround').setup({
        version = '*',
      })
    end,
  },
  {
    'yorickpeterse/nvim-tree-pairs',
    config = function()
      require('tree-pairs').setup()
    end,
  },
}
