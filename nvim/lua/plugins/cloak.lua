--- Cloak: hide .env* and similar
return {
  specs = {
    { src = 'https://github.com/laytan/cloak.nvim', name = 'cloak.nvim' },
  },
  config = function()
    local cloak = require('cloak')
    if type(cloak) == 'table' and cloak.setup then
      cloak.setup({
        enabled = true,
        cloak_character = '*',
        highlight_group = 'Comment',
        patterns = {
          {
            file_pattern = { '.env*', 'wrangler.toml', '.dev.vars' },
            cloak_pattern = '=.+',
          },
        },
      })
    end
  end,
}
