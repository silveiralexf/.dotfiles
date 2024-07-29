return {
  {
    'silveiralexf/nvim-llama',
    config = function()
      require('nvim-llama').setup({
        debug = false,
        model = 'llama3',
      })
    end,
  },
  {
    'nomnivore/ollama.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- All the user commands added by the plugin
    cmd = { 'Ollama', 'OllamaModel', 'OllamaServe', 'OllamaServeStop' },
    keys = {
      -- Sample keybind for prompt menu.
      -- Note that the <c-u> is important for selections to work properly.
      {
        '<leader>Op',
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = 'Ollama prompt',
        mode = { 'n', 'v' },
      },

      -- Sample keybind for direct prompting.
      -- Note that the <c-u> is important for selections to work properly.
      {
        '<leader>Og',
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = 'Ollama Generate Code',
        mode = { 'n', 'v' },
      },
    },

    ---@diagnostic disable-next-line
    ---@type Ollama.Config
    opts = {
      model = 'llama3',
      url = 'http://127.0.0.1:11434',
      stream = true,
      replace = false,
      serve = {
        on_start = false,
        command = 'ollama',
        args = { 'serve' },
        stop_command = 'pkill',
        stop_args = { '-SIGTERM', 'ollama' },
      },
      prompts = {
        Sample_Prompt = {
          prompt = 'This is a sample prompt that receives $input and $sel(ection), among others.',
          input_label = '> ',
          model = 'llama3',
          action = 'display',
        },
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    optional = true,

    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          local status = require('ollama').status()

          if status == 'IDLE' then
            return '󱙺'
          elseif status == 'WORKING' then
            return '󰚩?!'
          end
        end,
        cond = function()
          return package.loaded['ollama'] and require('ollama').status() ~= nil
        end,
      })
    end,
  },
}
