--- ModelMate: \m, \mo (ModelLlama)
return {
  specs = {
    { src = 'https://github.com/silveiralexf/nvim-modelmate', name = 'nvim-modelmate' },
  },
  config = function()
    local modelmate = require('nvim-modelmate')
    if type(modelmate) == 'table' and modelmate.setup then
      modelmate.setup({
        debug = false,
        model = 'codegemma:latest',
      })
    end
  end,
}
