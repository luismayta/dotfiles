require("core.hotkey")

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
         toggle = { hyper, "1" }
      },
})

-- Install:andUse(
--    "MouseCircle",
--    {
--       disable = true,
--       config = {
--          color = hs.drawing.color.x11.rebeccapurple
--       },
--       hotkeys = {
--          show = { hyper, "m" }
--       }
--    }
-- )

-- Install:andUse(
--    "ColorPicker",
--    {
--       disable = true,
--       hotkeys = {
--          show = { shift_hyper, "c" }
--       },
--       config = {
--          show_in_menubar = false,
--       },
--       start = true,
--    }
-- )

Install:andUse(
   "TimeMachineProgress",
   {
      start = true
   }
)

Install:andUse(
   "HeadphoneAutoPause",
   {
      start = true
   }
)
