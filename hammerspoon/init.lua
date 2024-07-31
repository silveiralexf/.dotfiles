require('utils.pass')
require('utils.launchers')

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
