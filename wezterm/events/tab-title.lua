local wezterm = require('wezterm')

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local nf = wezterm.nerdfonts

local ICON_SEMI_CIRCLE_LEFT = nf.ple_left_half_circle_thick --[[ '' ]]
local ICON_SEMI_CIRCLE_RIGHT = nf.ple_right_half_circle_thick --[[ '' ]]
local ICON_CIRCLE = nf.fa_circle --[[ '' ]]
local ICON_ADMIN = nf.md_shield_half_full --[[ '󰞀' ]]

local M = {}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

-- stylua: ignore
local colors = {
   default   = { bg = '#45475a', fg = '#1c1b19' },
   is_active = { bg = '#7FB4CA', fg = '#11111b' },
   hover     = { bg = '#587d8c', fg = '#1c1b19' },
}

-- TODO: Needs work, pane titles are still clunky
local _set_process_name = function(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

local _set_tab_idx = function(tabs, tab)
  local tab_idx = 1

  for i, t in ipairs(tabs) do
    if t.tab_id == tab.tab_id then
      tab_idx = i
      break
    end
  end

  return tab_idx
end

local _set_title = function(process_name, base_title, max_width, inset)
  local title
  inset = inset or 6

  if process_name:len() == 0 then
    title = '❓' .. process_name
  elseif process_name:len() < 4 or process_name == 'zsh' or process_name == 'bash' then
    title = '⚠️ ~ ' .. process_name
  else
    title = base_title
  end

  if title:len() > max_width - inset then
    local diff = title:len() - max_width + inset
    title = wezterm.truncate_right(title, title:len() - diff)
  end

  return title
end

-- TODO: Needs further work
local _check_if_admin = function(p)
  if p:match('^Administrator: ') then
    return true
  end
  return false
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
local _push = function(bg, fg, attribute, text)
  table.insert(__cells__, { Background = { Color = bg } })
  table.insert(__cells__, { Foreground = { Color = fg } })
  table.insert(__cells__, { Attribute = attribute })
  table.insert(__cells__, { Text = text })
end

M.setup = function()
  wezterm.on('format-tab-title', function(tab, tabs, _, _, hover, max_width)
    __cells__ = {}

    local bg
    local fg
    local process_name = _set_process_name(tab.active_pane.foreground_process_name)
    local is_admin = _check_if_admin(tab.active_pane.title)
    local title = _set_title(process_name, tab.active_pane.title, max_width, (is_admin and 8))

    local tab_idx = _set_tab_idx(tabs, tab)

    if tab.is_active then
      bg = colors.is_active.bg
      fg = colors.is_active.fg
      title = tab_idx .. '   ' .. title
    elseif hover then
      bg = colors.hover.bg
      fg = colors.hover.fg
      title = tab_idx .. '   ' .. title
    else
      bg = colors.default.bg
      fg = colors.default.fg
      title = tab_idx .. '   ' .. title
    end

    local has_unseen_output = false
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end

    -- Left semi-circle
    _push('rgba(0, 0, 0, 0.4)', bg, { Intensity = 'Bold' }, ICON_SEMI_CIRCLE_LEFT)

    --
    -- Admin Icon
    if is_admin then
      _push(bg, fg, { Intensity = 'Bold' }, ' ' .. ICON_ADMIN)
    end

    -- Title
    _push(bg, fg, { Intensity = 'Bold' }, ' ' .. title)

    -- Unseen output alert
    if has_unseen_output then
      _push(bg, '#FFA066', { Intensity = 'Bold' }, ' ' .. ICON_CIRCLE)
    end

    -- Right padding
    _push(bg, fg, { Intensity = 'Bold' }, ' ')

    -- Right semi-circle
    _push('rgba(0, 0, 0, 0.4)', bg, { Intensity = 'Bold' }, ICON_SEMI_CIRCLE_RIGHT)

    return __cells__
  end)
end

return M
