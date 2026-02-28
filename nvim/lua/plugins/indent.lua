--- Indent blankline + rainbow-delimiters. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/HiPhish/rainbow-delimiters.nvim', name = 'rainbow-delimiters.nvim' },
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim', name = 'indent-blankline.nvim' },
  },
  config = function()
    local ibl = require('ibl')
    if type(ibl) ~= 'table' or not ibl.setup then
      return
    end
    local highlight = {
      'RainbowRed', 'RainbowYellow', 'RainbowBlue', 'RainbowOrange',
      'RainbowGreen', 'RainbowViolet', 'RainbowCyan', 'CursorColumn', 'WhiteSpace',
    }
    local hooks_ok, hooks = pcall(require, 'ibl.hooks')
    if hooks_ok and hooks then
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)
    end
    vim.g.rainbow_delimiters = { highlight = highlight }
    ibl.setup({
      indent = { highlight = highlight, char = '┊', tab_char = '|' },
      scope = { enabled = false, show_start = false, show_end = false, highlight = highlight },
      whitespace = { remove_blankline_trail = false },
      exclude = {
        filetypes = { 'NvimTree', 'Trouble', 'dashboard', 'git', 'help', 'markdown', 'notify', 'packer', 'terminal', 'undotree' },
        buftypes = { 'terminal', 'nofile', 'prompt', 'quickfix' },
      },
    })
  end,
}
