-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[highlight ColorColumn guibg=#FF8C00]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "neo-tree", "Outline" },
  callback = function()
    -- require('ufo').detach()
    vim.opt_local.foldenable = false
  end,
})

-- Setup Vue/Volar without conflicting with TypeScript server
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspAttachConflicts", { clear = true }),
  desc = "Prevent tsserver and volar conflict",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local active_clients = vim.lsp.get_clients()
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil and client.name == "volar" then
      for _, c in ipairs(active_clients) do
        if c.name == "tsserver" then
          c.stop()
        end
      end
    end
  end,
})
