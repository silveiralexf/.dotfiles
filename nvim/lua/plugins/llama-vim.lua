return {
  {
    'ggml-org/llama.vim',
    llama_config = function()
      require('llama.vim').setup({
        auto_fim = true,
        show_info = 2,
      })
    end,
  },
}
