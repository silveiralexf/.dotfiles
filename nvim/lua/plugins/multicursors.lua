return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    "smoka7/hydra.nvim",
  },
  lazy = false,
  opts = { desc = "Clear others" },
  cmd = { "MCstart", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    {
      mode = { "v", "n" },
      "<Leader>m",
      "<cmd>MCstart<cr>",
      desc = "Create a selection for selected text or word under the cursor",
    },
  },
  setup = function()
    vim.cmd([[packadd smoka7/multicursors]])
    require("multicursors").setup({
      hint_config = {
        border = "rounded",
        position = "bottom-right",
      },
      generate_hints = {
        normal = true,
        insert = true,
        extend = true,
        config = {
          column_count = 1,
          max_hint_length = 10,
        },
      },
    })
  end,
}
