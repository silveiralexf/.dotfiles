--- Tmux integration.
return {
  specs = {
    { src = 'https://github.com/aserowy/tmux.nvim', name = 'tmux.nvim' },
  },
  config = function()
    local tmux = require('tmux')
    if type(tmux) == 'table' and tmux.setup then
      tmux.setup({})
    end
  end,
}
