--- Mini.surround + nvim-tree-pairs
return {
  specs = {
    { src = 'https://github.com/nvim-mini/mini.nvim', name = 'mini.nvim' },
    { src = 'https://github.com/yorickpeterse/nvim-tree-pairs', name = 'nvim-tree-pairs' },
  },
  config = function()
    local ok_surround = pcall(require, 'mini.surround')
    if ok_surround then
      require('mini.surround').setup({ version = '*' })
    end
    local ok_tree = pcall(require, 'tree-pairs')
    if ok_tree then
      require('tree-pairs').setup()
    end
  end,
}
