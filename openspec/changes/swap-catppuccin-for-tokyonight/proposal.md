## Why

El theme actual Catppuccin (mocha) funciona bien, pero TokyoNight de folke ofrece mejor soporte nativo para los plugins del setup actual (blink.cmp, snacks, gitsigns, indent-blankline, mini, telescope, treesitter, which-key, neo-tree, neogit, bufferline) con integraciones automáticas via `plugins.auto = true`. Además, TokyoNight tiene 4 variantes (storm, moon, night, day) permitiendo alternar entre dark/light sin cambiar de theme, y provee extras para terminales (Ghostty, Kitty, Alacritty) y herramientas externas (Lazygit, Yazi, tmux) que Catppuccin no ofrece con la misma amplitud.

## What Changes

- Reemplazar el plugin spec `catppuccin.lua` por un nuevo `tokyonight.lua` con la variante `storm` como default
- Actualizar `config/lazy.lua` para usar `tokyonight` como colorscheme de install fallback
- Actualizar `lualine.lua` para usar el theme `tokyonight` en vez de `catppuccin`
- Eliminar la dependencia explícita de catppuccin en `lualine.lua`
- **BREAKING**: Los highlights custom o overrides que usen paleta Catppuccin necesitarán adaptarse a la paleta TokyoNight

## Capabilities

### Modified Capabilities
- `plugin-colorscheme`: Cambiar de Catppuccin a TokyoNight como theme default del módulo nvim

### New Capabilities
_(ninguna — es un swap de theme, no una funcionalidad nueva)_

## Impact

- **Archivos modificados**:
  - `zsh/modules/nvim/data/lua/plugins/catppuccin.lua` → eliminar
  - `zsh/modules/nvim/data/lua/plugins/tokyonight.lua` → crear
  - `zsh/modules/nvim/data/lua/plugins/lualine.lua` → actualizar theme + dependencias
  - `zsh/modules/nvim/data/lua/config/lazy.lua` → actualizar install colorscheme
- **Dependencias**: catppuccin/nvim removida, folke/tokyonight.nvim agregada
- **Plugins afectados**: lualine (theme explícito), bufferline (auto-detecta), todos los demás usan integración automática
- **Riesgo**: Bajo — es un swap de theme con configuración mínima custom
