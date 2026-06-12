local colors = require("configs.colors")

------------------
---- MONITORS ----
------------------

hl.monitor({
  output = "DP-1",
  mode = "preferred",
  position = "auto",
  scale = "1",
  bitdepth = 10,
  cm = "dcip3",
})

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    kb_layout = "us",
  },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
  general = {
    gaps_in = 12,
    gaps_out = 24,
    border_size = 2,

    layout = "dwindle",

    col = {
      active_border = {
        colors = { colors.green, colors.lavender, colors.pink },
        angle = 45,
      },
      inactive_border = colors.rgba.surface0("7f"),
    },
  },

  decoration = {
    rounding = 12,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 30,
      render_power = 5,
      offset = { 0, 5 },
      color = "rgba(00000070)",
    },

    blur = {
      enabled = true,
      size = 15,
      passes = 2,
      noise = 0.08,
      contrast = 1.5,
    },
  },

  animations = {
    enabled = true,
  },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "myBezier" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "myBezier" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "myBezier", style = "slide" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
  master = {
    new_status = "master",
    mfact = 0.5,
  },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
  scrolling = {
    fullscreen_on_one_column = false,
  },
})

---------------
---- GROUP ----
---------------

hl.config({
  group = {
    col = {
      border_active = {
        colors = { colors.green, colors.lavender, colors.pink },
        angle = 45,
      },
      border_inactive = colors.rgba.surface0("7f"),
    },

    groupbar = {
      font_family = "Rubik",
      font_size = 14,
      font_weight_active = "bold",

      height = 24,
      gaps_in = 8,
      gaps_out = 8,

      indicator_height = 0,

      gradients = true,
      gradient_rounding = 6,
      gradient_round_only_edges = false,

      col = {
        active = colors.rgba.base("cf"),
        inactive = colors.rgba.base("cf"),
      },

      text_color = colors.green,
      text_color_inactive = colors.subtext0,
    },
  },
})

---------------------------
----  MISC AND RENDER  ----
---------------------------

hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    vrr = 1,
  },

  render = {
    cm_sdr_eotf = "gamma22force",
  },
})
