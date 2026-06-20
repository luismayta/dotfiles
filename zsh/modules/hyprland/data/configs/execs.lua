-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user start hyprland-session.target")
  hl.exec_cmd("killall -q xdg-desktop-portal xdg-desktop-portal-hyprland; sleep 1; /usr/lib/xdg-desktop-portal-hyprland & /usr/lib/xdg-desktop-portal &")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 &")
  hl.exec_cmd("fcitx5")
end)