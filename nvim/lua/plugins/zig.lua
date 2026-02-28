--- Zig: zig.vim + zig-tools (zls via LSP; zig formatter in conform.lua)
return {
  specs = {
    { src = 'https://github.com/ziglang/zig.vim', name = 'zig.vim' },
    { src = 'https://github.com/NTBBloodbath/zig-tools.nvim', name = 'zig-tools.nvim' },
    { src = 'https://github.com/akinsho/toggleterm.nvim', name = 'toggleterm.nvim' },
  },
  config = function()
    local zig_tools = require('zig-tools')
    if type(zig_tools) == 'table' and zig_tools.setup then
      zig_tools.setup({})
    end
  end,
}
