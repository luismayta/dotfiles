local hotkey = require("core.hotkey")

local M = {}

function M.registerHotkeys(config)
  if not config or not config.hotkeys then return end

  if config.hotkeys.profileSwitch then
    hotkey.bind(table.unpack(config.hotkeys.profileSwitch), function()
      hs.alert("Switched Profile (Work)")
    end)
  end
end

return M