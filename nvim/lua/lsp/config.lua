return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "dockerfile",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "hcl",
        "helm",
        "html",
        "java",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "terraform",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
      })
    end,
    vim.filetype.add({
      extension = { rasi = "rasi" },
      pattern = {
        [".*/waybar/config"] = "jsonc",
        [".*/mako/config"] = "dosini",
        [".*/kitty/*.conf"] = "bash",
        [".*/hypr/.*%.conf"] = "hyprlang",
      },
    }),
  },
}
