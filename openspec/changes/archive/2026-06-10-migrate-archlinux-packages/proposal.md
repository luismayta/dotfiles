## Why

`archlinux.sh` es un script huérfano de 45 paquetes que existe fuera de la arquitectura del proyecto. El 75% de sus paquetes no tienen relación con ningún módulo ni con `zsh/core/`. Con el nuevo override pattern (api.zsh → osx.zsh/linux.zsh) y el sistema de auto-installs en `zsh/core/pkg/helper/core.zsh`, cada paquete debe vivir donde corresponde: `install.sh` para bootstrap, `zsh/core/` para dependencias de infraestructura, y un nuevo script `provision/` para el entorno desktop de Linux. `archlinux.sh` debe desaparecer.

## What Changes

1. **`install.sh` `setup::linux`** — Add packages: `zsh`, `ksh`, `fd` (bootstraps necesarios antes de que carguen los módulos)
2. **`zsh/core/pkg/helper/core.zsh`** — Add auto-install for `fd` (FZF_CTRL_T_COMMAND lo usa)
3. **`provision/script/desktop.sh`** — New script for Linux desktop environment packages (i3, audio, fonts, GTK themes, apps, etc.) sourced from `functions.sh`, reemplazando el rol de `archlinux.sh`
4. **`provision/script/functions.sh`** — Update `dotfiles_install_factory` to source `desktop.sh` instead of `archlinux.sh`
5. **`archlinux.sh`** — Remove (deprecated, su contenido migrado a install.sh, core, y desktop.sh)

## Capabilities

### New Capabilities
- `linux-desktop-provision`: Linux desktop environment setup (i3wm, audio, fonts, theming, apps) via `provision/script/desktop.sh`

### Modified Capabilities
- `core-api`: `zsh/core/pkg/helper/core.zsh` gains `fd` auto-install requirement
- *(No other existing specs modified)*

## Impact

- **`install.sh`** — `setup::linux` gets expanded bootstrap packages (zsh, ksh, fd)
- **`zsh/core/pkg/helper/core.zsh`** — New auto-install: `fd`
- **`provision/script/desktop.sh`** — New file (migrated from archlinux.sh, desktop/WM category)
- **`provision/script/functions.sh`** — Update source from `archlinux.sh` to `desktop.sh`
- **`archlinux.sh`** — Removed
