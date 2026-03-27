--- LazyDev + blink.cmp (Lua completions, wezterm types). LuaSnip lives in luasnip.lua.
return {
  specs = {
    { src = 'https://github.com/folke/lazydev.nvim', name = 'lazydev.nvim' },
    { src = 'https://github.com/justinsgithub/wezterm-types', name = 'wezterm-types' },
    { src = 'https://github.com/moyiz/blink-emoji.nvim', name = 'blink-emoji.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', name = 'blink.cmp' },
    { src = 'https://github.com/rafamadriz/friendly-snippets', name = 'friendly-snippets' },
  },
  config = function()
    local lazydev_ok, lazydev = pcall(require, 'lazydev')
    if lazydev_ok and type(lazydev) == 'table' and lazydev.setup then
      lazydev.setup({
        library = { { path = 'wezterm-types', mods = { 'wezterm' } } },
      })
    end
    local blink_ok, blink = pcall(require, 'blink.cmp')
    if blink_ok and type(blink) == 'table' and blink.setup then
      blink.setup({
        fuzzy = { implementation = 'prefer_rust' },
        sources = {
          default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'emoji' },
          providers = {
            lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
            emoji = { module = 'blink-emoji', name = 'Emoji', score_offset = -9999, opts = { insert = true } },
          },
        },
        appearance = { nerd_font_variant = 'mono' },
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
        keymap = {
          preset = 'enter', -- binds <CR> to { 'accept', 'fallback' }
        },
      })
    end
  end,
}
