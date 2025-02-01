return {
  {
    'sainnhe/sonokai',
    -- lazy = false,
    -- priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.sonokai_better_performance = 1
      vim.g.rehash256 = 1
      vim.g.sublimemonokai_term_italic = 1

      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_show_eob = 0
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_diagnostic_text_highlight = 1
      -- vim.g.sonokai_diagnostic_line_highlight = 1
      vim.g.sonokai_diagnostic_virtual_text = 'colored'
      vim.g.sonokai_style = 'atlantis'
      vim.g.sonokai_menu_selection_background = 'green'
    end,
  },
  {
    'LazyVim/LazyVim',
    opts = {
      colorscheme = { 'sonokai' },
    },
  },
}
