-- LsInfo shows the current status of the LSP servers attached to the current buffer. It provides information about the
-- servers, their capabilities, and any errors or warnings they may have encountered.

local function LspInfo()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if #clients == 0 then
    vim.api.nvim_echo({ { 'No LSP servers attached to the current buffer.', 'WarningMsg' } }, false, {})
    return
  end
  local lines = {}
  table.insert(lines, 'LSP Servers attached to the current buffer:')
  for _, client in ipairs(clients) do
    table.insert(lines, '- ' .. client.name)
    table.insert(lines, '  Capabilities:')
    for capability, supported in pairs(client.server_capabilities) do
      table.insert(lines, string.format('    %s: %s', capability, tostring(supported)))
    end
    local errors = rawget(client, 'errors') or {}
    if errors[1] then
      table.insert(lines, '  Errors:')
      for _, err in ipairs(errors) do
        table.insert(lines, '    ' .. err.message)
      end
    end
    local warnings = rawget(client, 'warnings') or {}
    if warnings[1] then
      table.insert(lines, '  Warnings:')
      for _, warn in ipairs(warnings) do
        table.insert(lines, '    ' .. warn.message)
      end
    end
  end
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_name(bufnr, 'LspInfo')
  vim.opt_local.buftype = 'nofile'
  vim.opt_local.swapfile = false
  vim.opt_local.bufhidden = 'wipe'
end

vim.api.nvim_create_user_command('LspInfo', LspInfo, {})
