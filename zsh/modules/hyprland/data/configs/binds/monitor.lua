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

  --
  -- Monitor scaling cycle: SUPER + period to cycle forward, SUPER + ALT + equal backward
  -- (SUPER + equal is reserved for window resize)
  --
  hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("$HOME/.dotfiles/zsh/modules/hyprland/data/bin/monitor-scaling-cycle"))
  hl.bind(mainMod .. " + ALT + equal", hl.dsp.exec_cmd("$HOME/.dotfiles/zsh/modules/hyprland/data/bin/monitor-scaling-cycle --reverse"))

  -- Toggle internal display (eDP-1) with safety check: SUPER + CTRL + Delete
  hl.bind(mainMod .. " + CTRL + Delete", hl.dsp.exec_cmd([[
    state=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .disabled // false')
    if [ "$state" = "true" ]; then
      hyprctl eval 'hl.monitor({ output="eDP-1", mode="preferred", position="auto", scale=1 })'
    else
      other=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -1)
      [ -n "$other" ] || exit 1
      hyprctl workspaces -j | jq -r '.[] | select(.monitor == "eDP-1") | .id' |
      while read ws; do hyprctl dispatch moveworkspacetomonitor "$ws" "$other"; done
      hyprctl eval 'hl.monitor({ output="eDP-1", disabled=true })'
    fi
  ]]))

  -- Mirror internal display: SUPER + CTRL + ALT + Delete
  hl.bind(mainMod .. " + CTRL + ALT + Delete", hl.dsp.exec_cmd([[
    state=$(hyprctl monitors -j | jq -r '.[] | select(.name == "eDP-1") | .disabled // false')
    if [ "$state" = "true" ]; then
      external=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -1)
      [ -n "$external" ] || exit 1
      hyprctl eval 'hl.monitor({ output="eDP-1", mode="preferred", position="0x0", scale=1, mirror="'"$external"'" })'
    else
      hyprctl eval 'hl.monitor({ output="eDP-1", disabled=true })'
    fi
  ]]))

  -- Lid Switch: disable internal when external connected, re-enable when opened
  hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd([[
    external=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -1)
    if [ -n "$external" ]; then
      hyprctl workspaces -j | jq -r '.[] | select(.monitor == "eDP-1") | .id' |
      while read ws; do hyprctl dispatch moveworkspacetomonitor "$ws" "$external"; done
      hyprctl eval 'hl.monitor({ output="eDP-1", disabled=true })'
    fi
  ]]), { locked = true })
  hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl eval 'hl.monitor({ output=\"eDP-1\", mode=\"preferred\", position=\"auto\", scale=1 })'"), { locked = true })
end

return M
