require('utils.pass')
require('utils.launchers')

local HammerSpoonLoader = require('config')

return HammerSpoonLoader
  :init()
  :append(require('config.keymaps')) --
  .options
