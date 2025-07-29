return {
  {
    'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {
      { 'gonstoll/wezterm-types', lazy = true },
    },
    opts = {
      library = {
        { path = 'wezterm-types', mods = { 'wezterm' } },
      },
    },
  },
  { 'moyiz/blink-emoji.nvim' },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = {
          'lazydev',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'emoji',
        },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = -9999, -- Tune by preference
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
        },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { 'kind_icon', 'label', 'label_description', gap = 1 },
              { 'kind', gap = 1 },
              { 'source_name' },
            },
          },
        },
      },
    },
  },
}
