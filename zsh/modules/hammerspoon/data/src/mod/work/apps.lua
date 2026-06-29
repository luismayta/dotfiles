local hotkey = require("core.hotkey")
local log = require("hs.logger").new("Apps")

return function(config)
  if not config then return end

  hotkey.setApps(config.apps.apps or {})
  hotkey.setDevs(config.apps.devs or {})
  hotkey.setMiscs(config.apps.misc or {})

  hotkey.bindWithCtrlAlt("`", "Open Home", function()
    os.execute("open ~")
  end)

  log.df("Apps and keys loaded for work profile")
end