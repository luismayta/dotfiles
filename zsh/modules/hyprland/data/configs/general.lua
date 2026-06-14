local colors = require("configs.colors")

------------------
---- MONITORS ----
------------------

-- DP-3: Monitor externo izquierdo
hl.monitor({
  output = "DP-1",
  mode = "preferred",
  position = "0x0",
  scale = "1",
  bitdepth = 10,
  cm = "dcip3",
})

-- HDMI-A-1: Monitor externo derecho (alineado a la derecha de DP-3)
hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "1920x0",
  scale = "1",
  bitdepth = 10,
  cm = "dcip3",
})

-- eDP-1: Laptop display (deshabilitado)
hl.monitor({
  output = "eDP-1",
  disabled = true,
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        repeat_rate = 35,
        repeat_delay = 200,
        -- Trackpad / libinput settings for Bluetooth trackpad (Magic Trackpad)
        touchpad = {
            natural_scroll = true,            -- macOS-style: content follows finger direction
            tap_to_click = true,               -- Tap to left-click
            clickfinger_behavior = true,       -- 2-finger = right-click, 3-finger = middle-click
            scroll_factor = 0.5,               -- Slower scroll for finer control
            disable_while_typing = true,       -- Prevent palm activation while typing
            middle_button_emulation = false,   -- Handled by clickfinger_behavior instead
            drag_lock = true,                  -- Lift finger during drag without dropping
        },
    },
})
