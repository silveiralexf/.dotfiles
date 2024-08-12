return {
  {
    'telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end,
    },
    {
      'nvim-telescope/telescope-project.nvim',
      event = 'VeryLazy',
      config = function()
        require('telescope').load_extension('project')
      end,
    },
    {
      'ThePrimeagen/git-worktree.nvim',
      event = 'VeryLazy',
      keys = {
        { -- lazy style key map
          '<leader>gw',
          '<cmd>Telescope git_worktree<cr>',
          desc = 'undo history',
        },
      },
      config = function()
        require('telescope').load_extension('git_worktree')
      end,
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
      event = 'VeryLazy',
      config = function()
        require('telescope').load_extension('ui-select')
      end,
    },
    {
      'debugloop/telescope-undo.nvim',
      event = 'VeryLazy',
      keys = {
        { -- lazy style key map
          '<leader>cu',
          '<cmd>Telescope undo<cr>',
          desc = 'undo history',
        },
      },
      config = function()
        require('telescope').load_extension('undo')
      end,
    },
    {
      'xiyaowong/telescope-emoji.nvim',
      keys = {
        { '<leader>se', '<cmd>Telescope emoji<cr>', desc = 'Telescope search emoji' },
      },
      config = function()
        require('telescope').load_extension('emoji')
        require('telescope').load_extension('media_files')
      end,
    },
    {
      'nvim-telescope/telescope-media-files.nvim',
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
        },
        lsp_references = { include_declaration = false, show_line = false },
        lsp_implementations = { show_line = false },
        -- live_grep = { glob_pattern = { "!api/*", "!go.sum" } },
      },
      defaults = {
        layout_strategy = 'horizontal',
        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top',
        },
        vertical = {
          mirror = false,
        },
        width = 0.95,
        height = 0.95,
        preview_cutoff = 160,
      },
    },

    setup = function()
      vim.cmd([[packadd telescope]])
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      {
        '<leader>fp',
        function()
          require('telescope.builtin').find_files({
            cwd = require('lazy.core.config').options.root,
          })
        end,
        desc = 'Find Plugin File',
      },
    },
    opts = {
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { prompt_position = 'top' },
        sorting_strategy = 'ascending',
        winblend = 0,
        path_display = { shorten = 7, exclude = { 1, -1 } },
        prompt_prefix = '🔭 ',
        selection_caret = ' ',
        vimgrep_arguments = { 'rg', '--vimgrep', '--smart-case', '-M', '200' },
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({
          initial_mode = 'normal',
        }),
        require('telescope.sorters').get_fzy_sorter({}),
      },
      ['emoji'] = {
        action = function(emoji)
          vim.api.nvim_put({ emoji.value }, 'b', false, true)
        end,
      },
      ['media_files'] = {
        media_files = {
          filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
          find_cmd = { 'rg', '--vimgrep', '--smart-case', '-M', '200' },
        },
      },
    },
    setup = function()
      vim.cmd([[packadd nvim-telescope/telescope]])
    end,
  },
}
