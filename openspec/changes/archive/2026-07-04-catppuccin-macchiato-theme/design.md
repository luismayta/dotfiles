## Context

El dotfiles tiene un estándar de facto: **Catppuccin Macchiato** como tema unificado. Actualmente 6 herramientas lo usan activamente. Neovim rompe la uniformidad con `dankcolors.lua` (theme custom Material You vía `base16-nvim`), y starship usa colores inline ad-hoc sin relación con Catppuccin.

El spec `plugin-colorscheme` existente especifica Catppuccin **mocha** — necesita actualizarse a **macchiato** para alinearse con el estándar real del dotfiles.

### Estado actual por herramienta

| Herramienta | Tema actual | Hacia |
|---|---|---|
| alacritty | Catppuccin Macchiato ✅ | Sin cambios |
| wezterm | Catppuccin Macchiato ✅ | Sin cambios |
| ghostty | Catppuccin Macchiato ✅ | Sin cambios |
| tmux | Catppuccin Macchiato ✅ | Sin cambios |
| zed | Catppuccin Macchiato ✅ | Sin cambios |
| hunk | Catppuccin Macchiato ✅ | Sin cambios |
| hyprland | Catppuccin Macchiato ✅ | Sin cambios |
| **nvim** | dankcolors (Material You) ❌ | **Catppuccin Macchiato** |
| **starship** | colores inline ad-hoc ❌ | **Catppuccin Macchiato** |

## Goals / Non-Goals

**Goals:**
- Reemplazar `dankcolors.lua` por Catppuccin Macchiato como colorscheme activo de neovim
- Migrar starship a paleta Catppuccin Macchiato usando `starship preset`
- Actualizar spec `plugin-colorscheme` de mocha → macchiato
- Mantener integración con LazyVim (bufferline, which-key, noice, telescope)

**Non-Goals:**
- No cambiar configuraciones de herramientas que ya usan Macchiato
- No modificar `ai/pi/settings.json` (`"theme": "dark"` es light/dark mode, no colorscheme)
- No crear un sistema de temas global — cada herramienta sigue configurando su tema individualmente
- No cambiar la configuración de neovim más allá del colorscheme

## Decisions

### 1. Catppuccin plugin vía lazy.nvim (no base16)
**Decisión**: Usar `catppuccin/nvim` directamente como plugin de lazy.nvim, en lugar de mantener `base16-nvim` con una paleta custom.
**Rationale**: El plugin oficial da integración LazyVim out-of-the-box para bufferline, which-key, noice, telescope. `base16-nvim` requeriría configurar manualmente cada highlight group.
**Alternativa considerada**: Mantener `base16-nvim` y recrear la paleta Macchiato — descartado porque duplica el trabajo de integración.

### 2. Variante Macchiato (no Mocha)
**Decisión**: Usar **Macchiato**, la misma variante que el resto del dotfiles.
**Rationale**: Consistencia visual. El spec existente decía "mocha" porque fue escrito antes de la unificación, pero el estándar real del dotfiles es Macchiato.

### 3. Starship preset vs inline colors
**Decisión**: Usar `starship preset` para generar un bloque de paleta global, y referenciar colores por nombre (p.ej. `color` en vez de `bold cyan`).
**Rationale**: Los presets de starship permiten definir una paleta una vez y referenciarla, facilitando cambios futuros. Más mantenible que colores inline.
**Alternativa considerada**: Mantener colores inline pero con valores hex de Macchiato — más verboso y difícil de mantener.

### 4. Deshabilitar dankcolors (no eliminar)
**Decisión**: Deshabilitar `dankcolors.lua` vía `enabled = false` en lugar de eliminar el archivo.
**Rationale**: Material You / Matugen es un tema alternativo válido. Mantenerlo deshabilitado permite re-activarlo sin reescribirlo. Si a futuro no se usa, se puede eliminar limpiamente.

## Risks / Trade-offs

- [**Regresión visual en neovim**] → Los highlight groups de `dankcolors.lua` tenían personalizaciones finas (p.ej., Statusline, LineNr). Verificar que Catppuccin Macchiato cubra todos los grupos usados antes de deshabilitar dankcolors.
- [**Starship preset rompe formato actual**] → El preset puede cambiar sizes/formatos. Revisar `starship.toml` completo después de aplicar preset para asegurar que no se pierdan personalizaciones existentes.
- [**dankcolors queda como dead code**] → Si no se reactiva en 3 meses, considerar eliminarlo en un cambio futuro (`deprecate`).
