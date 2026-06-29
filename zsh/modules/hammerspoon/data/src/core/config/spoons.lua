return function(hotkey)
  return {
    {
      name = "ModalMgr",
      settings = {
        loglevel = "debug",
      },
    },
    {
      name = "WindowScreenLeftAndRight",
      settings = {
        hotkeys = "default",
      },
    },

    {
      name = "HeadphoneAutoPause",
      settings = {
        start = true,
      },
    },
    {
      name = "ReloadConfiguration",
      settings = {
        start = true,
        hotkeys = {
          reloadConfiguration = { hotkey.hyper, "0" },
        },
      },
    },
    {
      name = "FnMate",
    },
    {
      name = "WinWin",
    },
  }
end