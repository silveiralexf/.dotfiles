Keymaps = {}

-- Command mappers --
Keymaps.CMD = { 'cmd' }
Keymaps.CMD_REV = { 'cmd', 'shift' }
Keymaps.LEADER_2 = { 'ctrl', 'alt', 'cmd' }

-- Commands --
hs.hotkey.bind(Keymaps.LEADER_2, 'R', function()
  hs.reload()
end)
hs.alert.show('🔨 Hammerspoon reload')

-- Leader Commands
Keymaps.LEADER = hs.hotkey.modal.new('alt', 'o')

function Keymaps.LEADER:entered()
  if hs.eventtap.isSecureInputEnabled() then
    hs.alert('⚠️ Secure Input is on. Hyper Mode commands might not work.')
  end
  print('triggered leader mode')
end

function Keymaps.LEADER:exited()
  print('exited from leader mode')
end
Keymaps.LEADER:bind('', 'escape', function()
  Keymaps.LEADER:exit()
end)

Keymaps.LEADER:bind('alt', 'J', '🔗 google-chrome', ChromeWithProfile)
Keymaps.LEADER:bind('alt', 'K', '🔑 password-store', ChoosePassword)

return Keymaps
