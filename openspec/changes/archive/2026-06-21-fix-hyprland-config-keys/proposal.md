## Why

Hyprland está reportando errores "unknown config key" para 4 claves de configuración en `zsh/modules/hyprland/data/configs/general.lua`. Dos son errores de nombre (typos), una fue renombrada en Hyprland 0.53.0, y una nunca existió como tal — correspondía a dos claves separadas. La configuración actual es funcionalmente silenciosa (Hyprland ignora las claves inválidas), pero los errores saturan el log y pueden ocultar problemas reales.

## What Changes

1. **`cursor.warp_on_workspace_change`** → `cursor.warp_on_change_workspace` (error de orden de palabras)
2. **`misc.disable_logo`** → `misc.disable_hyprland_logo` (nombre incompleto)
3. **`misc.new_window_takes_over_fullscreen`** → `misc.on_focus_under_fullscreen = 2` (renombrada en Hyprland v0.53.0, valor por defecto del nuevo nombre)
4. **`misc.disable_xdg_anr`** → dividir en dos claves independientes:
   - `misc.disable_xdg_env_checks = true` (suprime warning XDG)
   - `misc.enable_anr_dialog = false` (desactiva diálogo ANR)

Archivo afectado: `zsh/modules/hyprland/data/configs/general.lua`
No hay cambios de sintaxis ni de estructura — solo nombres de clave y sus valores.

## Capabilities

### New Capabilities

- `hyprland-general-config`: Define las claves de configuración correctas para los bloques `cursor` y `misc` de Hyprland en `general.lua`, reemplazando las claves obsoletas/incorrectas por sus equivalentes modernos documentados.

## Impact

- **Archivo modificado**: `zsh/modules/hyprland/data/configs/general.lua`
- **Efecto**: Los errores "unknown config key" de Hyprland desaparecen. El comportamiento real de Hyprland no cambia porque las claves ya estaban siendo ignoradas — la corrección solo actualiza los nombres al contrato actual de la API de configuración.
- **Riesgo**: Bajo. Cada corrección tiene un equivalente directo y documentado.
- **Verificación**: Al recargar Hyprland (`hyprctl reload`), no deben aparecer los errores en el log.
