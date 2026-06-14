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
    },
})
