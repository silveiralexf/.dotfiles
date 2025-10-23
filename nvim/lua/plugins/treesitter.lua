return {
  {
    'windwp/nvim-ts-autotag',
    event = 'LazyFile',
    opts = {},
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {
      move = {
        enable = true,
        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    version = false, -- last release is way too old and doesn't work on Windows
    build = function()
      local TS = require('nvim-treesitter')
      if not TS.get_installed then
        LazyVim.error('Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.')
        return
      end
      -- make sure we're using the latest treesitter util
      package.loaded['lazyvim.util.treesitter'] = nil
      LazyVim.treesitter.build(function()
        TS.update(nil, { summary = true })
      end)
    end,
    lazy = false,
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    ---@alias lazyvim.TSFeat { enable?: boolean, disable?: string[] }
    ---@class lazyvim.TSConfig: TSConfig
    opts = {
      auto_install = true,
      -- LazyVim config for treesitter
      indent = { enable = true }, ---@type lazyvim.TSFeat
      highlight = { enable = true }, ---@type lazyvim.TSFeat
      folds = { enable = true }, ---@type lazyvim.TSFeat
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cue',
        'diff',
        'go',
        'gomod',
        'gosum',
        'gotmpl',
        'gowork',
        'groovy',
        'hcl',
        'html',
        'html_tags',
        'htmldjango',
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
        'printf',
        'python',
        'query',
        'regex',
        'rust',
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
    ---@param opts lazyvim.TSConfig
    config = function(_, opts)
      local TS = require('nvim-treesitter')

      setmetatable(require('nvim-treesitter.install'), {
        __newindex = function(_, k)
          if k == 'compilers' then
            vim.schedule(function()
              LazyVim.error({
                'Setting custom compilers for `nvim-treesitter` is no longer supported.',
                '',
                'For more info, see:',
                '- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)',
              })
            end)
          end
        end,
      })

      -- some quick sanity checks
      if not TS.get_installed then
        return LazyVim.error('Please use `:Lazy` and update `nvim-treesitter`')
      elseif type(opts.ensure_installed) ~= 'table' then
        return LazyVim.error('`nvim-treesitter` opts.ensure_installed must be a table')
      end

      -- setup treesitter
      TS.setup(opts)
      LazyVim.treesitter.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not LazyVim.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        LazyVim.treesitter.build(function()
          TS.install(install, { summary = true }):await(function()
            LazyVim.treesitter.get_installed(true) -- refresh the installed langs
          end)
        end)
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lazyvim_treesitter', { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not LazyVim.treesitter.have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {} ---@type lazyvim.TSFeat
            return f.enable ~= false
              and not (type(f.disable) == 'table' and vim.tbl_contains(f.disable, lang))
              and LazyVim.treesitter.have(ft, query)
          end

          -- highlighting
          if enabled('highlight', 'highlights') then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled('indent', 'indents') then
            LazyVim.set_default('indentexpr', 'v:lua.LazyVim.treesitter.indentexpr()')
          end

          -- folds
          if enabled('folds', 'folds') then
            if LazyVim.set_default('foldmethod', 'expr') then
              LazyVim.set_default('foldexpr', 'v:lua.LazyVim.treesitter.foldexpr()')
            end
          end
        end,
      })
    end,
  },
}
