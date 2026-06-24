local wezterm = require('wezterm')

---@class Config
---@field options table
local Config = {}
Config.__index = Config

---Initialize Config
---@return Config
function Config:init()
   local config = setmetatable({ options = {} }, self)
   return config
end

---Append to `Config.options`
---@param new_options table new options to append
---@return Config
function Config:append(new_options)
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         wezterm.log_error(
            'Duplicate config option detected: ' .. tostring(k),
            { old = self.options[k], new = new_options[k] }
         )
      else
         self.options[k] = v
      end
   end
   return self
end

return Config
