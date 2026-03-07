--- Cursor agent window: \c, \ca, \cc, \ct
return {
  specs = {
    { src = 'https://github.com/Loki-Astari/cursor', name = 'cursor' },
  },
  config = function()
    local cursor = require('cursor')
    if type(cursor) == 'table' and cursor.setup then
      cursor.setup({
        width = 50,
        auto_open = false,
        command = 'cursor-agent',
      })
    end
  end,
}
