--- Dressing: better input/select UI. Customizations from original Lazy spec.
return {
  specs = {
    { src = 'https://github.com/stevearc/dressing.nvim', name = 'dressing.nvim' },
  },
  config = function()
    local dressing = require('dressing')
    if type(dressing) ~= 'table' or not dressing.setup then
      return
    end
    dressing.setup({
      input = {
        enabled = true,
        default_prompt = 'Input',
        trim_prompt = true,
        title_pos = 'left',
        insert_only = true,
        start_in_insert = true,
        border = 'rounded',
        relative = 'cursor',
        prefer_width = 40,
      },
      select = {
        enabled = true,
        backend = { 'fzf_lua', 'fzf', 'builtin', 'nui' },
        trim_prompt = true,
        fzf = { window = { width = 0.8, height = 0.7 } },
        fzf_lua = { winopts = { height = 0.5, width = 0.5 } },
        nui = {
          position = '50%',
          relative = 'editor',
          border = { style = 'rounded' },
          max_width = 160,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },
        builtin = { border = 'rounded', relative = 'editor' },
      },
    })
  end,
}
