--[[
File:    mod/work/config.lua
Purpose: Work module configuration — workspace profiles, app hotkeys, Spoon plugin
         configs, and pomodoro-related settings.
Author:  Hammerspoon Config Team
--]]

--[[
  Work module configuration — workspace profiles, app hotkeys, and Spoon configs.

  Workspace profiles (config.profiles):
    Each profile defines which apps launch on mainScreen vs secondScreen:
      profileName = {
        mainScreen = { "App1", "App2" },
        secondScreen = { "App3", "App4" },
      }

  To add a new profile:
    1. Add an entry to getProfiles() with the desired app layout
    2. The profile switch hotkey is defined in getHotkeys()

  To add a new app hotkey:
    1. Add an entry to getApps() with key + app name
    2. The key will be bound with the hyper modifier (ctrl+alt)

  Spoon entries in getSpoons() support:
    - name: The Spoon's folder name in ~/.hammerspoon/Spoons/
    - settings.hotkeys: Table passed to spoon:bindHotkeys()
    - settings.start: Boolean, whether to auto-start on load
--]]
local M = {}

local function getProfiles()
  return {
    developer = {
      mainScreen = { "Arc" },
      secondScreen = { "Ghostty", "Brave Browser", "Discord", "Obsidian" },
    },
    research = {
      mainScreen = { "Arc" },
      secondScreen = { "Ghostty", "Brave Browser", "Discord", "Obsidian" },
    },
    speaker = {
      mainScreen = { "Keynote", "Notes", "Arc", "Obsidian", "Ghostty" },
      secondScreen = { "Brave Browser", "Discord" },
    },
  }
end

local function getHotkeys()
  return {
    profileSwitch = { { "ctrl", "alt", "cmd" }, "w" },
  }
end

local function getApps()
  return {
    devs = {
      { key = "t", name = "Ghostty" },
      { key = "e", name = "Vscodium" },
    },
    apps = {
      { key = "d", name = "Discord" },
      { key = "b", name = "Brave Browser" },
    },
    misc = {
      { key = "o", name = "Obsidian" },
    },
  }
end

local function getSpoons(hotkey)
  return {
    {
      name = "Cherry",
      settings = {
        start = false,
        hotkeys = {
          bindHotkeys = { { "ctrl", "alt", "cmd" }, "c" },
        },
      },
    },
    {
      name = "Caffeine",
      settings = {
        start = true,
        hotkeys = {
          toggle = { hotkey.hyper, "1" },
        },
      },
    },
  }
end

function M.build(globalConfig)
  local hotkey = globalConfig and globalConfig.hotkey or {}

  return {
    profiles = getProfiles(),
    hotkeys = getHotkeys(),
    apps = getApps(),
    spoons = getSpoons(hotkey),
  }
end

return M
