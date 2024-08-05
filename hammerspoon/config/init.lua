---@class HammerSpoonLoader
---@field options table
local HammerSpoonLoader = {}
HammerSpoonLoader.__index = HammerSpoonLoader

---Initialize HammerSpoonConfigs
---@return HammerSpoonLoader
function HammerSpoonLoader:init()
  local config = setmetatable({ options = {} }, self)
  return config
end

---Append to `HammerSpoonLoader.options`
---@param new_options table new options to append
---@return HammerSpoonLoader
function HammerSpoonLoader:append(new_options)
  for k, v in pairs(new_options) do
    if self.options[k] ~= nil then
      hs.alert.show('[HammerSpoon] Duplicate config option detected: ', { old = self.options[k], new = new_options[k] })
      goto continue
    end
    self.options[k] = v
    ::continue::
  end
  return self
end
return HammerSpoonLoader
