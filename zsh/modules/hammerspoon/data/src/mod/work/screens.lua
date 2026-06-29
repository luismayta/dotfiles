local log = require("hs.logger").new("Screens")

local function applyProfile(profile)
  for screen, apps in pairs(profile) do
    for _, appName in ipairs(apps) do
      hs.application.launchOrFocus(appName)
      log.df("Launching %s on screen %s", appName, screen)
    end
  end
end

return function(config)
  if config.profiles and config.profiles.developer then
    applyProfile(config.profiles.developer)
  end
end