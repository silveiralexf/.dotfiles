return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1000,
    config = true,
  },
  {
    'camspiers/luarocks',
    dependencies = {
      'rcarriga/nvim-notify', -- Optional dependency
    },
    opts = {
      rocks = {
        'fzy',
        'jsregexp',
      },
    },
  },
}
