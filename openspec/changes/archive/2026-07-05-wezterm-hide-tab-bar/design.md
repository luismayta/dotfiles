## Context

WezTerm muestra la tab bar permanentemente porque `hide_tab_bar_if_only_one_tab = false` en `config/appearance.lua`. Con una sola pestaña, la tab bar ocupa ~30px de espacio vertical sin utilidad.

Ya existe infraestructura para toggle manual via el evento `tabs.toggle-tab-bar` en `events/tab-title.lua:347`, pero no hay keybinding asociado ni se usa la opción nativa de auto-ocultar.

## Goals / Non-Goals

**Goals:**
- Ocultar la tab bar cuando solo hay 1 pestaña abierta
- Que aparezca automáticamente al crear una segunda pestaña
- Cero impacto en funcionalidad existente

**Non-Goals:**
- No agregar keybindings nuevos
- No modificar el evento `tabs.toggle-tab-bar`
- No cambiar la lógica de tab titles, left/right status, o launch menu
- No cambiar colores, fuentes, o apariencia general

## Decisions

| Decisión | Opción | Rationale |
|---|---|---|
| Usar opción nativa `hide_tab_bar_if_only_one_tab` | `hide_tab_bar_if_only_one_tab = true` vs. `enable_tab_bar = false` | La opción nativa es la más limpia: permite tener tabs cuando se necesitan sin config overrides. `enable_tab_bar = false` las deshabilita permanentemente. |
| No agregar keybinding toggle | No añadir bind | Ya existe `tabs.toggle-tab-bar` vía el event system. Agregar un keybinding para esto ahora agregaría complejidad innecesaria. Se puede añadir después si se necesita. |

## Risks / Trade-offs

- **[Bajo] Confusión inicial**: Usuarios podrían no saber que los tabs existen hasta que creen una segunda pestaña. Mitigación: el toggle manual (`tabs.toggle-tab-bar`) sigue disponible y se puede invocar desde la command palette.
- **[Ninguno] Breaking change**: Este cambio no afecta APIs, atajos, ni flujos existentes. Es purely additive en comportamiento.

## Implementation

Cambio único en `zsh/modules/wezterm/data/config/appearance.lua`, línea 27:

```
-  hide_tab_bar_if_only_one_tab = false,
+  hide_tab_bar_if_only_one_tab = true,
```
