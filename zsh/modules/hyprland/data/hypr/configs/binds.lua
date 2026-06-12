local custom = require("custom")

---------------------
---- KEYBINDINGS ----
---------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

---- Workspace Management

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

---- Window Management

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + C", hl.dsp.window.center())
hl.bind(mainMod .. " + T", hl.dsp.window.float())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
  mainMod .. " + equal",
  custom.helper.by_layout({
    { layout = "dwindle", dispatcher = custom.dsp.resize_window(5, 0) },
    { layout = "scrolling", dispatcher = hl.dsp.layout("colresize +conf") },
  }),
  { repeating = true }
)
hl.bind(
  mainMod .. " + minus",
  custom.helper.by_layout({
    { layout = "dwindle", dispatcher = custom.dsp.resize_window(-5, 0) },
    { layout = "scrolling", dispatcher = hl.dsp.layout("colresize -conf") },
  }),
  { repeating = true }
)
hl.bind(mainMod .. " + SHIFT + equal", custom.dsp.resize_window(0, 5), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", custom.dsp.resize_window(0, -5), { repeating = true })

local hjkl_binds = {
  { key = "H", direction = "left" },
  { key = "J", direction = "down" },
  { key = "K", direction = "up" },
  { key = "L", direction = "right" },
}

for _, bind in ipairs(hjkl_binds) do
  hl.bind(mainMod .. " + " .. bind.key, hl.dsp.focus({ direction = bind.direction }))
  hl.bind(mainMod .. " + SHIFT + " .. bind.key, hl.dsp.window.move({ direction = bind.direction }))
  hl.bind(
    mainMod .. " + CTRL + " .. bind.key,
    custom.helper.by_layout({
      { layout = "dwindle", dispatcher = hl.dsp.window.swap({ direction = bind.direction }) },
      {
        layout = "scrolling",
        dispatcher = function()
          local fn

          if bind.direction == "left" or bind.direction == "right" then
            fn = hl.dsp.layout("swapcol " .. (bind.direction == "left" and "l" or "r"))
          else
            fn = hl.dsp.window.swap({ direction = bind.direction })
          end

          hl.dispatch(fn)
        end,
      },
    })
  )
end

---- Group Management

hl.bind(mainMod .. " + W", hl.dsp.group.toggle())
hl.bind(mainMod .. " + BracketLeft", hl.dsp.group.prev())
hl.bind(mainMod .. " + BracketRight", hl.dsp.group.next())

---- Layout Management

hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Backslash", custom.dsp.next_layout())
hl.bind(mainMod .. " + SHIFT + Backslash", custom.dsp.prev_layout())

---- Execution Binds

local exec_binds = {
  -- Application launchers
  { key = "RETURN", exec = "kitty" },
  { key = "SHIFT + RETURN", exec = "kitty --class kitty-float" },
  { key = "B", exec = "zen-browser" },
  { key = "E", exec = "dolphin" },

  -- DankMaterialShell IPC calls
  -- Refer to https://danklinux.com/docs/dankmaterialshell/keybinds-ipc
  { key = "ALT + L", exec = "dms ipc call lock lock" },
  { key = "M", exec = "dms ipc call processlist focusOrToggle" },
  { key = "N", exec = "dms ipc call notifications toggle" },
  { key = "SHIFT + N", exec = "dms ipc call notepad toggle" },
  -- { key = "SHIFT + Slash", exec = "dms ipc call keybinds toggle hyprland" },
  { key = "TAB", exec = "dms ipc call hypr toggleOverview" },
  { key = "V", exec = "dms ipc call clipboard toggle" },
  { key = "X", exec = "dms ipc call powermenu toggle" },
  { key = "Y", exec = "dms ipc wallpaperCarousel toggle" },
  { key = "comma", exec = "dms ipc call settings focusOrToggle" },
  { key = "space", exec = "dms ipc call spotlight toggle" },
  { key = "CTRL + P", exec = "dms screenshot full" },
  { key = "P", exec = "dms screenshot" },
  { key = "SHIFT + P", exec = "exec dms screenshot window" },
  { key = "CTRL + ALT + Delete", exec = "dms ipc call processlist focusOrToggle" },

  -- Multi Media Keys
  {
    key = "XF86AudioRaiseVolume",
    exec = "dms ipc call audio increment 3",
    with_mod = false,
    opts = { locked = true, repeating = true },
  },
  {
    key = "XF86AudioLowerVolume",
    exec = "dms ipc call audio decrement 3",
    with_mod = false,
    opts = { locked = true, repeating = true },
  },
  {
    key = "XF86MonBrightnessDown",
    exec = "dms ipc call brightness decrement 5",
    with_mod = false,
    opts = { locked = true, repeating = true },
  },
  {
    key = "XF86MonBrightnessUp",
    exec = "dms ipc call brightness increment 5",
    with_mod = false,
    opts = { locked = true, repeating = true },
  },
  { key = "XF86AudioMicMute", exec = "dms ipc call audio micmute", with_mod = false, opts = { locked = true } },
  { key = "XF86AudioMute", exec = "dms ipc call audio mute", with_mod = false, opts = { locked = true } },
  { key = "XF86AudioNext", exec = "dms ipc call mpris next", with_mod = false, opts = { locked = true } },
  { key = "XF86AudioPause", exec = "dms ipc call mpris playPause", with_mod = false, opts = { locked = true } },
  { key = "XF86AudioPlay", exec = "dms ipc call mpris playPause", with_mod = false, opts = { locked = true } },
  { key = "XF86AudioPrev", exec = "dms ipc call mpris previous", with_mod = false, opts = { locked = true } },
}

for _, bind in ipairs(exec_binds) do
  local key = bind.key
  if bind.with_mod ~= false then
    key = mainMod .. " + " .. key
  end

  hl.bind(key, hl.dsp.exec_cmd(bind.exec), bind.opts)
end
