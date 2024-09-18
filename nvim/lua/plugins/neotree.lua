return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    config = function()
      require('neo-tree').setup({
        -- opts = {
        -- },
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added = '󰹍', -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = '󱢒', -- or "", but this is redundant info if you use git_status_colors on the namz
              deleted = '󰹌', -- this can only be used in the git_status source
              renamed = '󰁕', -- this can only be used in the git_status source
              -- Status type
              untracked = '󰹎',
              ignored = '',
              unstaged = '󰌩',
              staged = '',
              conflict = '',
            },
          },
        },
        filesystem = {
          use_libuv_file_watcher = true,
          follow_current_file = {
            enabled = true,
          },
        },
        close_if_last_window = true,
        source_selector = {
          winbar = true,
        },
        buffers = {
          follow_current_file = {
            enabled = true,
          },
        },
        window = {
          mappings = {
            ['P'] = {
              'toggle_preview',
              config = { use_float = false, use_image_nvim = false },
            },
          },
        },
      })
    end,
    keys = {
      {
        '§',
        function()
          require('neo-tree.command').execute({
            position = 'left',
            source = 'filesystem',
            toggle = true,
            focused = true,
          })
        end,
        desc = 'Explorer NeoTree',
      },
      {
        '\\§',
        function()
          require('neo-tree.command').execute({
            position = 'left',
            reveal = true,
            source = 'filesystem',
            toggle = true,
            focused = true,
          })
        end,
        desc = 'Explorer NeoTree',
      },
    },
    dependencies = {
      {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
        '3rd/image.nvim',
      },
      {
        's1n7ax/nvim-window-picker',
        lazy = true,
        opts = {
          show_prompt = false,
          filter_rules = {
            autoselect_one = false,
            include_current_win = true,
          },
          highlights = {
            statusline = {
              focused = {
                fg = '#ededed',
                bg = '#ff9e00',
                bold = true,
              },
              unfocused = {
                fg = '#ededed',
                bg = '#ee4592',
                bold = true,
              },
            },
          },
        },
      },
    },
  },
}
