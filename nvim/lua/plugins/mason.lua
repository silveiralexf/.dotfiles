return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ansible-language-server",
        "bzl",
        "clangd",
        "cmakelang",
        "cmakelint",
        "codespell",
        "delve",
        "flake8",
        "gofumpt",
        "goimports",
        "hadolint",
        "markdownlint-cli2",
        "npm-groovy-lint",
        "prettier",
        "prettierd",
        "shellcheck",
        "shfmt",
        "stylua",
        "tflint",
        "terraform-ls",
        "tree-sitter-cli",
        "zls",
      })
    end,
  },
}
