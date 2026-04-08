WaterfoxaterforxWithProfile = function()
  local profile = 'Default'
  local url = 'https://search.silveiras.cloud'
  local t = hs.task.new('/Applications/Waterfox.app/Contents/MacOS/waterfox', nil, function()
    return false
  end, { '--kiosk', '--profile-directory=' .. profile, url })
  t:start()
end
