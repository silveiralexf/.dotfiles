-- Code formatting settings
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      inlay_hints = { enabled = false },
      formatters_by_ft = {
        bash = { 'prettierd' },
        css = { { 'prettierd', 'prettier' } },
        erb = { 'prettierd' },
        go = { 'goimports', 'gofumpt' },
        graphql = { { 'prettierd', 'prettier' } },
        groovy = { 'npm_groovy_lint' },
        hcl = { 'terraform_fmt' },
        html = { 'prettierd' },
        java = { 'prettierd' },
        javascript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        lua = { 'stylua' },
        --markdown = { 'markdownlint-cli2' },
        markdown = { 'prettierd' },
        proto = { 'buf' },
        python = { 'ruff_format' },
        rust = { 'rustfmt' },
        scss = { { 'prettierd', 'prettier' } },
        sh = { 'shfmt' },
        svelte = { { 'prettierd', 'prettier' } },
        terraform = { 'terraform_fmt' },
        tf = { 'terraform_fmt' },
        toml = { 'taplo' },
        typescript = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        yaml = { 'yamlfmt' },
        zsh = { 'shfmt' },
        ['*.md'] = { 'codespell' },
        ['_'] = { 'trim_whitespace' },
        ['terraform-vars'] = { 'terraform_fmt' },
      },
      formatters = {
        markdown = { 'prettierd' },
        npm_groovy_lint = {
          command = 'npm-groovy-lint',
          args = { '--failon', 'error', '--format', '$FILENAME' },
          cwd = require('conform.util').root_file({ '.git' }),
          stdin = false,
        },
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    lazy = true,
    keys = { { 'gm', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview' } },
    config = function()
      vim.g.mkdp_auto_close = true
      vim.g.mkdp_open_to_the_world = false
      vim.g.mkdp_open_ip = '127.0.0.1'
      vim.g.mkdp_port = '8888'
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = true
      vim.g.mkdp_page_title = '${name}'
    end,
  },
}
