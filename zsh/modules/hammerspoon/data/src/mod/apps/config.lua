--[[
File:    mod/apps/config.lua
Purpose: Application-specific configuration — maps app names to launcher keywords
         and defines app-related hotkeys and workspace profiles.
Author:  Hammerspoon Config Team
--]]

--[[
  App bindings configuration.

  Structure:
    config.apps = {
      devs = { { key = "<key>", name = "<AppName>" }, ... },
      apps = { { key = "<key>", name = "<AppName>" }, ... },
      misc = { { key = "<key>", name = "<AppName>" }, ... },
    }

  To add a new app binding:
    1. Choose a group (devs, apps, misc) or create a new one
    2. Add { key = "<keyboard_shortcut>", name = "<AppName>" }
    3. The app name must match the macOS application name exactly

  config.profiles defines workspace profiles (which apps open on which screen)
  config.spoons defines Spoon plugin configurations
--]]
local config = {}

config.profiles = {
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

config.hotkeys = {
  profileSwitch = { { "ctrl", "alt", "cmd" }, "w" },
}

config.apps = {
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

config.spoons = {
  {
    name = "Cherry",
    settings = {
      start = false,
      hotkeys = {
        bindHotkeys = { { "ctrl", "alt", "cmd" }, "c" },
      },
    },
  },
}

return config
