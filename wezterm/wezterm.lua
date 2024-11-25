local WezTermLoader = require('config')

require('extensions.backdrops'):set_files():random()
require('events.right-status').setup()
require('events.left-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()
require('events.trigger-lazygit').setup()

return WezTermLoader:init()
  :append(require('config.appearance'))
  :append(require('config.keymaps'))
  :append(require('config.fonts'))
  :append(require('config.general'))
  :append(require('config.launch')).options
