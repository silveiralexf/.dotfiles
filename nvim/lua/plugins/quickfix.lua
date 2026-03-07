--- nvim-bqf: better quickfix window
return {
  specs = {
    { src = 'https://github.com/kevinhwang91/nvim-bqf', name = 'nvim-bqf' },
  },
  config = function()
    local bqf = require('bqf')
    if type(bqf) == 'table' and bqf.setup then
      bqf.setup({
        auto_enable = true,
        magic_window = true,
        auto_resize_height = false,
        preview = {
          auto_preview = true,
          border = 'rounded',
          show_title = true,
          show_scroll_bar = true,
          delay_syntax = 50,
          win_height = 15,
          win_vheight = 15,
          winblend = 12,
          wrap = false,
          buf_label = true,
        },
        filter = {
          fzf = {
            action_for = {
              ['ctrl-t'] = 'tabedit',
              ['ctrl-v'] = 'vsplit',
              ['ctrl-x'] = 'split',
              ['ctrl-q'] = 'signtoggle',
              ['ctrl-c'] = 'closeall',
            },
            extra_opts = { '--bind', 'ctrl-o:toggle-all' },
          },
        },
      })
    end
  end,
}
