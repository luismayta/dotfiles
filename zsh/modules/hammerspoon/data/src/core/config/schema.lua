local M = {}

local function assertType(value, expected, path)
  if type(value) ~= expected then
    error(string.format("Config validation error at '%s': expected %s, got %s", path, expected, type(value)))
  end
end

local function assertTable(value, path)
  assertType(value, "table", path)
end

local function assertBoolean(value, path)
  assertType(value, "boolean", path)
end

local function assertString(value, path)
  assertType(value, "string", path)
end

local function validateBrowsers(config)
  assertTable(config.browsers, "browsers")

  for key, value in pairs(config.browsers) do
    assertString(key, "browsers.<key>")
    assertString(value, "browsers." .. key)
  end
end

local function validateBrowserPolicy(config)
  assertTable(config.browserPolicy, "browserPolicy")

  for policyKey, browserKey in pairs(config.browserPolicy) do
    assertString(policyKey, "browserPolicy.<key>")
    assertString(browserKey, "browserPolicy." .. policyKey)

    if not config.browsers[browserKey] then
      error(
        string.format(
          "Config validation error: browserPolicy.%s references unknown browser '%s'",
          policyKey,
          browserKey
        )
      )
    end
  end
end

local function validateDisplays(config)
  if not config.displays then
    return
  end

  assertTable(config.displays, "displays")

  for key, value in pairs(config.displays) do
    assertString(key, "displays.<key>")
    assertString(value, "displays." .. key)
  end
end

local function validateHotkeys(config)
  if not config.hotkeys then
    return
  end

  assertTable(config.hotkeys, "hotkeys")

  if config.hotkeys.enabled ~= nil then
    assertBoolean(config.hotkeys.enabled, "hotkeys.enabled")
  end
end

function M.validate(config)
  assertTable(config, "root")

  validateBrowsers(config)
  validateBrowserPolicy(config)
  validateDisplays(config)
  validateHotkeys(config)

  return true
end

return M
