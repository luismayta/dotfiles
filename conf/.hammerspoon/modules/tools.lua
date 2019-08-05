local hotkey = require("core.hotkey")

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
Install:andUse(
   "ModalMgr",
   {
      loglevel = 'debug',
   }
)

-- Install:andUse(
--    "ClipboardTool",
--    {
--       config = { gridGeometries = { { "6x4" } } },
--       -- hotkeys = {show_grid = {hyper, "g"}},
--       start = true
--    }
-- )

-- -- Register Hammerspoon ClipboardTool
-- hs.loadSpoon("ClipboardTool")
-- hsclip_keys = {"alt", "V"}
-- spoon.ModalMgr.supervisor:bind(hsclip_keys[1], hsclip_keys[2], 'Launch Hammerspoon ClipboardTool', function() spoon.ClipboardTool:toggleClipboard() end)


-- Install:andUse(
--    "TextClipboardHistory",
--    {
--       disable = true,
--       config = {
--          show_in_menubar = false,
--       },
--       hotkeys = {
--          toggle_clipboard = { { "cmd", "shift" }, "v" } },
--       start = true,
--    }
-- )

Install:andUse(
   "Caffeine", {
      start = true,
      hotkeys = {
         toggle = { hotkey.hyper, "1" }
      },
})


Install:andUse(
   "HeadphoneAutoPause",
   {
      start = true
   }
)

Install:andUse(
   "ReloadConfiguration",
   {
      start = true,
      hotkeys = {
         reloadConfiguration = { hotkey.hyper, "0" }
      },
   }
)
