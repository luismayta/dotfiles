hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
Install:andUse(
   "ModalMgr",
   {
      loglevel = 'debug',
   }
)

Install:andUse(
   "WindowHalfsAndThirds",
   {
      config = {
         use_frame_correctness = true
      },
      hotkeys = 'default'
   }
)

Install:andUse(
   "WindowScreenLeftAndRight",
   {
      hotkeys = 'default'
   }
)

Install:andUse(
   "WindowGrid",
   {
      config = { gridGeometries = { { "6x4" } } },
      hotkeys = {show_grid = {hyper, "g"}},
      start = true
   }
)
