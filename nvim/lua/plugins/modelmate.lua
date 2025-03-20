return {
  {
    'silveiralexf/nvim-modelmate',
    config = function()
      require('nvim-modelmate').setup({
        debug = false,
        model = 'codegemma:latest',
        -- model = 'llama3:8b',
      })
    end,
  },
}
