local wezterm = require('wezterm')

---@class WezTermLoader
---@field options table
local WezTermLoader = {}
WezTermLoader.__index = WezTermLoader

---Initialize Config
---@return WezTermLoader
function WezTermLoader:init()
  local config = setmetatable({ options = {} }, self)
  return config
end

---Append to `Config.options`
---@param new_options table new options to append
---@return WezTermLoader
function WezTermLoader:append(new_options)
  for k, v in pairs(new_options) do
    if self.options[k] ~= nil then
      wezterm.log_warn('[WezTerm] Duplicate config option detected: ',k, { old = self.options[k], new = new_options[k] })
      goto continue
    end
    self.options[k] = v
    ::continue::
  end
  return self
end
return WezTermLoader
