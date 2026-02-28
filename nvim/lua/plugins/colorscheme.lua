--- Sonokai colorscheme. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/sainnhe/sonokai', name = 'sonokai' },
  },
  config = function()
    vim.g.sonokai_better_performance = 1
    vim.g.rehash256 = 1
    vim.g.sublimemonokai_term_italic = 1
    vim.g.sonokai_transparent_background = 1
    vim.g.sonokai_show_eob = 0
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_diagnostic_text_highlight = 1
    vim.g.sonokai_diagnostic_virtual_text = 'colored'
    vim.g.sonokai_style = 'atlantis'
    vim.g.sonokai_menu_selection_background = 'green'
    vim.cmd.colorscheme('sonokai')
  end,
}
