local custom = require("custom")

local M = {}

function M.register(mainMod)
  -- HJKL focus navigation: focus, move, swap
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

  -- Window actions
  hl.bind(mainMod .. " + Q", hl.dsp.window.close())
  hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())
  hl.bind(mainMod .. " + T", hl.dsp.window.float())
  hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

  -- Mouse drag/resize
  hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
  hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

  -- Resize binds (repeating)
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

  -- Group management
  hl.bind(mainMod .. " + W", hl.dsp.group.toggle())
  hl.bind(mainMod .. " + BracketLeft", hl.dsp.group.prev())
  hl.bind(mainMod .. " + BracketRight", hl.dsp.group.next())

  -- Multimedia keys (no mainMod prefix)
  local media_binds = {
    { key = "XF86AudioRaiseVolume", exec = "dms ipc call audio increment 3", opts = { locked = true, repeating = true } },
    { key = "XF86AudioLowerVolume", exec = "dms ipc call audio decrement 3", opts = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessDown", exec = "dms ipc call brightness decrement 5", opts = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessUp", exec = "dms ipc call brightness increment 5", opts = { locked = true, repeating = true } },
    { key = "XF86AudioMicMute", exec = "dms ipc call audio micmute", opts = { locked = true } },
    { key = "XF86AudioMute", exec = "dms ipc call audio mute", opts = { locked = true } },
    { key = "XF86AudioNext", exec = "dms ipc call mpris next", opts = { locked = true } },
    { key = "XF86AudioPause", exec = "dms ipc call mpris playPause", opts = { locked = true } },
    { key = "XF86AudioPlay", exec = "dms ipc call mpris playPause", opts = { locked = true } },
    { key = "XF86AudioPrev", exec = "dms ipc call mpris previous", opts = { locked = true } },
  }

  for _, bind in ipairs(media_binds) do
    hl.bind(bind.key, hl.dsp.exec_cmd(bind.exec), bind.opts)
  end
  --
  -- Clipboard bindings (omarchy pattern)
  --
  -- Work around Hyprland send_shortcut leaving synthetic key state stuck/repeating.
  -- https://github.com/hyprwm/Hyprland/discussions/14099
  local function send_shortcut_once(mods, key)
    return function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down", window = "activewindow" }))
      hl.timer(function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up", window = "activewindow" }))
      end, { timeout = 50, type = "oneshot" })
    end
  end

  hl.bind(mainMod .. " + C", send_shortcut_once("CTRL", "Insert"))  -- universal copy (overrides old center-window which moved to SHIFT+C)
  hl.bind(mainMod .. " + V", send_shortcut_once("SHIFT", "Insert"))  -- universal paste
  hl.bind(mainMod .. " + SHIFT + X", send_shortcut_once("CTRL", "X"))  -- universal cut
  hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd("walker -m clipboard"))  -- clipboard manager

  --
  -- Hardware controls (keyboard backlight, touchpad, precise audio/brightness)
  --
  -- Keyboard backlight
  hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set +33%"), { locked = true, repeating = true })
  hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set 33%-"), { locked = true, repeating = true })
  hl.bind(mainMod .. " + F12", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set 100%"), { locked = true })
  hl.bind(mainMod .. " + SHIFT + F12", hl.dsp.exec_cmd("brightnessctl -d '*::kbd_backlight' set 0%"), { locked = true })

  -- Touchpad toggle
  hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("dms ipc call touchpad toggle"), { locked = true })
  hl.bind(mainMod .. " + SHIFT + CTRL + SPACE", hl.dsp.exec_cmd("dms ipc call touchpad on"), { locked = true })
  hl.bind(mainMod .. " + SHIFT + ALT + SPACE", hl.dsp.exec_cmd("dms ipc call touchpad off"), { locked = true })

  -- Precise volume (±1%)
  hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 1"), { locked = true, repeating = true })
  hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 1"), { locked = true, repeating = true })

  -- Precise brightness (±1%)
  hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("dms ipc call brightness decrement 1"), { locked = true, repeating = true })
  hl.bind("ALT + XF86MonBrightnessUp", hl.dsp.exec_cmd("dms ipc call brightness increment 1"), { locked = true, repeating = true })

  -- Enhanced group management
  hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ into_group = "l" }))
  hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ into_group = "d" }))
  hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ into_group = "u" }))
  hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ into_group = "r" }))

  hl.bind(mainMod .. " + ALT + 1", hl.dsp.group.active({ index = 1 }))
  hl.bind(mainMod .. " + ALT + 2", hl.dsp.group.active({ index = 2 }))
  hl.bind(mainMod .. " + ALT + 3", hl.dsp.group.active({ index = 3 }))
  hl.bind(mainMod .. " + ALT + 4", hl.dsp.group.active({ index = 4 }))
  hl.bind(mainMod .. " + ALT + 5", hl.dsp.group.active({ index = 5 }))

  hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.move({ out_of_group = true }))
end

return M
