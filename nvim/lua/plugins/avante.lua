return {
  {
    'saghen/blink.compat',
    lazy = true,
    opts = {},
    config = function()
      -- monkeypatch cmp.ConfirmBehavior for Avante
      require('cmp').ConfirmBehavior = {
        Insert = 'insert',
        Replace = 'replace',
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      provider = 'ollama',
      debug = false,
      auto_suggestions = true, -- Experimental stage
      auto_suggestions_provider = 'ollama',
      file_selector = { provider = 'snacks' },
      cursor_applying_provider = 'ollama',
      use_absolute_path = true,
      ollama = {
        model = 'qwen2.5-coder:1.5b',
        endpoint = 'http://127.0.0.1:11434',
        x_api_key = '',
        disable_tools = true,
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        enable_cursor_planning_mode = true, -- enable cursor planning mode!
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
      },
      hints = { enabled = true },
      windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = 'right', -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 30, -- default % based on available width
        sidebar_header = {
          align = 'center', -- left, center, right for title
          rounded = true,
        },
      },
      highlights = {
        ---@type AvanteConflictHighlights
        diff = {
          current = 'DiffText',
          incoming = 'DiffAdd',
        },
      },
      --- @class AvanteConflictUserConfig
      diff = {
        autojump = false,
        ---@type string | fun(): any
        list_opener = 'copen',
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'folke/snacks.nvim', -- for use with snacks picker
      {
        'stevearc/dressing.nvim',
        lazy = true,
        opts = {
          input = { enabled = false },
          select = { enabled = false },
        },
      },
      {
        'saghen/blink.compat',
        lazy = true,
        opts = {},
        config = function()
          -- monkeypatch cmp.ConfirmBehavior for Avante
          require('cmp').ConfirmBehavior = {
            Insert = 'insert',
            Replace = 'replace',
          }
        end,
      },
      {
        'saghen/blink.cmp',
        lazy = true,
        opts = {
          sources = {
            default = { 'avante_commands', 'avante_mentions', 'avante_files' },
            providers = {
              avante_commands = {
                name = 'avante_commands',
                module = 'blink.compat.source',
                score_offset = 90, -- show at a higher priority than lsp
                opts = {},
              },
              avante_files = {
                name = 'avante_commands',
                module = 'blink.compat.source',
                score_offset = 100, -- show at a higher priority than lsp
                opts = {},
              },
              avante_mentions = {
                name = 'avante_mentions',
                module = 'blink.compat.source',
                score_offset = 1000, -- show at a higher priority than lsp
                opts = {},
              },
            },
          },
        },
      },
    },
  },
}
