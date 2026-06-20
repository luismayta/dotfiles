-- Workspace management and DMS IPC keybindings

local M = {}

function M.register(mainMod)
  -- Scratchpad
  hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
  hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

  -- Workspace focus and move (1-9)
  for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
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
    hl.bind(mainMod .. " + " .. bind.key, hl.dsp.exec_cmd(bind.exec))
  end
  --
  -- Notification controls (DMS IPC)
  --
  hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notifications dismissLast"))
  hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("dms ipc call notifications dismissAll"))
  hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd("dms ipc call notifications toggleSilence"))
  hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("dms ipc call notifications restoreLast"))

  --
  -- Workspace navigation enhancements
  --
  hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "previous" }))
  hl.bind(mainMod .. " + CTRL + BRIGHTNESSDOWN", hl.dsp.focus({ workspace = "e-1" }))
  hl.bind(mainMod .. " + CTRL + BRIGHTNESSUP", hl.dsp.focus({ workspace = "e+1" }))

  -- Focus adjacent monitors
  hl.bind("CTRL + ALT + TAB", hl.dsp.focus({ monitor = "+1" }))
  hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }))

  -- Move workspace to adjacent monitor
  hl.bind(mainMod .. " + SHIFT + ALT + LEFT", hl.dsp.workspace.move({ monitor = "l" }))
  hl.bind(mainMod .. " + SHIFT + ALT + RIGHT", hl.dsp.workspace.move({ monitor = "r" }))
  hl.bind(mainMod .. " + SHIFT + ALT + UP", hl.dsp.workspace.move({ monitor = "u" }))
  hl.bind(mainMod .. " + SHIFT + ALT + DOWN", hl.dsp.workspace.move({ monitor = "d" }))

  --
  -- Utility binds
  --
  -- Lock screen
  hl.bind(mainMod .. " + ALT + ESCAPE", hl.dsp.exec_cmd("dms ipc call lock lock"))

  -- Color picker
  hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"))

  -- OCR screenshot
  hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("dms ipc call screenshot ocr"))

  -- Cycle window transparency (0.97 → 0.60 → 1.0)
  hl.bind(mainMod .. " + O", hl.dsp.exec_cmd([[hyprctl getoption decoration:active_opacity -j | jq -r '.float' | awk '{if ($1 == "0.97") print "0.60"; else if ($1 == "0.60") print "1.0"; else print "0.97"}' | xargs -I{} hyprctl keyword decoration:active_opacity {}]]))

  -- Toggle window gaps (0px ↔ default)
  hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd([[current=$(hyprctl getoption general:gaps_out -j | jq -r '.int'); if [ "$current" -eq 0 ]; then hyprctl keyword general:gaps_out 5 && hyprctl keyword general:gaps_in 3; else hyprctl keyword general:gaps_out 0 && hyprctl keyword general:gaps_in 0; fi]]))

  -- Zoom in / reset
  hl.bind(mainMod .. " + CTRL + equal", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor $(awk 'BEGIN {z=('$(hyprctl getoption cursor:zoom_factor -j | jq -r '.float')')+0.5; if (z>5) z=5; print z}')"))
  hl.bind(mainMod .. " + CTRL + 0", hl.dsp.exec_cmd("hyprctl keyword cursor:zoom_factor 1"))
end

return M
