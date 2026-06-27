-- Modifier tier constants
-- Each bind file requires this module for consistent modifier strings.
-- Convention:
--   DIRECT     = SUPER                       (primary navigation/actions)
--   HYPER      = SUPER + ALT + CTRL          (development tools)
--   SECONDARY   = CTRL + ALT                 (system applications)
--   SUPER_ALT   = SUPER + ALT                (window/group operations)
--   SUPER_SHIFT = SUPER + SHIFT              (extended actions)
--   SUPER_SHIFT_ALT = SUPER + SHIFT + ALT    (monitor operations)
--   SUPER_CTRL  = SUPER + CTRL               (power user actions)
--   SHIFT_CTRL_ALT = SHIFT + CTRL + ALT          (focus tier for HJKL + TAB)

local M = {}

function M.register(mainMod)
  M.DIRECT = mainMod
  M.HYPER = mainMod .. " + ALT + CTRL"
  M.SECONDARY = "CTRL + ALT"
  M.SUPER_ALT = mainMod .. " + ALT"
  M.SUPER_SHIFT = mainMod .. " + SHIFT"
  M.SUPER_SHIFT_ALT = mainMod .. " + SHIFT + ALT"
  M.SUPER_CTRL = mainMod .. " + CTRL"
  M.SHIFT_CTRL_ALT = "SHIFT + CTRL + ALT"
end

return M
