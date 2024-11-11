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
  {
    'lukas-reineke/indent-blankline.nvim',
    tag = 'v3.8.3',
    enabled = true,
    main = 'ibl',
    opts = {},
    dependencies = {
      { 'HiPhish/rainbow-delimiters.nvim', lazy = true },
    },

    config = function(_)
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
        'CursorColumn',
        'WhiteSpace',
      }
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }

      require('ibl').setup({
        indent = {
          highlight = highlight,
          char = '┊',
          tab_char = '|',
        },
        scope = {
          enabled = false,
          show_start = false,
          show_end = false,
          highlight = highlight,
        },
        whitespace = {
          remove_blankline_trail = false,
        },
        exclude = {
          filetypes = {
            'NvimTree',
            'Trouble',
            'dashboard',
            'git',
            'help',
            'markdown',
            'notify',
            'packer',
            'sagahover',
            'terminal',
            'undotree',
          },
          buftypes = { 'terminal', 'nofile', 'prompt', 'quickfix' },
        },
      })
    end,
  },
}
