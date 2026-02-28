--- Matchup: extended % matching
return {
  specs = {
    { src = 'https://github.com/andymass/vim-matchup', name = 'vim-matchup' },
  },
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
}
