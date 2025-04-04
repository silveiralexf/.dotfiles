return {
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      print('Loading minuet-ai.nvim') -- Debug print to verify loading
      require('minuet').setup({
        provider = 'openai_fim_compatible',
        n_completions = 1, -- recommend for local model for resource saving
        context_window = 1024,
        blink = {
          enable_auto_complete = true,
        },
        virtualtext = {
          -- Specify the filetypes to enable automatic virtual text completion
          auto_trigger_ft = {
            'md',
            'go',
            'lua',
            'yaml',
            'python',
            'javascript',
            'typescript',
            'sh',
            'bash',
            'zsh',
          },
          -- specify file types where automatic virtual text completion should be disabled
          auto_trigger_ignore_ft = { 'json' },
          -- Whether show virtual text suggestion when the completion menu is visible
          show_virtual_text = true, -- Changed to true for better visibility
          show_on_completion_menu = true,
        },
        provider_options = {
          openai_fim_compatible = {
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            model = 'qwen2.5-coder:1.5b',
            optional = {
              max_tokens = 200,
              top_p = 0.9,
              temperature = 0.2, -- Added lower temperature for more focused completions
            },
          },
        },
      })
    end,
  },
  {
    'saghen/blink.cmp',
    optional = true,
    opts = {
      keymap = {
        ['<A-y>'] = {
          function(cmp)
            cmp.show({ providers = { 'minuet' } })
          end,
        },
        ['<TAB>'] = {
          function(_)
            if require('minuet.virtualtext').action.is_visible() then
              vim.defer_fn(require('minuet.virtualtext').action.accept, 30)
              return true
            end
          end,
          'fallback',
        },
      },
      sources = {
        -- if you want to use auto-complete
        default = { 'minuet' },
        providers = {
          minuet = {
            name = 'minuet',
            module = 'minuet.blink',
            score_offset = 100,
          },
        },
      },
    },
  },
}
