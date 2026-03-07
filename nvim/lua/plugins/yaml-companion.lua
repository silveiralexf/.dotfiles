--- yaml-companion: YAML schema/document support (depends on plenary, lspconfig from other plugins)
return {
  specs = {
    { src = 'https://github.com/someone-stole-my-name/yaml-companion.nvim', name = 'yaml-companion.nvim' },
  },
  config = function()
    local yaml_companion = require('yaml-companion')
    if type(yaml_companion) == 'table' and yaml_companion.setup then
      yaml_companion.setup({})
    end
  end,
}
