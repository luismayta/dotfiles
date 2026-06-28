## Context

Actualmente hay 3 mecanismos de fonts en el repo:

1. **`provision/fonts/`** — 18 directorios con fonts organizadas por nombre (~200+ archivos .ttf/.otf). Es una capa de provisionamiento obsoleta.
2. **`zsh/modules/resources/data/fonts/`** — 235 font files planos que se rsyncan al font path del sistema vía `resources::fonts::sync`.
3. **`zsh/core/config/linux.zsh`** — 3 nerd fonts instalados vía paru (AUR): `ttf-firacode-nerd`, `ttf-jetbrains-mono-nerd`, `ttf-sourcecodepro-nerd`.

En macOS no hay fonts en `CORE_PACKAGES`. El único mecanismo es el rsync de `resources/data/fonts/`.

El objetivo es eliminar los mecanismos 1 y 2 (provision y resources sync), y unificar todo via package manager: paru en Linux, Homebrew casks en macOS.

## Goals / Non-Goals

**Goals:**
- Eliminar `provision/fonts/` completamente
- Eliminar `zsh/modules/resources/data/fonts/` y la función `resources::fonts::sync`
- Mantener los 3 nerd fonts en Linux (`CORE_PACKAGES`)
- Agregar los 3 nerd fonts equivalentes en macOS vía `CORE_CASK_PACKAGES` con `brew install --cask`
- Limpiar variables de entorno obsoletas (`RESOURCES_FONTS_PATH`, `RESOURCES_DATA_PATH`)

**Non-Goals:**
- No cambiar los fonts que se instalan en Linux
- No agregar/remover otros packages de `CORE_PACKAGES`
- No modificar el módulo `resources` (solo eliminar la parte de fonts)

## Decisions

| Decisión | Opciones | Elección | Razón |
|---|---|---|---|
| Cómo instalar fonts en macOS | Agregar a `CORE_PACKAGES` con `brew install --cask` vs crear variable separada | `CORE_CASK_PACKAGES` separada | `brew install` no acepta `--cask` global; las fórmulas regulares y casks se instalan distinto |
| Dónde definir `CORE_CASK_PACKAGES` | En `config/osx.zsh` vs config separada | `zsh/core/config/osx.zsh` | Misma convención que `CORE_PACKAGES` en `linux.zsh`, todo centralizado |
| Cómo procesar `CORE_CASK_PACKAGES` | Loop manual vs función helper | `brew install --cask "${CORE_CASK_PACKAGES[@]}"` en `internal/osx.zsh` | Mínimo cambio, consistente con `core::internal::core::install` |

Naming convention para brew casks: `font-<name>-nerd-font` (e.g., `font-fira-code-nerd-font`, `font-jetbrains-mono-nerd-font`, `font-source-code-pro-nerd-font`).

## Risks / Trade-offs

- **[Cleanup]** `zsh/modules/resources/` aún existe como módulo con otros archivos (assets, config, internal) — solo se elimina `data/fonts/` y `resources::fonts::sync`.
- **[Backwards compat]** Usuarios existentes con fonts en `~/.fonts` o `~/Library/Fonts` no perderán los fonts instalados previamente, solo se deja de sincronizar.
- **[macOS first-time]** Usuarios nuevos en macOS necesitarán Homebrew instalado para obtener los fonts (brew es requisito existente).
