--- Statusline. May use trouble for symbols. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/nvim-lualine/lualine.nvim', name = 'lualine.nvim' },
  },
  config = function()
    local lualine = require('lualine')
    if type(lualine) ~= 'table' or not lualine.setup then
      return
    end
    local opts = {
      options = { theme = 'auto' },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
    local trouble_ok, trouble = pcall(require, 'trouble')
    if trouble_ok and type(trouble) == 'table' and trouble.statusline then
      local symbols = trouble.statusline({
        mode = 'lsp_document_symbols',
        groups = {},
        title = false,
        filter = { range = true },
        format = '{kind_icon}{symbol.name:Normal}',
        hl_group = 'lualine_c_normal',
      })
      table.insert(opts.sections.lualine_c, { symbols.get, cond = symbols.has })
    end
    lualine.setup(opts)
  end,
}
