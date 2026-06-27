## 1. Window directional focus binds

- [x] 1.1 Add HYPER + H/J/K/L for window focus in `window.lua`, equivalente funcional a SUPER + HJKL
- [x] 1.2 Add HYPER + SHIFT + H/J/K/L for moving windows in `window.lua`, equivalente funcional a SUPER + SHIFT + HJKL

## 2. Desktop-level focus binds

- [x] 2.1 Add HYPER + TAB for previous workspace (e-1) in `workspace.lua`
- [x] 2.2 Add HYPER + SHIFT + TAB for next workspace (e+1) in `workspace.lua`
- [x] 2.3 Add SUPER + SHIFT + ALT + H/L for monitor focus in `workspace.lua`

## 3. Documentation

- [x] 3.1 Update `KEYBINDINGS.md` with the new HYPER + HJKL binds for window focus
- [x] 3.2 Update `KEYBINDINGS.md` with the new HYPER + TAB workspace navigation binds
- [x] 3.3 Update `KEYBINDINGS.md` with new SUPER + SHIFT + ALT + H/L monitor focus binds

## 4. Verification

- [x] 4.1 Sync config (`hyprland::sync`) and reload Hyprland (`hyprctl reload`)
- [x] 4.2 Test HYPER + H/J/K/L focus moves in all four directions
- [x] 4.3 Test HYPER + SHIFT + H/J/K/L moves windows
- [x] 4.4 Test HYPER + TAB / SHIFT+TAB workspace navigation
- [x] 4.5 Test SUPER + SHIFT + ALT + H/L monitor focus
- [x] 4.6 Verify existing SUPER + HJKL binds still work (regression test)
- [x] 4.7 Verify no duplicate binding warnings in `hyprctl binds`
