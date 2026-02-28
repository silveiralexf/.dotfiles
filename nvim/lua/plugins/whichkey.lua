--- Which-key: popup with keybindings. Eager so <leader>k works at startup.
return {
  specs = {
    {
      src = 'https://github.com/folke/which-key.nvim',
      name = 'which-key.nvim',
      version = nil, -- default branch
    },
  },
  -- No lazy: load at startup so keymaps (e.g. <leader>k) work immediately.
}
