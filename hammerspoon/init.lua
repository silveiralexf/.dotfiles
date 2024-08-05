require('utils.launchers')
require('plugins.HammerPass')

-- hs.loadSpoon('ShiftIt')
-- spoon.ShiftIt:bindHotkeys({})

HammerSpoonLoader = require('config')
return {
  {
    HammerSpoonLoader
      :init()
      :append(require('config.keymaps')) --
      .options,
  },
}
