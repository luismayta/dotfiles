## Why

Actualmente la navegación entre ventanas en Hyprland usa exclusivamente `SUPER + HJKL` (formato Vim), sin soporte para flechas direccionales. Tampoco existe una forma consistente de navegar entre workspaces y monitores usando el mismo keychord. Esto crea fricción para usuarios que vienen de entornos Windows/macOS donde `CTRL + ALT + flechas` es el estándar de navegación entre ventanas/desktops.

Al agregar `HYPER (CTRL + ALT + WINDOW) + HJKL` como un segundo juego de binds direccionales, logramos:
- Consistencia con el paradigma Vim que ya usamos (`SUPER + HJKL`)
- Un mismo esquema mental para ventanas, workspaces y monitores
- Sin romper binds existentes — los originales siguen funcionando igual

## What Changes

1. **Window focus con HYPER + HJKL**: `CTRL + ALT + WINDOW (SUPER) + H/J/K/L` para mover el foco entre ventanas (equivalente funcional a `SUPER + HJKL`)
2. **Move window con HYPER + SHIFT + HJKL**: `CTRL + ALT + WINDOW + SHIFT + H/J/K/L` para mover ventanas entre direcciones (equivalente a `SUPER + SHIFT + HJKL`)
3. **Navegación de workspaces con HYPER + TAB**: `CTRL + ALT + WINDOW + TAB` para workspace anterior, `CTRL + ALT + WINDOW + SHIFT + TAB` para workspace siguiente
4. **Monitor focus con SUPER + SHIFT + ALT + H/L**: `WINDOW + SHIFT + ALT + H` para monitor izquierdo, `WINDOW + SHIFT + ALT + L` para monitor derecho

## Capabilities

### New Capabilities
- `window-directional-focus`: Focus y movimiento de ventanas usando el tier `HYPER` (CTRL+ALT+WINDOW) con teclas direccionales
- `desktop-focus`: Navegación de workspaces y monitores usando el tier `HYPER` con teclas direccionales

### Modified Capabilities

*(None — no existing specs are changing; only adding new keybindings to existing modules)*

## Impact

- **Archivos afectados**: `zsh/modules/hyprland/data/configs/binds/window.lua`, `zsh/modules/hyprland/data/configs/binds/workspace.lua`, `zsh/modules/hyprland/data/configs/binds/constants.lua`
- **Nuevas dependencias**: Ninguna — se reusa el tier `HYPER` ya definido en `constants.lua`
- **Breaking**: No — los binds existentes (`SUPER + HJKL`) se mantienen intactos
- **Documentación**: `zsh/modules/hyprland/docs/KEYBINDINGS.md` debe actualizarse reflejando los nuevos binds
