ChromeWithProfile = function()
  local profile = 'Default'
  local url = 'https://meet.google.com'
  local t = hs.task.new('/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', nil, function()
    return false
  end, { '--kiosk', '--profile-directory=' .. profile, url })
  t:start()
end
