--- Noice: cmdline, messages, popupmenu UI. Depends on nui.nvim; nvim-notify optional.
return {
  specs = {
    { src = 'https://github.com/folke/noice.nvim', name = 'noice.nvim' },
    { src = 'https://github.com/rcarriga/nvim-notify', name = 'nvim-notify' },
  },
  config = function()
    local noice = require('noice')
    if type(noice) == 'table' and noice.setup then
      noice.setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
    end
    local notify = require('notify')
    if type(notify) == 'table' and notify.setup then
      notify.setup({})
    end
  end,
}
