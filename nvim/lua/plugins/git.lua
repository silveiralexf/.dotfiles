return {
  {
    'lewis6991/gitsigns.nvim',
    opts = function(_, opts)
      opts.current_line_blame = true
    end,
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '┃' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end, { desc = 'Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end, { desc = 'Previous hunk' })

          -- Actions
          map('n', '\\gs', gitsigns.stage_hunk, { desc = 'stage hunk' })
          map('n', '\\gr', gitsigns.reset_hunk, { desc = 'reset hunk' })

          map('v', '\\gs', function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'stage hunk' })

          map('v', '\\gr', function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, { desc = 'reset hunk' })

          map('n', '\\gS', gitsigns.stage_buffer, { desc = 'stage buffer' })
          map('n', '\\gu', gitsigns.undo_stage_hunk, { desc = 'undo stage hunk' })
          map('n', '\\gR', gitsigns.reset_buffer, { desc = 'reset buffer' })
          map('n', '\\gp', gitsigns.preview_hunk, { desc = 'preview hunk' })
          map('n', '\\gP', gitsigns.preview_hunk_inline, { desc = 'review hunk inline' })

          map('n', '\\gb', function()
            gitsigns.blame_line({ full = true })
          end, { desc = 'git blame line' })

          map('n', '\\gtb', gitsigns.toggle_current_line_blame, { desc = 'toggle line blame' })
          map('n', '\\gd', gitsigns.diffthis, { desc = 'diff this' })

          map('n', '\\gD', function()
            gitsigns.diffthis('~')
          end, { desc = 'Diff this and stage changes' })

          map('n', '\\gtd', gitsigns.toggle_deleted, { desc = 'toggle deleted' })
          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
      })
    end,
  },
}
