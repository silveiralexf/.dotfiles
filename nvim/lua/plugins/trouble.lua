--- Trouble: quickfix/list UI.
return {
  specs = {
    { src = 'https://github.com/folke/trouble.nvim', name = 'trouble.nvim' },
  },
  config = function()
    vim.cmd.packadd('trouble.nvim')
    local ok, trouble = pcall(require, 'trouble')
    if not ok or type(trouble) ~= 'table' or type(trouble.setup) ~= 'function' then
      vim.notify('[trouble] failed to load: ' .. tostring(trouble), vim.log.levels.ERROR)
      return
    end
    trouble.setup({
      auto_open = false,
      auto_close = true,
      modes = {
        lsp = {
          win = { position = 'right' },
        },
        symbols = {
          desc = 'document symbols',
          mode = 'lsp_document_symbols',
          focus = false,
          win = { position = 'right' },
        },
      },
    })
    -- Diagnostic: show what modes and rtp state looks like after setup
    vim.schedule(function()
      local cfg_ok, Config = pcall(require, 'trouble.config')
      local src_ok, Sources = pcall(require, 'trouble.sources')
      local rtp_files = vim.api.nvim_get_runtime_file('lua/trouble/sources/*.lua', true)
      vim.notify(string.format(
        '[trouble] rtp sources found: %d | sources registered: %d | modes: %s',
        #rtp_files,
        vim.tbl_count(src_ok and Sources.sources or {}),
        cfg_ok and table.concat(Config.modes(), ', ') or 'error'
      ), vim.log.levels.INFO)
    end)
    vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble: diagnostics' })
    vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble: buffer diagnostics' })
    vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Trouble: quickfix list' })
    vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Trouble: location list' })
    vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle<cr>', { desc = 'Trouble: document symbols' })
    vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle<cr>', { desc = 'Trouble: LSP refs/defs' })
    vim.keymap.set('n', ']q', function()
      if trouble.is_open() then
        trouble.next({ skip_groups = true, jump = true })
      else
        local ok2, err = pcall(vim.cmd.cnext)
        if not ok2 then vim.notify(err, vim.log.levels.ERROR) end
      end
    end, { desc = 'Next trouble/quickfix item' })
    vim.keymap.set('n', '[q', function()
      if trouble.is_open() then
        trouble.prev({ skip_groups = true, jump = true })
      else
        local ok2, err = pcall(vim.cmd.cprev)
        if not ok2 then vim.notify(err, vim.log.levels.ERROR) end
      end
    end, { desc = 'Prev trouble/quickfix item' })
  end,
}
