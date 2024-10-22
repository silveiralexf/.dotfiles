-- List of disabled plugins
return {
  -- neodev.nvim conflicts with lazydev,
  -- keeping this here just for reference
  {
    'folke/neodev.nvim',
    enabled = false,
  },
  {
    'akinsho/bufferline.nvim',
    enabled = false,
  },
  {
    'DavidAnson/markdownlint',
    enabled = false,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false,
  },
}
