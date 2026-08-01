## Why

Los dotfiles ya poseen un bootstrap en la raíz (`install.sh`) que prepara máquinas macOS (brew) y Linux, pero el soporte Linux está restringido a Arch/CachyOS con paru. Falta reproducir el entorno en Ubuntu/Debian, donde el gestor nativo es apt.

## What Changes

- Ampliar `install.sh` para soportar Ubuntu/Debian además de Arch/CachyOS:
  - `setup::linux`: aceptar `ubuntu`/`debian` además de `arch`/`cachyos` (bloque `/etc/os-release` existente)
  - `setup::packages::common`: dispatch por sub-distro → `apt-get` en Ubuntu/Debian, `paru` en Arch
  - `config/packages.sh`: nuevos arrays `PACKAGES_APT` y `PACKAGES_APT_REPOS`
  - Configurar repositorios adicionales (PPA/apt keys) antes de instalar
- Corregir instalación de `paru` en Arch puro (AUR/makepkg o chaotic-aur; `pacman -S paru` no existe en repos oficiales)
- Idempotencia explícita: guards `dpkg -s` / `paru -Q` antes de instalar
- Instalar herramientas modernas (mise, devbox, starship): vía paquetes/repos en el bootstrap (Arch paru, Ubuntu mise vía PPA) y vía los módulos zsh en runtime (devbox/starship con `core::install`)

## Capabilities

### New Capabilities
- `linux-install`: Bootstrap de instalación Linux en `install.sh` que soporta Ubuntu/Debian (apt) y Arch/CachyOS (paru): instala dependencias vía gestor nativo, configura repositorios adicionales, instala herramientas modernas y es idempotente.

### Modified Capabilities
None

## Impact

- `install.sh` (raíz): `setup::linux` y `setup::packages::common` ampliados
- `config/packages.sh`: nuevos arrays `PACKAGES_APT` y `PACKAGES_APT_REPOS`
- `zsh/system/core/internal/linux.zsh`: `core::internal::core::install` con dispatch por gestor nativo (apt/paru)
- Requiere privilegios sudo para operaciones del gestor
- Fuente: https://github.com/CodipLab/dotfiles
