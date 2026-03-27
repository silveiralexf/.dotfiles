--- Conform: format on save.
return {
  specs = {
    { src = 'https://github.com/stevearc/conform.nvim', name = 'conform.nvim' },
  },
  config = function()
    local conform = require('conform')
    if type(conform) ~= 'table' or not conform.setup or not conform.format then
      return
    end
    conform.setup({
      formatters_by_ft = {
        bash = { 'prettierd' },
        go = { 'goimports', 'gofmt' },
        lua = { 'stylua' },
        markdown = { 'prettierd' },
        python = { 'ruff_format' },
        yaml = { 'yamlfmt' },
        zig = { 'zigfmt' },
        toml = { 'taplo' },
        sh = { 'shfmt' },
        ['_'] = { 'trim_whitespace' },
      },
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function(args)
        if vim.g.autoformat == false then return end
        if vim.b[args.buf].autoformat == false then return end
        pcall(conform.format, { bufnr = args.buf, async = false })
      end,
    })
  end,
}
