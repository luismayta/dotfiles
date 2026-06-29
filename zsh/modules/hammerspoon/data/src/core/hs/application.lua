local M = {}

function M.toggle(bundleId)
  local app = hs.application.get(bundleId)

  if not app or app:isHidden() then
    hs.application.launchOrFocusByBundleID(bundleId)
    return
  end

  if hs.application.frontmostApplication() ~= app then
    app:activate()
  end
end

function M.launchOrFocus(name)
  local app = hs.application.find(name)

  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  end
end

return M
