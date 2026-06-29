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