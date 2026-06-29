local config = {}

config.hotkeys = {
  toggleFullscreen = {
    mods = { "alt" },
    key = "m",
    desc = "toggleFullscreen",
  },

  moveToNextScreen = {
    mods = { "alt" },
    key = "o",
    desc = "Toggle window screen",
  },
}

config.spoons = {
  {
    name = "WindowScreenLeftAndRight",
    settings = {
      config = {
        animationDuration = 0,
      },
      hotkeys = {
        screen_left = { { "alt" }, "h" },
        screen_right = { { "alt" }, "l" },
      },
    },
  },
  {
    name = "WinWin",
  },
}

return config
