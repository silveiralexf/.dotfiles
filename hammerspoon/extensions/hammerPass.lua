local HammerPass = {}
HammerPass.__index = HammerPass

-- Metadata
HammerPass.name = 'HammerPass'
HammerPass.version = '1.1'
HammerPass.author = 'Felipe Silveira'
HammerPass.homepage = 'https://github.com/silveiralexf/.dotfiles/blob/master/hammerspoon/extensions/HammerPass.lua'
HammerPass.license = 'https://github.com/silveiralexf/.dotfiles/blob/master/LICENSE'

-- default password store directory
HammerPass.StoreBaseDir = '~/.password-store'

function StrEndsWith(str, ending)
  if str:len() < ending:len() then
    return false
  else
    return str:sub(str:len() - ending:len() + 1, str:len()) == ending
  end
end

function ListPasswordFiles(dir, files)
  Ending = '.gpg'
  local iter_fn, dir_obj = hs.fs.dir(dir)
  while true do
    local file = iter_fn(dir_obj)
    if file == nil then
      break
    end
    if file:sub(1, 1) ~= '.' then
      if hs.fs.attributes(dir .. '/' .. file)['mode'] == 'directory' then
        ListPasswordFiles(dir .. '/' .. file, files)
      else
        if StrEndsWith(file, Ending) then
          table.insert(files, { file:sub(1, file:len() - Ending:len()), dir })
        end
      end
    end
  end
  return files
end

function CopyPassword(r)
  if r ~= nil then
    Output, Status, type, Rc = hs.execute('pass ' .. r['text'] .. '/' .. r['subText'], true)
    if Status then
      CleanOutput = string.gsub(Output, '\n', '')
      hs.pasteboard.setContents(CleanOutput)
    end
  end
end

function ChoosePassword()
  local c = hs.chooser.new(CopyPassword)
  local files = {}
  ListPasswordFiles(HammerPass.StoreBaseDir, files)
  local choices = {}
  for _, entry in ipairs(files) do
    local file, dir = entry[1], entry[2]
    local dir_name = dir:sub(HammerPass.StoreBaseDir:len() + 2, dir:len())
    table.insert(choices, { ['text'] = dir_name, ['subText'] = file, ['uuid'] = file })
  end
  c:choices(choices)
  c:show()
end

return HammerPass
