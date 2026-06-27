-- Workspace management and DMS IPC keybindings

local M = {}

function M.register(mainMod, C)
  -- Scratchpad
  hl.bind(C.DIRECT .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
  hl.bind(C.SUPER_SHIFT .. " + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

  -- Workspace focus and move (1-9)
  for i = 1, 9 do
    hl.bind(C.DIRECT .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(C.SUPER_SHIFT .. " + " .. i, hl.dsp.window.move({ workspace = i }))
  end

  -- DMS IPC binds
  local dms_binds = {
    { key = "ALT + L", exec = "dms ipc call lock lock" },
    { key = "M", exec = "dms ipc call processlist focusOrToggle" },
    { key = "N", exec = "dms ipc call notifications toggle" },
    { key = "SHIFT + N", exec = "dms ipc call notepad toggle" },
    { key = "TAB", exec = "dms ipc call hypr toggleOverview" },
    { key = "X", exec = "dms ipc call powermenu toggle" },
    { key = "Y", exec = "dms ipc wallpaperCarousel toggle" },
    { key = "comma", exec = "dms ipc call settings focusOrToggle" },
    { key = "space", exec = "dms ipc call spotlight toggle" },
    { key = "CTRL + ALT + Delete", exec = "dms ipc call processlist focusOrToggle" },
  }

  for _, bind in ipairs(dms_binds) do
    hl.bind(C.DIRECT .. " + " .. bind.key, hl.dsp.exec_cmd(bind.exec))
  end
  --
  -- Notification controls (DMS IPC)
  --
  hl.bind(C.SUPER_SHIFT .. " + N", hl.dsp.exec_cmd("dms ipc call notifications dismissLast"))
  hl.bind(C.SUPER_CTRL .. " + N", hl.dsp.exec_cmd("dms ipc call notifications dismissAll"))
  hl.bind(C.SUPER_ALT .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggleSilence"))
  hl.bind(C.SUPER_SHIFT .. " + M", hl.dsp.exec_cmd("dms ipc call notifications restoreLast"))

  --
  -- Workspace navigation enhancements
  --
  hl.bind(C.SUPER_SHIFT .. " + TAB", hl.dsp.focus({ workspace = "previous" }))
  hl.bind(C.SUPER_CTRL .. " + XF86MonBrightnessDown", hl.dsp.focus({ workspace = "e-1" }))
  hl.bind(C.SUPER_CTRL .. " + XF86MonBrightnessUp", hl.dsp.focus({ workspace = "e+1" }))

  -- Focus adjacent monitors
  hl.bind(C.SECONDARY .. " + TAB", hl.dsp.focus({ monitor = "+1" }))
  hl.bind(C.SECONDARY .. " + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }))

  -- Focus adjacent monitors with HJKL
  hl.bind(C.SUPER_SHIFT_ALT .. " + H", hl.dsp.focus({ monitor = "l" }))
  hl.bind(C.SUPER_SHIFT_ALT .. " + L", hl.dsp.focus({ monitor = "r" }))

  -- Move workspace to adjacent monitor
  hl.bind(C.SUPER_SHIFT_ALT .. " + LEFT", hl.dsp.workspace.move({ monitor = "l" }))
  hl.bind(C.SUPER_SHIFT_ALT .. " + RIGHT", hl.dsp.workspace.move({ monitor = "r" }))
  hl.bind(C.SUPER_SHIFT_ALT .. " + UP", hl.dsp.workspace.move({ monitor = "u" }))
  hl.bind(C.SUPER_SHIFT_ALT .. " + DOWN", hl.dsp.workspace.move({ monitor = "d" }))

  --
  -- Utility binds
  --
  -- Lock screen
  hl.bind(C.SUPER_ALT .. " + ESCAPE", hl.dsp.exec_cmd("dms ipc call lock lock"))

  -- Color picker
  hl.bind(C.DIRECT .. " + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))

  -- OCR screenshot
  hl.bind(C.SUPER_SHIFT .. " + PRINT", hl.dsp.exec_cmd("dms ipc call screenshot ocr"))

  -- Cycle window transparency (0.97 → 0.60 → 1.0)
  hl.bind(C.DIRECT .. " + O", hl.dsp.exec_cmd([[hyprctl getoption decoration:active_opacity -j | jq -r '.float' | awk '{if ($1 == "0.97") print "0.60"; else if ($1 == "0.60") print "1.0"; else print "0.97"}' | xargs -I{} hyprctl keyword decoration:active_opacity {}]]))

  -- Toggle window gaps (0px ↔ default)
  hl.bind(C.SUPER_SHIFT .. " + G", hl.dsp.exec_cmd([[current=$(hyprctl getoption general:gaps_out -j | jq -r '.int'); if [ "$current" -eq 0 ]; then hyprctl keyword general:gaps_out 5 && hyprctl keyword general:gaps_in 3; else hyprctl keyword general:gaps_out 0 && hyprctl keyword general:gaps_in 0; fi]]))

  -- Zoom in / reset
  hl.bind(C.SUPER_CTRL .. " + equal", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(awk 'BEGIN {z=('$(hyprctl getoption cursor:zoom_factor -j | jq -r '.float')')+0.5; if (z>5) z=5; print z}')"))
  hl.bind(C.SUPER_CTRL .. " + 0", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))
end

return M
