## Why

FiraCode Nerd Font v3.x tiene problemas de cobertura con ciertos codepoints PUA (ej: U+F739 en fish_indicator de starship), y actualmente el dotfiles usa **2 fuentes Nerd Font distintas** (FiraCode en 5 apps, JetBrainsMono en 1). Esto fragmenta la experiencia visual y agrega mantenimiento innecesario.

**Ahora** que Ghostty trae JetBrainsMono Nerd Font built-in, y la comunidad 2026 la adoptó como estándar, es el momento de unificar.

## What Changes

1. **Ghostty**: `font-family` de `FiraCode Nerd Font` → `JetBrainsMono Nerd Font`
2. **Alacritty**: `font` de `FiraCode Nerd Font` → `JetBrainsMono Nerd Font`
3. **Wezterm**: `font_family` de `FiraCode Nerd Font` → `JetBrainsMono Nerd Font`
4. **Zed Editor**: `ui_font_family` y `buffer_font_family` de `FiraCode Nerd Font` → `JetBrainsMono Nerd Font`
5. **Linux packages**: Actualizar `ttf-sourcecodepro-nerd` → `ttf-jetbrains-mono-nerd` (o equivalente)
6. **Provision fonts**: Sincronizar directorio de fonts provisionados

No hay cambios breaking — solo swap de fuente. Los iconos Nerd Font son idénticos (mismo set ~10,390+ glifos).

## Capabilities

### New Capabilities
- `nerd-font-unification`: Unificar todas las configuraciones de fuente del dotfiles a JetBrainsMono Nerd Font, con provisioning consistente en Linux y macOS.

### Modified Capabilities
<!-- No existing specs are modified — purely a new capability -->

## Impact

- **Ghostty**: `zsh/modules/ghostty/data/config` — 1 línea
- **Alacritty**: `zsh/modules/alacritty/data/core.toml` — 4 líneas
- **Wezterm**: `zsh/modules/wezterm/data/config/fonts.lua` — 1 línea
- **Zed Editor**: `zsh/modules/zed/data/settings.json` — 2 líneas
- **Linux packages**: `config/packages.sh` — 1 línea
- **Provision fonts**: `provision/fonts/` — posible sync de la fuente
- **GVim legacy** y **Terminal.app Nord**: se documentan pero no se migran (Powerline legacy, sin Nerd Font)
