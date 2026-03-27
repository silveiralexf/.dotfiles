--- Snacks.nvim: required by opencode.nvim (terminal). Only terminal and notifier are enabled.
--- vim.g.snacks_animate = false is set in options.lua.
return {
  specs = {},
  config = function()
    local ok, snacks = pcall(require, 'snacks')
    if not ok or type(snacks) ~= 'table' or not snacks.setup then
      return
    end
    snacks.setup({
      terminal = { enabled = true },
      notifier = { enabled = true },
    })
  end,
}
