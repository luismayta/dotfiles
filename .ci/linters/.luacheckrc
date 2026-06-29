-- .luacheckrc — Luacheck configuration for Hammerspoon config
-- https://github.com/mpeterv/luacheck

-- Global objects provided by Hammerspoon's Lua environment
-- (defined at top level, not inside files[], because pre-commit passes
--  absolute paths from the project root which don't match relative
--  patterns)
globals = {
  "_",
  "hs",
  "spoon",
  "settings",
  "_G",
  "pom_menu",
  "pom_timer",
}

-- Exclude warnings about unused arguments
-- (callback functions like hs.hotkey.bind receive args we may not use)
unused_args = false

-- Max line length (standard Lua convention)
max_line_length = 120

-- Exclude pre-existing issues that would be noisy to flag
ignore = {
  "212",  -- unused argument (callbacks)
  "411",  -- unused loop variable (iterator patterns)
}
