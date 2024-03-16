return { -- add any tools you want to have installed below
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "stylua",
      "shellcheck",
      "shfmt",
      "flake8",
      "hadolint",
    })
  end,
}
