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
  hl.bind(mainMod .. " + C", hl.dsp.window.center())
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
end

return M
