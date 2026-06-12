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
end

return M
