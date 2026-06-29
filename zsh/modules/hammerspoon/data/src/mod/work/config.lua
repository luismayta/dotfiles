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