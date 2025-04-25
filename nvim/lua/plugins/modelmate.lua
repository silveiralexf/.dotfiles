return {
  {
    'silveiralexf/nvim-modelmate',
    config = function()
      require('nvim-modelmate').setup({
        debug = false,
        model = 'codegemma:latest',
      })
    end,
  },
}
