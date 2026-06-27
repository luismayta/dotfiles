## Context

El módulo Hyprland en `.dotfiles` maneja keybindings mediante Lua organizado en `data/configs/binds/` con el siguiente esquema de tiers de modificadores:

| Tier | Combinación | Constante | Uso actual |
|---|---|---|---|
| DIRECT | `SUPER` | `C.DIRECT` | Window focus (HJKL), apps |
| HYPER | `SUPER + ALT + CTRL` | `C.HYPER` | App launchers (dev tools) |
| SECONDARY | `CTRL + ALT` | `C.SECONDARY` | App launchers (system) |
| SUPER_SHIFT | `SUPER + SHIFT` | `C.SUPER_SHIFT` | Move windows, workspace |
| SUPER_CTRL | `SUPER + CTRL` | `C.SUPER_CTRL` | Swap windows |
| SUPER_ALT | `SUPER + ALT` | `C.SUPER_ALT` | Group management |

El tier `HYPER` ya existe en `constants.lua` pero solo se usa para lanzar aplicaciones de desarrollo (Android Studio, IDEA, Zed, etc.). Los binds de navegación de ventanas usan exclusivamente `DIRECT` (`SUPER + HJKL`).

## Goals / Non-Goals

**Goals:**
- Agregar `HYPER + H/J/K/L` como alternativa HJKL para focus entre ventanas (equivalente funcional a `SUPER + HJKL`)
- Agregar `HYPER + SHIFT + H/J/K/L` para mover ventanas en dirección (equivalente a `SUPER + SHIFT + HJKL`)
- Agregar navegación de workspaces con el tier `HYPER` usando TAB:
  - `HYPER + TAB` para workspace anterior
  - `HYPER + SHIFT + TAB` para workspace siguiente
- Agregar `SUPER + SHIFT + ALT + H/L` para navegación entre monitores

**Non-Goals:**
- No modificar ni remover los binds existentes (`SUPER + HJKL`, `SUPER + SHIFT + HJKL`, etc.)
- No cambiar el sistema de tiers de modificadores
- No agregar nuevas dependencias externas
- No implementar layouts personalizados para esta funcionalidad

## Decisions

### 1. Reutilizar el tier `HYPER` existente

- **Decisión**: Usar la constante `C.HYPER` (`SUPER + ALT + CTRL`) ya definida en `constants.lua`
- **Razón**: El tier ya existe, está probado y consistente con el sistema de modificadores del módulo
- **Alternativa**: Crear un nuevo tier como `DIRECTIONAL = "SUPER + ALT"` — se descarta porque añadiría complejidad innecesaria y `SUPER + ALT` ya se usa para grupos

### 2. Nombre de teclas Hyprland para HJKL

- **Decisión**: Usar las teclas H, J, K, L (nombres estándar de Hyprland, compatibles con `dispatch focuswindow l/d/u/r`)
- **Razón**: Consistente con el paradigma Vim que ya usa el módulo (`SUPER + HJKL`), y un keychord más ergonómico que las flechas

### 3. Ubicación de los nuevos binds

- **Decisión**: Los binds de ventana van en `window.lua` (dentro de `M.register`), los binds de workspace/monitor en `workspace.lua`
- **Razón**: Sigue la separación de responsabilidades existente en el módulo

### 4. Desktop-level focus mapping

| Acción | Combinación |
|---|---|
| Focus workspace anterior | `HYPER + TAB` |
| Focus workspace siguiente | `HYPER + SHIFT + TAB` |
| Focus monitor izquierdo | `SUPER + SHIFT + ALT + H` |
| Focus monitor derecho | `SUPER + SHIFT + ALT + L` |

Para monitores se usa `SUPER + SHIFT + ALT` en lugar de HYPER por dos razones: (1) `HYPER` ya incluye CTRL, que añadiría otra tecla innecesaria, y (2) HJKL requiere H/L (izquierda/derecha) en lugar de UP/DOWN, por lo que el tier para monitores es `SUPER + SHIFT + ALT`, análogo al existente `SUPER + SHIFT + ALT + LEFT/RIGHT` para mover workspaces entre monitores.

### 5. Mapeo HJKL → dirección Hyprland

| Tecla | Dirección `hl.dsp.window.focus()` / `hl.dsp.window.move()` |
|---|---|
| `H` | `l` (left) |
| `J` | `d` (down) |
| `K` | `u` (up) |
| `L` | `r` (right) |

## Risks / Trade-offs

- **[Conflicto potencial]** HYPER + TAB podría solaparse con otros usos de la tecla TAB si no se prueba. → Mitigación: verificar binds activos con `hyprctl binds` tras implementar
- **[Sinergia]** HYPER + HJKL es un keychord de 4 teclas (SUPER+ALT+CTRL+ HJKL) que puede ser incómodo en algunas distribuciones de teclado. → Mitigación: es un bind secundario; el primario sigue siendo `SUPER + HJKL`
- **[Documentación]** Olvidar actualizar KEYBINDINGS.md. → Mitigación: incluirlo como tarea explícita

## Open Questions

1. ¿Prefieres `HYPER + SHIFT + TAB` para workspace siguiente y `HYPER + TAB` para anterior, o al revés? (La propuesta inicial usa TAB=anterior, SHIFT+TAB=siguiente, consistente con el estándar)
2. ¿Quieres también `HYPER + CTRL + H/L` para mover ventanas entre workspaces (enviar a workspace anterior/siguiente)?
