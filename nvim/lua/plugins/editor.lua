return {
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        width = 50,
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        lazy = true,
      },
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
      },
    },
    config = true,
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({ "*" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        "s1n7ax/nvim-window-picker",
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
                fg = "#ededed",
                bg = "#ff9e00",
                bold = true,
              },
              unfocused = {
                fg = "#ededed",
                bg = "#ee4592",
                bold = true,
              },
            },
          },
        },
      },
    },
    opts = {
      close_if_last_window = true,
      source_selector = {
        winbar = true,
      },
      filesystem = {
        use_libuv_file_watcher = true,
      },
      default_component_configs = {
        git_status = {
          symbols = {
            -- Change type
            added = "󰹍", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "󱢒", -- or "", but this is redundant info if you use git_status_colors on the namz
            deleted = "󰹌", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "󰹎",
            ignored = "",
            unstaged = "󰌩",
            staged = "",
            conflict = "",
          },
        },
      },
    },
    keys = {
      {
        "º",
        function()
          require("neo-tree.command").execute({
            position = "left",
            source = "filesystem",
            toggle = true,
            focused = true,
          })
        end,
        desc = "Explorer NeoTree",
      },
      {
        "\\º",
        function()
          require("neo-tree.command").execute({
            position = "left",
            reveal = true,
            source = "filesystem",
            toggle = true,
            focused = true,
          })
        end,
        desc = "Explorer NeoTree",
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      search = {
        modes = {
          search = {
            enabled = false,
          },
        },
      },
    },
  },
}
