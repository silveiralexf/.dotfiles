return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bzl",
        "clangd",
        "codespell",
        "delve",
        "flake8",
        "goimports",
        "gofumpt",
        "hadolint",
        "markdownlint-cli2",
        "npm-groovy-lint",
        "prettier",
        "prettierd",
        "shellcheck",
        "shfmt",
        "stylua",
        "tree-sitter-cli",
        "zls",
      })
    end,
  },
}
