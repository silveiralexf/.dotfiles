--- LuaSnip: snippets (LSP completion).
--- Optional: for Variable/Placeholder LSP snippet transformations, install jsregexp:
---   luarocks install jsregexp   (or: task nvim:deps)
--- See :help luasnip-lsp-snippets-transformations
return {
  specs = {
    { src = 'https://github.com/L3MON4D3/LuaSnip', name = 'LuaSnip' },
  },
  config = function()
    -- Preload jsregexp if installed (clears LuaSnip health warning for LSP snippet transformations)
    pcall(require, 'jsregexp')
    local luasnip = require('luasnip')
    if type(luasnip) == 'table' and luasnip.setup then
      luasnip.setup({})
      local loader_ok, loader = pcall(require, 'luasnip.loaders.from_vscode')
      if loader_ok and type(loader) == 'table' and loader.lazy_load then
        loader.lazy_load()
      end
    end
  end,
}
