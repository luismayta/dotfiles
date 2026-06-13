-- Monitor management keybindings
-- ALT-based binds for window-to-monitor operations

local M = {}

-- Modifier constants
local ALT = "ALT"

function M.register(mainMod)
  -- Toggle window between monitors: ALT + O
  -- Cycles forward (1→2→3→1) with 3+ monitors; toggles 1↔2 with 2 monitors
  hl.bind(ALT .. " + O", hl.dsp.window.move({ monitor = "+1" }))

  -- Maximize window (fill workspace, keep bar visible): ALT + M
  hl.bind(ALT .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))

  -- Disable internal display & reload: ALT + D
  hl.bind(ALT .. " + D", hl.dsp.exec_cmd([[
    other=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -1) &&
    [ -n "$other" ] || exit 1 &&
    hyprctl workspaces -j | jq -r '.[] | select(.monitor == "eDP-1") | .id' |
    while read ws; do hyprctl dispatch moveworkspacetomonitor "$ws" "$other"; done &&
    hyprctl eval 'hl.monitor({ output="eDP-1", disabled=true})'
  ]]))
end

return M
