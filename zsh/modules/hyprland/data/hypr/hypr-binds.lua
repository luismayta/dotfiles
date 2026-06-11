-- Default Hyprland keybinds

-- === Application Launchers ===
hl.bind("SUPER + T", hl.exec_cmd("foot"))
hl.bind("SUPER + Return", hl.exec_cmd("foot"))
hl.bind("SUPER + space", hl.exec_cmd("wofi --show drun"))
hl.bind("ALT + space", hl.exec_cmd("wofi --show run"))
hl.bind("SUPER + V", hl.exec_cmd("wofi --show cliphist"))
hl.bind("SUPER + M", hl.exec_cmd("foot --class btop btm"))
hl.bind("SUPER + N", hl.exec_cmd("makoctl dismiss"))

-- === Security ===
hl.bind("SUPER + ALT + L", hl.exec_cmd("hyprlock"))
hl.bind("SUPER + SHIFT + E", hl.exit())
hl.bind("CTRL + ALT + Delete", hl.exec_cmd("wlogout"))

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +3%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -3%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.exec_cmd("brightnessctl s +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })

-- === Window Management ===
hl.bind("SUPER + Q", hl.exec_cmd("hyprctl dispatch killactive"))
hl.bind("SUPER + F", hl.exec_cmd("hyprctl dispatch fullscreen 1"))
hl.bind("SUPER + SHIFT + F", hl.exec_cmd("hyprctl dispatch fullscreen 0"))
hl.bind("SUPER + SHIFT + T", hl.exec_cmd("hyprctl dispatch togglefloating"))
hl.bind("SUPER + W", hl.exec_cmd("hyprctl dispatch togglegroup"))

-- === Focus Navigation ===
hl.bind("SUPER + left", hl.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind("SUPER + down", hl.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind("SUPER + up", hl.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind("SUPER + right", hl.exec_cmd("hyprctl dispatch movefocus r"))
hl.bind("SUPER + H", hl.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind("SUPER + J", hl.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind("SUPER + K", hl.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind("SUPER + L", hl.exec_cmd("hyprctl dispatch movefocus r"))

-- === Window Movement ===
hl.bind("SUPER + SHIFT + left", hl.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind("SUPER + SHIFT + down", hl.exec_cmd("hyprctl dispatch movewindow d"))
hl.bind("SUPER + SHIFT + up", hl.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind("SUPER + SHIFT + right", hl.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind("SUPER + SHIFT + H", hl.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind("SUPER + SHIFT + J", hl.exec_cmd("hyprctl dispatch movewindow d"))
hl.bind("SUPER + SHIFT + K", hl.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind("SUPER + SHIFT + L", hl.exec_cmd("hyprctl dispatch movewindow r"))

-- === Monitor Navigation ===
hl.bind("SUPER + CTRL + left", hl.exec_cmd("hyprctl dispatch focusmonitor l"))
hl.bind("SUPER + CTRL + right", hl.exec_cmd("hyprctl dispatch focusmonitor r"))
hl.bind("SUPER + CTRL + H", hl.exec_cmd("hyprctl dispatch focusmonitor l"))
hl.bind("SUPER + CTRL + L", hl.exec_cmd("hyprctl dispatch focusmonitor r"))

-- === Move to Monitor ===
hl.bind("SUPER + SHIFT + CTRL + left", hl.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind("SUPER + SHIFT + CTRL + right", hl.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))
hl.bind("SUPER + SHIFT + CTRL + H", hl.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor l"))
hl.bind("SUPER + SHIFT + CTRL + L", hl.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor r"))

-- === Workspace Navigation ===
hl.bind("SUPER + Page_Down", hl.exec_cmd("hyprctl dispatch workspace e+1"))
hl.bind("SUPER + Page_Up", hl.exec_cmd("hyprctl dispatch workspace e-1"))
hl.bind("SUPER + mouse_down", hl.exec_cmd("hyprctl dispatch workspace e+1"))
hl.bind("SUPER + mouse_up", hl.exec_cmd("hyprctl dispatch workspace e-1"))

-- === Numbered Workspaces ===
hl.bind("SUPER + 1", hl.exec_cmd("hyprctl dispatch workspace 1"))
hl.bind("SUPER + 2", hl.exec_cmd("hyprctl dispatch workspace 2"))
hl.bind("SUPER + 3", hl.exec_cmd("hyprctl dispatch workspace 3"))
hl.bind("SUPER + 4", hl.exec_cmd("hyprctl dispatch workspace 4"))
hl.bind("SUPER + 5", hl.exec_cmd("hyprctl dispatch workspace 5"))
hl.bind("SUPER + 6", hl.exec_cmd("hyprctl dispatch workspace 6"))
hl.bind("SUPER + 7", hl.exec_cmd("hyprctl dispatch workspace 7"))
hl.bind("SUPER + 8", hl.exec_cmd("hyprctl dispatch workspace 8"))
hl.bind("SUPER + 9", hl.exec_cmd("hyprctl dispatch workspace 9"))

-- === Move to Numbered Workspaces ===
hl.bind("SUPER + SHIFT + 1", hl.exec_cmd("hyprctl dispatch movetoworkspace 1"))
hl.bind("SUPER + SHIFT + 2", hl.exec_cmd("hyprctl dispatch movetoworkspace 2"))
hl.bind("SUPER + SHIFT + 3", hl.exec_cmd("hyprctl dispatch movetoworkspace 3"))
hl.bind("SUPER + SHIFT + 4", hl.exec_cmd("hyprctl dispatch movetoworkspace 4"))
hl.bind("SUPER + SHIFT + 5", hl.exec_cmd("hyprctl dispatch movetoworkspace 5"))
hl.bind("SUPER + SHIFT + 6", hl.exec_cmd("hyprctl dispatch movetoworkspace 6"))
hl.bind("SUPER + SHIFT + 7", hl.exec_cmd("hyprctl dispatch movetoworkspace 7"))
hl.bind("SUPER + SHIFT + 8", hl.exec_cmd("hyprctl dispatch movetoworkspace 8"))
hl.bind("SUPER + SHIFT + 9", hl.exec_cmd("hyprctl dispatch movetoworkspace 9"))

-- === Layout & Sizing ===
hl.bind("SUPER + R", hl.exec_cmd("hyprctl dispatch togglesplit"))
hl.bind("SUPER + CTRL + F", hl.exec_cmd("hyprctl dispatch fullscreen 1"))

-- === Move/resize windows with mainMod + LMB/RMB and dragging ===
hl.bind("SUPER + mouse:272", hl.exec_cmd("hyprctl dispatch movewindow"), { mouse = true })
hl.bind("SUPER + mouse:273", hl.exec_cmd("hyprctl dispatch resizewindow"), { mouse = true })

-- === Screenshots ===
hl.bind("Print", hl.exec_cmd("grimblast copy area"))
hl.bind("CTRL + Print", hl.exec_cmd("grimblast copy output"))
hl.bind("ALT + Print", hl.exec_cmd("grimblast copy active"))

-- === Touchpad Gestures ===
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
