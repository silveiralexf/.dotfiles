local backdrops = require('extensions.backdrops')
local platform = require('extensions.platform')()
local wezterm = require('wezterm')
local act = wezterm.action

local mod = {}
local keyboard = {}
if platform.is_mac then
  mod.NONE = 'NONE'
  mod.CMD = 'SUPER'
  mod.CMD_REV = 'SUPER|SHIFT'
  mod.CTRL = 'CTRL'
  mod.CTRL_REV = 'CTRL|SHIFT'
  mod.LEADER = 'ALT'
  keyboard.COMPOSED_KEYS = true -- when curly brackets are opt + shift + 8/9, not ctrl
else
  mod.NONE = 'NONE'
  mod.CMD = 'ALT' -- to avoid conflicting with other key shortcuts
  mod.CMD_REV = 'ALT|SHIFT'
  mod.CTRL = 'CTRL'
  mod.CTRL_REV = 'CTRL|SHIFT'
  mod.LEADER = 'ALT|CTRL'
  keyboard.COMPOSED_KEYS = false
end

local keys = {
  -- misc/useful --
  {
    key = 'F1',
    mods = mod.CTRL,
    action = act.ActivateCommandPalette,
  },
  {
    key = 'F2',
    mods = mod.CTRL,
    action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS|WORKSPACES' }),
  },
  {
    key = 'F3',
    mods = mod.CTRL,
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = 'F4',
    mods = mod.CTRL,
    action = act.ShowLauncher,
  },
  {
    key = 'F5',
    mods = mod.CTRL,
    action = 'ActivateCopyMode',
  },
  {
    key = 'F11',
    mods = mod.CTRL,
    action = act.ToggleFullScreen,
  },
  {
    key = 'F12',
    mods = mod.CTRL,
    action = act.ShowDebugOverlay,
  },
  {
    key = 'f',
    mods = mod.CMD,
    action = act.Search({ CaseInSensitiveString = '' }),
  },
  {
    key = 'u',
    mods = mod.CMD,
    action = wezterm.action.QuickSelectArgs({
      label = 'open url',
      patterns = {
        '\\((https?://\\S+)\\)',
        '\\[(https?://\\S+)\\]',
        '\\{(https?://\\S+)\\}',
        '<(https?://\\S+)>',
        '\\bhttps?://\\S+[)/a-zA-Z0-9-]+',
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info('opening: ' .. url)
        wezterm.open_with(url)
      end),
    }),
  },

  -- cursor movement --
  { key = 'LeftArrow', mods = mod.CMD, action = act.SendString('\x1bOH') },
  { key = 'RightArrow', mods = mod.CMD, action = act.SendString('\x1bOF') },
  { key = 'Backspace', mods = mod.CMD, action = act.SendString('\x15') },

  -- copy/paste --
  { key = 'c', mods = mod.CMD, action = act.CopyTo('Clipboard') },
  { key = 'v', mods = mod.CMD, action = act.PasteFrom('Clipboard') },
  { key = 'k', mods = mod.CTRL, action = act.ClearScrollback('ScrollbackAndViewport') },

  -- tabs --
  -- tabs: spawn+close
  { key = 't', mods = mod.CMD, action = act.SpawnTab('DefaultDomain') },
  { key = 'w', mods = mod.CMD, action = act.CloseCurrentPane({ confirm = false }) },

  -- tabs: navigation
  { key = 'LeftArrow', mods = mod.CMD, action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = mod.CMD, action = act.ActivateTabRelative(1) },
  { key = 'LeftArrow', mods = mod.CMD_REV, action = act.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = mod.CMD_REV, action = act.MoveTabRelative(1) },

  -- tabs: renaming
  { -- TODO: still needs work: formatting, detection, hovering, etc...
    key = 'r',
    mods = mod.CMD,
    action = act.PromptInputLine({
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },

  -- window --
  -- spawn windows
  { key = 'n', mods = mod.CMD, action = act.SpawnWindow },

  -- background controls --
  {
    key = [[,]],
    mods = mod.CMD,
    action = wezterm.action_callback(function(window, _)
      backdrops:cycle_back(window)
    end),
  },
  {
    key = [[.]],
    mods = mod.CMD,
    action = wezterm.action_callback(function(window, _)
      backdrops:cycle_forward(window)
    end),
  },
  {
    key = [[/]],
    mods = mod.LEADER,
    action = act.InputSelector({
      title = 'Select Background',
      choices = backdrops:choices(),
      fuzzy = true,
      fuzzy_description = 'Select Background: ',
      action = wezterm.action_callback(function(window, _, idx)
        ---@diagnostic disable-next-line: param-type-mismatch
        backdrops:set_img(window, tonumber(idx))
      end),
    }),
  },

  -- font --
  -- font: resize with single stroke
  { mods = mod.CMD, key = '+', action = act.IncreaseFontSize },
  { mods = mod.CMD, key = '-', action = act.DecreaseFontSize },
  -- font: resize interactively
  {
    key = 'f',
    mods = mod.LEADER,
    action = act.ActivateKeyTable({
      name = 'resize_font',
      one_shot = false,
      timemout_miliseconds = 10000,
    }),
  },
}

local key_tables = {
  resize_font = {
    { key = 'k', action = act.IncreaseFontSize },
    { key = 'j', action = act.DecreaseFontSize },
    { key = 'r', action = act.ResetFontSize },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
  },
}

local mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = mod.CTRL,
    action = act.OpenLinkAtMouseCursor,
  },
}

return {
  disable_default_key_bindings = true,
  leader = { key = 'a', mods = mod.LEADER },
  keys = keys,
  key_tables = key_tables,
  mouse_bindings = mouse_bindings,
  send_composed_key_when_left_alt_is_pressed = keyboard.COMPOSED_KEYS,
  send_composed_key_when_right_alt_is_pressed = keyboard.COMPOSED_KEYS,
}
