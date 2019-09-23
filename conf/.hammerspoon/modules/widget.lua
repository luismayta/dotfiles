local hotkey = require("core.hotkey")

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
Install:andUse(
   "ModalMgr",
   {
      loglevel = 'debug',
   }
)
