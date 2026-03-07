--- FzfLua: \z, \zb, \zg, \zf, etc. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/ibhagwan/fzf-lua', name = 'fzf-lua' },
  },
  config = function()
    local fzf = require('fzf-lua')
    if type(fzf) == 'table' and fzf.setup then
      fzf.setup({})
    end
  end,
}
