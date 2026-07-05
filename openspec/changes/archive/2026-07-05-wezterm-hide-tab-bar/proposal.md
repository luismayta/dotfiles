## Why

WezTerm muestra la tab bar incluso cuando solo hay una pestaña abierta, ocupando espacio vertical innecesario en la interfaz. Al ocultarla automáticamente con una sola pestaña, se maximiza el área utilizable del terminal sin perder funcionalidad cuando se necesitan múltiples pestañas.

## What Changes

- Cambiar `hide_tab_bar_if_only_one_tab` de `false` a `true` en `config/appearance.lua`
- La tab bar se mostrará automáticamente al crear una segunda pestaña y se ocultará al cerrar todas excepto una
- Sin cambios en keybindings, eventos, o la lógica existente de `tabs.toggle-tab-bar`

## Capabilities

### New Capabilities

No new capabilities — es un cambio de configuración puntual.

### Modified Capabilities

No existing capability requirements are changing. El comportamiento a nivel de requirements no cambia (WezTerm sigue soportando múltiples tabs), solo su presentación por defecto.

## Impact

- **Archivo afectado**: `zsh/modules/wezterm/data/config/appearance.lua` (1 línea modificada)
- **Sin impacto en**: eventos, keybindings, domains, launch menu, colores, o status bars
- **El evento `tabs.toggle-tab-bar`** sigue funcional para toggle manual si se requiere
- **Sin breaking changes**
