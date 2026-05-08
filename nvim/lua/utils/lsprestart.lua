-- LspRestart is a plugin that allows you to easily restart the language server protocol (LSP) in Neovim. It provides a
-- simple command to restart the LSP, which can be useful when you encounter issues with the language server or want to
-- refresh its state.
local function LspRestart()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  -- @type vim.lsp.Client[]
  if #clients == 0 then
    vim.api.nvim_echo({ { 'No LSP servers attached to the current buffer.', 'WarningMsg' } }, false, {})
    return
  end
  for _, client in ipairs(clients) do
    client:stop()
    client:initialize() -- @type vim.lsp.Client
  end
  vim.api.nvim_echo({ { 'LSP servers restarted.', 'InfoMsg' } }, false, {})
end

vim.api.nvim_create_user_command('LspRestart', LspRestart, {})
