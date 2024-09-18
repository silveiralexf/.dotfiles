return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup({})
    end,
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-lua/plenary.nvim',
        lazy = true,
      },
      {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
      },
    },
    config = true,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'VeryLazy',
    config = function()
      require('colorizer').setup({ '*' })
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      layout = {
        width = 50,
      },
    },
  },
  {
    'folke/flash.nvim',
    opts = {
      search = {
        modes = {
          search = {
            enabled = true,
          },
        },
      },
    },
    {
      'folke/zen-mode.nvim',
      keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'ZenMode' } },
      desc = 'ZenMode',
      opts = {
        plugins = {
          options = {
            laststatus = 0,
          },
          tmux = { enabled = true },
        },
        window = {
          height = 1,
          width = 200,
          options = {
            signcolumn = 'number',
            foldcolumn = '0',
          },
        },
      },
    },
  },
  {
    'm4xshen/smartcolumn.nvim',
    opts = {
      disabled_filetypes = {
        'Outline',
        'aerial',
        'alpha',
        'help',
        'lazy',
        'mason',
        'neo-tree',
        'noice', ---@diagnostic disable-line
        'spectre_panel',
        'text',
      },
      custom_colorcolumn = {
        python = { '160', '200' },
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    opts = function(_, opts)
      local trouble = require('trouble')
      local symbols = trouble.statusline({
        mode = 'lsp_document_symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        hl_group = 'lualine_c_normal',
      })
      table.insert(opts.sections.lualine_c, {
        symbols.get,
        cond = symbols.has,
      })
    end,
  },
  { 'kosayoda/nvim-lightbulb' },
  config = function()
    require('nvim-lightbulb').setup({
      --ignore = { "null-ls" },
      status_test = {
        enabled = true,
        text = '💡',
        text_unavailable = 'no actions',
      },
      float = {
        enabled = true,
      },
      line = {
        enabled = true,
        statusline = {
          enabled = true,
          text = '💡',
          text_unavailable = 'no actions',
        },
      },
    })
    vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
  end,
}
