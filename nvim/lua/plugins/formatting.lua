-- Code formatting settings
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function(_, opts)
      opts.inlay_hints = { enabled = false }

      if LazyVim.has_extra('formatting.prettier') then
        opts.formatters = {
          markdown = { 'prettierd' },
          npm_groovy_lint = {
            command = 'npm-groovy-lint',
            args = { '--failon', 'error', '--format', '$FILENAME' },
            cwd = require('conform.util').root_file({ '.git' }),
            stdin = false,
          },
          javascript = { 'prettierd', 'prettier' },
          -- svelte = { 'prettier' },
          yamlfmt = {
            prepend_args = {
              '-formatter',
              'include_document_start=false,trim_trailing_whitespace=true,retain_line_breaks=true,scan_folded_as_literal=true',
            },
          },
        }
        opts.formatters_by_ft = opts.formatters_by_ft or {}
        opts.formatters_by_ft = {
          bash = { 'prettierd' },
          css = { 'prettierd' },
          cue = { 'cue_fmt' },
          dagger = { 'cue_fmt' },
          erb = { 'prettierd' },
          go = { 'goimports', 'gofumpt' },
          graphql = { 'prettierd' },
          groovy = { 'npm_groovy_lint' },
          hcl = { 'terraform_fmt' },
          html = { 'prettierd' },
          java = { 'prettierd' },
          javascript = { 'prettierd', 'prettier' },
          javascriptreact = { 'prettierd' },
          json = { 'prettierd' },
          lua = { 'stylua' },
          markdown = { 'prettierd' },
          proto = { 'buf' },
          python = { 'ruff_format' },
          rust = { 'rustfmt' },
          scss = { 'prettierd' },
          sh = { 'shfmt' },
          -- svelte = { 'prettier' },
          terraform = { 'terraform_fmt' },
          tf = { 'terraform_fmt' },
          toml = { 'taplo' },
          typescript = { 'prettierd' },
          typescriptreact = { 'prettierd' },
          yaml = { 'yamlfmt' },
          zsh = { 'shfmt' },
          ['*.md'] = { 'codespell' },
          ['_'] = { 'trim_whitespace' },
          ['terraform-vars'] = { 'terraform_fmt' },
        }
      end
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    -- build = 'cd app && npm install',
    enabled = true,
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
