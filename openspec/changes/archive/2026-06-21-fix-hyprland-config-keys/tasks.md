## 1. Corregir cursor block

- [x] 1.1 Reemplazar `cursor.warp_on_workspace_change` por `cursor.warp_on_change_workspace` en `general.lua`

## 2. Corregir misc block — disable_logo

- [x] 2.1 Reemplazar `misc.disable_logo` por `misc.disable_hyprland_logo` en `general.lua`

## 3. Corregir misc block — disable_xdg_anr

- [x] 3.1 Reemplazar `misc.disable_xdg_anr` por `misc.disable_xdg_env_checks = true` y `misc.enable_anr_dialog = false` en `general.lua`

## 4. Corregir misc block — new_window_takes_over_fullscreen

- [x] 4.1 Reemplazar `misc.new_window_takes_over_fullscreen` por `misc.on_focus_under_fullscreen = 2` en `general.lua`

## 5. Verificar

- [x] 5.1 Validar que el archivo `general.lua` no tenga errores de sintaxis Lua (`luac -p` passed)
- [ ] 5.2 Ejecutar `hyprctl reload` y verificar que no aparezcan errores "unknown config key"
