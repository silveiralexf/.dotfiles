local wezterm = require('wezterm')

local M = {}

local LAZY_BIN = wezterm.home_dir .. '/opt/homebrew/bin/lazygit'

M.setup = function()
  wezterm.on('trigger-lazygit', function(window, pane)
    window:perform_action(
      pane:split({
        direction = 'Right',
        label = 'Open Lazygit',
        args = { LAZY_BIN },
        size = 0.75,
      }),
      pane
    )
  end)
end

return M
