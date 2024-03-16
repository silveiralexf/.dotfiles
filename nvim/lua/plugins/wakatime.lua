return {
  "wakatime/vim-wakatime",
  event = "VeryLazy",
  lazy = false,
  setup = function()
    vim.cmd([[packadd wakatime/vim-wakatime]])
  end,
}
