local platform = require('extensions.platform')()

local options = {
  default_prog = {},
  launch_menu = {},
}

if platform.is_mac then
  options.default_prog = { 'zsh', '-l' }
  options.launch_menu = {
    { label = 'Bash', args = { 'bash', '-l' } },
    { label = 'Fish', args = { 'fish', '-l' } },
    { label = 'Nushell', args = { 'nu', '-l' } },
    { label = 'Zsh', args = { 'zsh', '-l' } },
  }
elseif platform.is_linux then
  options.default_prog = { 'zsh', '-l' }
  options.launch_menu = {
    { label = 'Bash', args = { 'bash', '-l' } },
    { label = 'Fish', args = { 'fish', '-l' } },
    { label = 'Zsh', args = { 'zsh', '-l' } },
  }
end

return options
