## Why

Actualmente 6 herramientas del dotfiles están unificadas bajo Catppuccin Macchiato (alacritty, wezterm, ghostty, tmux, zed, hunk), pero neovim usa un theme custom (`dankcolors` Material You) y starship usa colores inline ad-hoc sin una paleta coherente. Esta inconsistencia rompe la uniformidad visual del ecosistema. Unificar todo a Catppuccin Macchiato reduce fricción visual y simplifica el mantenimiento de temas.

## What Changes

- **Neovim**: Reemplazar `dankcolors.lua` por Catppuccin como colorscheme activo vía lazy.nvim plugin spec, integrado con componentes LazyVim (bufferline, which-key, noice)
- **Starship**: Migrar colores inline actuales a la paleta Catppuccin Macchiato usando el módulo `starship preset`
- **plugin-colorscheme spec**: Actualizar spec existente de mocha → macchiato para alinearlo con el estándar del dotfiles

## Capabilities

### New Capabilities
- `starship-catppuccin`: Aplicar paleta Catppuccin Macchiato a todos los módulos de starship (directory, git, node, python, rust, etc.) reemplazando colores inline hardcodeados

### Modified Capabilities
- `plugin-colorscheme`: Cambiar requirement de "Catppuccin mocha" a "Catppuccin Macchiato" para neovim, y extender para que sea el tema activo por defecto (no solo plugin spec)

## Impact

- `zsh/modules/nvim/data/lua/plugins/dankcolors.lua`: Reemplazar por `catppuccin.lua` (o marcar como deshabilitado)
- `zsh/modules/nvim/data/lua/config/lazy.lua`: Confirmar que `colorscheme = { "catppuccin" }` siga funcionando
- `zsh/modules/starship/data/starship.toml`: Actualizar todos los `style = "bold cyan"` etc. a valores de la paleta Macchiato
- `openspec/specs/plugin-colorscheme/spec.md`: Actualizar requirement de mocha a macchiato
- `zsh/modules/ai/data/pi/settings.json`: Queda fuera de scope — `"theme": "dark"` es solo light/dark mode, no un colorscheme
