return {
  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'LazyFile', 'VeryLazy', 'BufReadPost', 'BufNewFile' },
    lazy = vim.fn.argc(-1) == 0,
    init = function(plugin)
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      auto_install = true,
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
      },
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cue',
        'diff',
        'go',
        'gotmpl',
        'gowork',
        'groovy',
        'hcl',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'make',
        'markdown',
        'markdown_inline',
        'norg_meta',
        'printf',
        'python',
        'query',
        'regex',
        'rust',
        'svelte',
        'templ',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      },
    },
    ---@type TSConfig
    ---@class TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end

      -- For detecting go template files
      -- NOTE: this requires prettier-plugin-go-template
      -- e.g: npm install --save-dev prettier prettier-plugin-go-template
      local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
      parser_configs['gotmpl'] = {
        install_info = {
          url = 'https://github.com/ngalaiko/tree-sitter-go-template',
          files = { 'src/parser.c' },
        },
        filetype = {
          'gotmpl',
          'gohtmltmpl',
          'gohtml',
        },
        used_by = { 'gohtmltmpl', 'gotexttmpl', 'gotmpl', 'gotxttmpl', 'gohtml' },
      }

      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      }
    end,
  },
  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
      vim.g.matchup_matchpref = { html = { nolists = 1 } }
    end,
  },
}
