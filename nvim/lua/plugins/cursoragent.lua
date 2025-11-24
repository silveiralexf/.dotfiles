return {
  {
    'Loki-Astari/cursor',
    config = function()
      require('cursor').setup({
        width = 50, -- Width of the cursor window (default: 50)
        auto_open = false, -- Auto-open on startup (default: false)
        command = 'cursor-agent',
      })
    end,
  },
}
