return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({
          initial_mode = "normal",
        }),
        require("telescope.sorters").get_fzy_sorter({}),
      },
    },
    setup = function()
      vim.cmd([[packadd nvim-telescope/telescope]])
    end,
  },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    {
      "nvim-telescope/telescope-project.nvim",
      event = "VeryLazy",
      config = function()
        require("telescope").load_extension("project")
      end,
    },
    {
      "ThePrimeagen/git-worktree.nvim",
      event = "VeryLazy",
      keys = {
        { -- lazy style key map
          "<leader>cw",
          "<cmd>Telescope git_worktree<cr>",
          desc = "undo history",
        },
      },
      config = function()
        require("telescope").load_extension("git_worktree")
      end,
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      event = "VeryLazy",
      config = function()
        require("telescope").load_extension("ui-select")
      end,
    },
    {
      "debugloop/telescope-undo.nvim",
      event = "VeryLazy",
      keys = {
        { -- lazy style key map
          "<leader>cu",
          "<cmd>Telescope undo<cr>",
          desc = "undo history",
        },
      },
      config = function()
        require("telescope").load_extension("undo")
      end,
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        vertical = {
          mirror = false,
        },
        width = 0.80,
        height = 0.85,
        preview_cutoff = 120,
      },
    },

    setup = function()
      vim.cmd([[packadd telescope]])
    end,
  },
}
