require('extensions.launchers')
require('extensions.hammerPass')

HammerSpoonLoader = require('config')
return {
  {
    HammerSpoonLoader
      :init()
      :append(require('config.keymaps')) --
      .options,
  },
}
