--- Yazi file manager. Keys: \-, \ , \<up>. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/mikavilpas/yazi.nvim', name = 'yazi.nvim' },
  },
  config = function()
    local yazi = require('yazi')
    if type(yazi) ~= 'table' or not yazi.setup then
      return
    end
    yazi.setup({
      open_for_directories = true,
      use_ya_for_events_reading = true,
      use_yazi_client_id_flag = true,
      keymaps = { show_help = '<f9>' },
    })
    vim.keymap.set('n', '\\-', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
    vim.keymap.set('n', '\\ ', '<cmd>Yazi cwd<cr>', { desc = 'Open yazi in cwd' })
    vim.keymap.set('n', '\\<up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
  end,
}
