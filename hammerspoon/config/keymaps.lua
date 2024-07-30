Keymaps = {}

-- Command mappers --
Keymaps.Cmd = { 'cmd' }
Keymaps.CmdShift = { 'cmd', 'shift' }
Keymaps.CtrlAltCmd = { 'ctrl', 'alt', 'cmd' }

-- Commands --
hs.hotkey.bind(Keymaps.CtrlAltCmd, 'R', function()
  hs.reload()
end)
hs.alert.show('🔨 Hammerspoon reload')

-- Leader Commands
Keymaps.Leader = hs.hotkey.modal.new('alt', 'o')

function Keymaps.Leader:entered()
  if hs.eventtap.isSecureInputEnabled() then
    hs.alert('⚠️ Secure Input is on. Hyper Mode commands might not work.')
  end
  print('triggered leader mode')
end

function Keymaps.Leader:exited()
  print('exited from leader mode')
end
Keymaps.Leader:bind('', 'escape', function()
  Keymaps.Leader:exit()
end)

Keymaps.Leader:bind('alt', 'J', '🔗 google-chrome', ChromeWithProfile)
Keymaps.Leader:bind('alt', 'K', '🔑 password-store', ChoosePassword)

return Keymaps
