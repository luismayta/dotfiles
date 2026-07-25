## Context

El módulo nvim (`zsh/modules/nvim/`) gestiona la configuración de Neovim vía lazy.nvim. Actualmente usa Catppuccin (mocha) como theme, declarado en `plugins/catppuccin.lua` con integraciones manuales para ~15 plugins. La paleta se propaga a lualine vía configuración explícita.

TokyoNight (folke/tokyonight.nvim) ofrece soporte automático para lazy.nvim via `plugins.auto = true`, detectando qué plugins están cargados y aplicando integraciones sin configuración manual. Tiene 4 variantes: storm (default dark), moon (darker), night (darkest), day (light).

## Goals / Non-Goals

**Goals:**
- Reemplazar Catppuccin por TokyoNight como theme default
- Mantener la misma estética dark similar (variante `storm` se acerca más a Catppuccin mocha que night o moon)
- Aprovechar la detección automática de plugins de TokyoNight para eliminar configuración manual
- Mantener la capacidad de usar terminal colors y transparent background como opciones

**Non-Goals:**
- Agregar extras de TokyoNight para terminales externos (Ghostty, Kitty, etc.) — se puede hacer después
- Cambiar otros plugins del setup nvim
- Agregar soporte light mode (day variant) — opcional futuro
- Migrar otros dotfiles al palette de TokyoNight

## Decisions

### D1: Variante `storm` como default
- **Elección**: `style = "storm"` — es la variante dark estándar, más equilibrada que `night` (muy oscura) o `moon` (más saturada)
- **Alternativa considerada**: `moon` (la que usa el README como default de lazy.nvim) — más oscura, puede ser menos legible en terminales con poco contraste
- **Razón**: storm tiene mejor balance contraste/legibilidad y es la variante más usada en producción

### D2: Eliminar catppuccin.lua, crear tokyonight.lua
- **Elección**: Archivo nuevo dedicado, no mutar el existente
- **Alternativa**: Renombrar/modificar catppuccin.lua in-place
- **Razón**: Limpieza explícita — el diff deja claro el cambio de dependency. Menos riesgo de留下 leftover config

### D3: lualine.lua — theme automático
- **Elección**: Quitar `theme = "catppuccin"` y la dependencia explícita de catppuccin. TokyoNight detecta lualine automáticamente via `plugins.auto`
- **Alternativa**: Poner `theme = "tokyonight"` explícitamente
- **Razón**: Menos configuración = menos mantenimiento. La auto-detección funciona correctamente

### D4: Mantener configuración mínima en tokyonight.lua
- **Elección**: Setup mínimo — solo `style`, `terminal_colors`, `styles` (italic comments/keywords)
- **Alternativa**: Configurar `on_colors`/`on_highlights` para personalizar
- **Razón**: Empezar limpio. Los overrides se agregan después si es necesario

## Risks / Trade-offs

- **[Riesgo] Overrides de highlights Catppuccin quedan huérfanos** → Mitigación: Buscar `catppuccin` en todos los .lua y eliminar referencias
- **[Riesgo) plugins.auto no detecta todos los plugins** → Mitigación: TokyoNight soporte nativo de los plugins del setup (telescope, treesitter, gitsigns, etc.). Se puede habilitar manualmente si falla
- **[Trade-off) Perder personalización de Catppuccin mocha** → Aceptado: storm es visualmente comparable. Overrides disponibles vía `on_highlights`
- **[Trade-off) Break install colorscheme** → Mitigación: Actualizar lazy.lua install fallback a `tokyonight`
