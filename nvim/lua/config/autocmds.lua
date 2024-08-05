-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.cmd([[highlight ColorColumn guibg=#FF8C00]])

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'neo-tree', 'Outline' },
  callback = function()
    -- require('ufo').detach()
    vim.opt_local.foldenable = false
  end,
})

-- Always attach LSP when available
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method('textDocument/implementation') then
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
        buffer = 0,
        desc = 'Go to definition',
      })
      if client and client.supports_method('textDocument/completion') then
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
      end
      if client and client.supports_method('textDocument/definition') then
        vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
      end
    end
  end,
})

-- Handler for Terraform
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.tf', '*.hcl', '*.tfvars' },
  group = vim.api.nvim_create_augroup('FixTerraformCommentString', { clear = true }),
  callback = function(args)
    vim.opt_local.filetype = 'terraform'
    vim.lsp.start_client({
      name = 'terraformls',
      cmd = { 'terraform-ls', 'serve' },
      root_dir = vim.fs.dirname(vim.fs.find({ '*.hcl', '*.tf', '*.tfvars' }, { upward = true })[1]),
    })
    vim.lsp.buf.formatting_sync()
    vim.bo[args.buf].commentstring = '# %s'
  end,
})

-- Create an event handler for Tiltfiles
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'bzl',
  callback = function(ev)
    vim.lsp.start({
      name = 'bzl',
      root_dir = vim.fs.root(ev.buf, { 'Tiltfile', 'bzl' }),
      codelens = { enable = true },
      cmd = { 'tilt', 'lsp', 'start' },
      docs = {
        description = [[
https://docs.stack.build/docs/cli/installation

https://docs.stack.build/docs/vscode/starlark-language-server
]],
      },
    })
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.gohtml', '*.go.html' },
  callback = function()
    vim.opt_local.filetype = 'gohtmltmpl'
  end,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.gotmpl', '*.go.tmpl', '*.tmpl' },
  callback = function()
    vim.opt_local.filetype = 'gotexttmpl'
  end,
})

-- Go auto organize imports
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
})

-- Setup Vue/Volar without conflicting with TypeScript server
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LspAttachConflicts', { clear = true }),
  desc = 'Prevent tsserver and volar conflict',
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local active_clients = vim.lsp.get_clients()
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil and client.name == 'volar' then
      for _, c in ipairs(active_clients) do
        if c.name == 'tsserver' then
          c.stop()
        end
      end
    end
  end,
})

-- Markdown preview with Glow
local function render_markdown_with_glow()
  local tempfile = vim.fn.tempname() .. '.md'
  vim.cmd('write! ' .. tempfile)

  vim.cmd('enew')
  local bufnr = vim.api.nvim_get_current_buf()

  local command = 'terminal glow -p ' .. tempfile

  vim.cmd(command)

  vim.cmd('startinsert!')

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    callback = function()
      ---@diagnostic disable-next-line: undefined-field
      vim.loop.fs_unlink(tempfile)
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', '<leader>ug', render_markdown_with_glow, {
      silent = true,
      buffer = true,
      desc = 'render markdown with glow',
    })
  end,
})

-- Wrap and check for spell in text file types.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('wrap_spell', { clear = true }),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Go to last loc when opening a buffer.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      -- Protected call to catch errors.
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
