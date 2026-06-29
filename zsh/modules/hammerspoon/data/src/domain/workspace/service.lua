local application = require("core.hs.application")
local screen = require("core.hs.screen")

local M = {}

function M.switchProfile(context, profileName)
  local profiles = context.config.workspace.profiles
  local profile = profiles[profileName]

  if not profile then
    error("WorkspaceService: profile not found -> " .. profileName)
  end

  for _, bundleId in ipairs(profile.mainScreen or {}) do
    application.open(bundleId)
    screen.moveToMain(bundleId)
  end

  for _, bundleId in ipairs(profile.secondScreen or {}) do
    application.open(bundleId)
    screen.moveToSecond(bundleId)
  end
end

function M.launchOrFocus(context, appName)
  if not appName then
    return
  end

  context.application.launchOrFocus(appName)
end

return M
