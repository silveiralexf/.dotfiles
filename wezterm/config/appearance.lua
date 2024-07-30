local colors = require('colors.custom')
local gpu_adapters = require('utils.gpu_adapter')
local wezterm = require('wezterm')

return {
  animation_fps = 60,
  enable_kitty_graphics = true,
  front_end = 'WebGpu',
  max_fps = 60,
  webgpu_power_preference = 'HighPerformance',
  webgpu_preferred_adapter = gpu_adapters:pick_best(),
  window_decorations = 'RESIZE',

  -- color scheme
  colors = colors,

  -- background
  background = {
    {
      source = { File = wezterm.GLOBAL.background },
      horizontal_align = 'Center',
    },
    {
      source = { Color = colors.background },
      height = '100%',
      width = '100%',
      opacity = 0.96,
    },
  },

  -- scrollbar
  enable_scroll_bar = true,
  scrollback_lines = 10000,

  -- tab bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = false,
  tab_max_width = 45,
  show_tab_index_in_tab_bar = false,
  switch_to_last_active_tab_when_closing_tab = true,
  tab_bar_at_bottom = true,

  -- window
  window_padding = {
    left = 5,
    right = 10,
    top = 12,
    bottom = 7,
  },
  window_close_confirmation = 'NeverPrompt',
  window_frame = {
    active_titlebar_bg = '#090909',
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.65,
  },
}
