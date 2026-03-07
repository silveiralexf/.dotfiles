--- Find and replace in all files (project-wide). Depends on plenary, ripgrep, devicons.
return {
  specs = {
    { src = 'https://github.com/nvim-pack/nvim-spectre', name = 'nvim-spectre' },
  },
  config = function()
    local spectre = require('spectre')
    if type(spectre) ~= 'table' or not spectre.setup then
      return
    end
    spectre.setup({})
  end,
}
