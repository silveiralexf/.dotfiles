--- Trouble: quickfix/list UI. Load plugin, setup, then register keymaps (Lazy-style: config runs after plugin is ready).
return {
  specs = {
    { src = 'https://github.com/folke/trouble.nvim', name = 'trouble.nvim' },
  },
  config = function()
    -- Ensure plugin is on rtp before require (like Lazy loading the plugin before config).
    vim.cmd.packadd('trouble.nvim')
    local trouble = require('trouble')
    if type(trouble) ~= 'table' or type(trouble.setup) ~= 'function' then
      return
    end
    trouble.setup({
      auto_open = false,
      auto_close = true,
      -- Override "symbols" so it has .source (default alias has only mode = "lsp_document_symbols";
      -- section builder requires .source or Sources.get(nil) errors).
      modes = {
        symbols = {
          desc = 'document symbols',
          mode = 'lsp_document_symbols',
          source = 'lsp.document_symbols',
          focus = false,
          win = { position = 'right' },
        },
      },
    })
    -- Register sources so modes (diagnostics, qflist, loclist, lsp, symbols) exist.
    -- 1) Load from rtp (finds lua/trouble/sources/*.lua under the plugin).
    local Sources = require('trouble.sources')
    Sources.load()
    -- 2) Ensure core sources are registered (in case load() didn't find them under pack).
    for _, name in ipairs({ 'diagnostics', 'qf', 'lsp' }) do
      if not Sources.sources[name] then
        local ok, err = pcall(Sources.register, name)
        if not ok then
          vim.notify(('trouble: failed to register source %s: %s'):format(name, tostring(err)), vim.log.levels.WARN, { title = 'Trouble' })
        end
      end
    end
    -- Keymaps only after Trouble is fully set up (mirrors Lazy spec keys).
    local function toggle(opts)
      return function()
        pcall(trouble.toggle, opts)
      end
    end
    vim.keymap.set('n', '<leader>xx', toggle({ mode = 'diagnostics' }), { desc = 'Trouble: diagnostics (errors/warnings)' })
    vim.keymap.set('n', '<leader>xX', toggle({ mode = 'diagnostics', filter = { buf = 0 } }), { desc = 'Trouble: buffer diagnostics' })
    vim.keymap.set('n', '<leader>xQ', toggle({ mode = 'qflist' }), { desc = 'Trouble: quickfix list' })
    vim.keymap.set('n', '<leader>xL', toggle({ mode = 'loclist' }), { desc = 'Trouble: location list' })
    vim.keymap.set('n', '<leader>cs', toggle({ mode = 'lsp_document_symbols', focus = false }), { desc = 'Trouble: document symbols' })
    vim.keymap.set('n', '<leader>cl', toggle({ mode = 'lsp', focus = false, win = { position = 'right' } }), { desc = 'Trouble: LSP refs/defs' })
  end,
}
