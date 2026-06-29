## Why

Eliminar los 18 fonts locales obsoletos en `provision/fonts/` que se sincronizan vía rsync, y migrar a fonts gestionados exclusivamente por el gestor de paquetes del sistema operativo (paru en Linux, Homebrew en macOS). Esto reduce el mantenimiento, el tamaño del repo y unifica la instalación de fonts.

## What Changes

- **Eliminar** todo el directorio `provision/fonts/` (~18 fonts locales)
- **Eliminar** el sync de fonts del módulo `resources` (`zsh/modules/resources/pkg/base.zsh`)
- **Mantener** los 3 nerd fonts actuales en `CORE_PACKAGES` de Linux (`zsh/core/config/linux.zsh`)
- **Agregar** los 3 nerd fonts equivalentes vía Homebrew casks en macOS (`zsh/core/config/osx.zsh`) con una variable `CORE_CASK_PACKAGES`

## Capabilities

### New Capabilities
- `font-install-macos`: Instalación de fonts nerd via Homebrew casks en macOS

### Modified Capabilities
- `brew`: Agregar soporte para instalación de casks (fonts) via `CORE_CASK_PACKAGES`

## Impact

- **Eliminar**: `provision/fonts/` completo + función `resources::fonts::sync` y `resources::sync`
- **Modificar**: `zsh/core/config/linux.zsh` — mantener los 3 fonts
- **Modificar**: `zsh/core/config/osx.zsh` — agregar `CORE_CASK_PACKAGES` con los 3 fonts
- **Modificar**: `zsh/core/internal/osx.zsh` — instalar `CORE_CASK_PACKAGES` con `brew install --cask`
- **Config**: variables de entorno `RESOURCES_FONTS_PATH` y `RESOURCES_DATA_PATH` ya no serán necesarias
