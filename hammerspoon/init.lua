-- Config reload
hs.hotkey.bind({ 'cmd', 'alt', 'ctrl' }, 'R', function()
  hs.reload()
end)
hs.alert.show('Hammerspoon re-loaded')

-- Load & initialize Ki spoon
hs.loadSpoon('Ki')

-- Set state events to enable transitions for scroll mode.
-- Expose `enterScrollMode` in the FSM to allow transition from normal mode to scroll mode,
-- and `exitMode` to exit from scroll mode back to desktop mode.
spoon.Ki.stateEvents = {
  { name = 'enterScrollMode', from = 'normal', to = 'scroll' },
  { name = 'exitMode', from = 'scroll', to = 'desktop' },
}

-- Set custom scroll mode transition events.
spoon.Ki.transitionEvents = {
  -- Add normal mode transition event to enter scroll mode with cmd+ctrl+s from normal mode
  normal = {
    {
      { 'cmd', 'alt', 'ctrl' },
      's',
      function()
        spoon.Ki.state:enterScrollMode()
      end,
      { 'Normal Mode', 'Transition to Scroll Mode' },
    },
  },
  -- Add scroll mode transition event to exit scroll mode with escape back to desktop mode.
  scroll = {
    {
      nil,
      'escape',
      function()
        spoon.Ki.state:exitMode()
      end,
      { 'Scroll Mode', 'Exit to Desktop Mode' },
    },
  },
}

-- Scroll event handler helper method
local function createScrollEvent(offsets)
  return function()
    hs.eventtap.event.newScrollEvent(offsets, {}, 'pixel'):post()
  end
end

-- Define custom scroll mode shortcuts
local scrollEvents = {
  { nil, 'h', createScrollEvent({ 50, 0 }), { 'Scroll Events', 'Scroll Left' } },
  { nil, 'k', createScrollEvent({ 0, 50 }), { 'Scroll Events', 'Scroll Up' } },
  { nil, 'j', createScrollEvent({ 0, -50 }), { 'Scroll Events', 'Scroll Down' } },
  { nil, 'l', createScrollEvent({ -50, 0 }), { 'Scroll Events', 'Scroll Right' } },
  { { 'ctrl' }, 'd', createScrollEvent({ 0, -500 }), { 'Scroll Events', 'Scroll Half Page Down' } },
  { { 'ctrl' }, 'u', createScrollEvent({ 0, 500 }), { 'Scroll Events', 'Scroll Half Page Up' } },
}

-- Set custom workflows
spoon.Ki.workflowEvents = {
  scroll = scrollEvents,
}

-- Start Ki Spoon
spoon.Ki:start()

--------------------------------
-- START VIM CONFIG
--------------------------------
local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()

-- Configure apps you do *not* want Vim mode enabled in
vim
  :disableForApp('Code')
  :disableForApp('zoom.us')
  :disableForApp('iTerm')
  :disableForApp('iTerm2')
  :disableForApp('Terminal')
  :disableForApp('WezTerm')

-- If you want the screen to dim (a la Flux) when you enter normal mode
-- flip this to true.
vim:shouldDimScreenInNormalMode(false)

-- If you want to show an on-screen alert when you enter normal mode, set
-- this to true
vim:shouldShowAlertInNormalMode(true)

-- You can configure your on-screen alert font
vim:setAlertFont('Courier New')

-- Enter normal mode by typing a key sequence
vim:enterWithSequence('jk')

--------------------------------
-- END VIM CONFIG
--------------------------------
