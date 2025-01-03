return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod', 'gowork', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },

    -- if you need to install/update all binaries
    build = ':lua require("go.install").update_all_sync()',
  },
}
