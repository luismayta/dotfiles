--[[
File:    core/config/defaults.lua
Purpose: Default configuration values for the Hammerspoon setup — browser, display,
         DNS, and module flag defaults. Lowest priority in the config hierarchy.
Author:  Hammerspoon Config Team
--]]

--[[
  Base configuration defaults — lowest priority in the config hierarchy.

  Config layers (lower number = lower priority):
    1. core/config/defaults.lua   — Base defaults (this file)
    2. config/global.lua          — Global overrides shared across machines
    3. local.lua                  — Machine-specific overrides (gitignored)
    4. custom.lua                 — User-specific overrides (generated from template)

  Each layer deep-merges into the previous one.
  To override a value: define the same key in a higher layer.
  To add a new browser: add to M.values.browsers.
--]]
local M = {}

M.values = {
  browsers = {
    brave = "com.brave.Browser",
    chrome = "com.google.Chrome",
    safari = "com.apple.Safari",
    firefox = "org.mozilla.firefox",
    firefoxDev = "org.mozilla.firefoxdeveloperedition",
    canary = "com.google.Chrome.canary",
  },
  display = {
    laptop = "Color LCD",
    external = "ASUS PB238",
  },
  dns = {
    empty = "networksetup -setdnsservers Wi-Fi empty",
    cloudflare = "networksetup -setdnsservers Wi-Fi 127.0.0.1 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4",
  },
}

return M
