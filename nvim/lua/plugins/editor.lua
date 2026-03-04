--- Editor plugins: diffview, colorizer, aerial, flash, smartcolumn, zen-mode. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/sindrets/diffview.nvim', name = 'diffview.nvim' },
    { src = 'https://github.com/norcalli/nvim-colorizer.lua', name = 'nvim-colorizer.lua' },
    { src = 'https://github.com/stevearc/aerial.nvim', name = 'aerial.nvim' },
    { src = 'https://github.com/folke/flash.nvim', name = 'flash.nvim' },
    { src = 'https://github.com/m4xshen/smartcolumn.nvim', name = 'smartcolumn.nvim' },
    { src = 'https://github.com/folke/zen-mode.nvim', name = 'zen-mode.nvim' },
  },
  config = function()
    -- Shim deprecated vim.tbl_flatten for plugins that still use it (e.g. nvim-colorizer.lua)
    if vim.tbl_flatten and vim.iter then
      ---@diagnostic disable: duplicate-set-field
      vim.tbl_flatten = function(t)
        return vim.iter(t):flatten():totable()
      end
    end
    pcall(function()
      require('colorizer').setup({ '*' })
    end)
    local aerial = require('aerial')
    if type(aerial) == 'table' and aerial.setup then
      aerial.setup({ layout = { width = 50 } })
    end
    local flash = require('flash')
    if type(flash) == 'table' and flash.setup then
      flash.setup({ search = { modes = { search = { enabled = true } } } })
    end
    local smartcolumn = require('smartcolumn')
    if type(smartcolumn) == 'table' and smartcolumn.setup then
      smartcolumn.setup({
        disabled_filetypes = {
          'Outline',
          'aerial',
          'alpha',
          'help',
          'lazy',
          'mason',
          'neo-tree',
          'noice',
          'spectre_panel',
          'text',
        },
        custom_colorcolumn = { python = { '160', '200' } },
      })
    end
    vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<cr>', { desc = 'ZenMode' })
    local zen = require('zen-mode')
    if type(zen) == 'table' and zen.setup then
      zen.setup({
        plugins = { options = { laststatus = 0 }, tmux = { enabled = true } },
        window = { height = 1, width = 200, options = { signcolumn = 'number', foldcolumn = '0' } },
      })
    end
  end,
}
