## Context

Actualmente el dotfiles tiene 5 configuraciones usando `FiraCode Nerd Font` y 1 (`nvim/CodeSnap`) ya usando `JetBrainsMono Nerd Font`. FiraCode Nerd Font v3.4.0 (instalada) tiene problemas de cobertura en ciertos codepoints PUA (ej: U+F739 para fish_indicator), y Ghostty ya incluye JetBrainsMono Nerd Font como built-in. Además, la font provisioning legacy usa Powerline-patched fonts en `provision/fonts/`.

## Goals / Non-Goals

**Goals:**
- Unificar todas las configuraciones de fuente a `JetBrainsMono Nerd Font`
- Actualizar el package manager de Linux para instalar la Nerd Font correcta
- Mantener consistencia visual en terminales (Ghostty, Alacritty, Wezterm) y editores (Zed)
- Documentar fuentes legacy que no se migran

**Non-Goals:**
- No migrar GVim (usa `Inconsolata for Powerline`, Powerline legacy)
- No migrar Terminal.app Nord (usa `SourceCodePro-Regular`, sin Nerd Font)
- No modificar el contenido del directorio `provision/fonts/` (fonts Powerline legacy, se mantienen para compatibilidad)
- No cambiar CodeSnap (ya usa JetBrainsMono Nerd Font)
- No cambiar Hyprland (solo font_size, sin family)

## Decisions

| Decisión | Opción Elegida | Alternativas Consideradas | Razón |
|---|---|---|---|
| **Fuente objetivo** | `JetBrainsMono Nerd Font` | FiraCode Nerd Font v3.3+, MesloLGS NF | JetBrainsMono es #1 en 2026, Ghostty lo trae built-in, mejor x-height y legibilidad, misma cobertura de iconos Nerd Font |
| **Variante de fuente** | `JetBrainsMono Nerd Font` (estándar) | `JetBrainsMono Nerd Font Mono`, `JetBrainsMonoNL Nerd Font` | La variante estándar tiene ligaduras y glifos proporcionales para la UI; `Mono` es estrictamente monoespaciado. Ghostty mapea `JetBrainsMono Nerd Font` a su built-in correctamente |
| **Approach de cambio** | Edición directa de archivos de configuración | Variable de entorno centralizada `$FONT_FAMILY` | Los archivos de configuración de cada app tienen sintaxis distinta (TOML, Lua, JSON, conf); una variable central agregaría complejidad innecesaria para un valor estático |
| **Package Linux** | Reemplazar `ttf-sourcecodepro-nerd` por `ttf-jetbrains-mono-nerd` | Agregar sin remover | SourceCodePro-nerd ya no se usa en ninguna config activa; mantenerlo es peso muerto |

## Migración Plan

1. Editar `zsh/modules/ghostty/data/config`: cambiar `font-family` (1 línea)
2. Editar `zsh/modules/alacritty/data/core.toml`: cambiar 4 entradas `family`
3. Editar `zsh/modules/wezterm/data/config/fonts.lua`: cambiar `font_family` (1 línea)
4. Editar `zsh/modules/zed/data/settings.json`: cambiar `ui_font_family` y `buffer_font_family` (2 líneas)
5. Editar `config/packages.sh`: reemplazar `ttf-sourcecodepro-nerd` por `ttf-jetbrains-mono-nerd`

**Rollback**: `git checkout HEAD -- <files>` en cada archivo modificado.

## Risks / Trade-offs

- [**Compatibilidad**] `JetBrainsMono Nerd Font` no existe en los repos de todas las distros Linux. En Arch está en AUR (`ttf-jetbrains-mono-nerd`). Si no está disponible, el fallback será la fuente del sistema. → **Mitigación**: documentar en el archivo de packages la fuente exacta, y considerar descarga directa desde nerd fonts release como plan B.
- [**Tamaño**] JetBrainsMono Nerd Font es ~2-3MB vs FiraCode ~2.5MB. Diferencia negligible.
- [**Ligaduras**] JetBrainsMono tiene ~138 ligaduras vs FiraCode ~180. Usuarios muy acostumbrados a ligaduras extensas (Haskell, Elm) podrían notar la diferencia. → **Mitigación**: las ligaduras más comunes (->, =>, ===, etc.) están en ambas fuentes.
