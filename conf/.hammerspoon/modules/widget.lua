local hotkey = require("core.hotkey")

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
Install:andUse(
   "ModalMgr",
   {
      loglevel = 'debug',
   }
)

Install:andUse(
   "CircleClock",
   {
      loglevel = 'debug',
   }
)

Install:andUse(
   "HCalendar",
   {
      hotkeys = 'debug',
   }
)

-- Change wallpaper immediately
Install:andUse(
   "UnsplashZ",
   {
      hotkeys = 'debug',
   }
)
----------------------------------------------------------------------------------------------------
-- Register UnsplashZ
hsunsplash_keys = {"alt", "W"}
spoon.ModalMgr.supervisor:bind(
   hsunsplash_keys[1], hsunsplash_keys[2], "Change Wallpaper Immediately", function() spoon.UnsplashZ:unsplashRequest() end)
