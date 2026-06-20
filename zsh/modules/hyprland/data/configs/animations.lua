---------------------------
---- ANIMATION CURVES ----
---------------------------

hl.config({
  bezier = {
    { name = "easeOutQuint", points = { 0.23, 1, 0.32, 1 } },
    { name = "easeInOutCubic", points = { 0.65, 0, 0.35, 1 } },
    { name = "easeInOutQuart", points = { 0.76, 0, 0.24, 1 } },
    { name = "easeInOutQuint", points = { 0.83, 0, 0.17, 1 } },
    { name = "easeOutExpo", points = { 0.16, 1, 0.3, 1 } },
    { name = "easeInOutCirc", points = { 0.85, 0, 0.15, 1 } },
    { name = "overshoot", points = { 0.05, 0.9, 0.1, 1.1 } },
  },
  animation = {
    -- Windows
    { name = "windowsIn", style = "slide", bezier = "easeOutQuint", speed = 4 },
    { name = "windowsOut", style = "slide", bezier = "easeOutQuint", speed = 4 },
    { name = "windowsMove", style = "slide", bezier = "easeOutQuint", speed = 4 },
    { name = "windowsResize", style = "none", bezier = "easeOutQuint", speed = 4 },
    -- Fades
    { name = "fadeIn", style = "fade", bezier = "easeInOutCubic", speed = 3 },
    { name = "fadeOut", style = "fade", bezier = "easeInOutCubic", speed = 3 },
    { name = "fadePopupsIn", style = "fade", bezier = "easeInOutCubic", speed = 2 },
    { name = "fadePopupsOut", style = "fade", bezier = "easeInOutCubic", speed = 2 },
    -- Borders
    { name = "border", style = "fade", bezier = "easeInOutCubic", speed = 8 },
    { name = "borderangle", style = "fade", bezier = "easeInOutCubic", speed = 8 },
    -- Workspaces
    { name = "workspaces", style = "slide", bezier = "easeOutQuint", speed = 4 },
    { name = "workspacesFloat", style = "slide", bezier = "easeOutQuint", speed = 4 },
  },
})
