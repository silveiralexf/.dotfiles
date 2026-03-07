--- LuaRocks.nvim: install Lua rocks (e.g. jsregexp for LuaSnip, fzy).
--- Run build once after install: nvim -l <plugin_dir>/build.lua  (or: task nvim:luarocks-build)
--- Rocks are installed into the plugin's .rocks tree; setup() adds them to package.path.
return {
  specs = {
    { src = 'https://github.com/vhyrro/luarocks.nvim', name = 'luarocks.nvim' },
  },
  config = function()
    local ok, luarocks = pcall(require, 'luarocks-nvim')
    if not ok or type(luarocks) ~= 'table' or not luarocks.setup then
      return
    end
    luarocks.setup({
      rocks = { 'fzy', 'jsregexp' },
    })
  end,
}
