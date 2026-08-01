## 1. Soporte de distribuciones en install.sh

- [x] 1.1 Ampliar `setup::linux` para aceptar `ubuntu`/`debian` además de `arch`/`cachyos` (bloque `/etc/os-release` existente)
- [x] 1.2 Añadir dispatch por sub-distro en `setup::packages::common`: `apt-get` en Ubuntu/Debian, `paru -S --noconfirm` en Arch/CachyOS

## 2. Configuración declarativa de paquetes

- [x] 2.1 Añadir arrays `PACKAGES_APT` y `PACKAGES_APT_REPOS` en `config/packages.sh`
- [x] 2.2 Declarar `software-properties-common` como prereq de `add-apt-repository` en Ubuntu/Debian
- [x] 2.3 Añadir `zsh` a `PACKAGES_COMMON` para que `change_shell` no falle en máquina limpia

## 3. Helpers de gestor con idempotencia explícita

- [x] 3.1 Implementar helper de instalación apt con guard `dpkg -s` + `DEBIAN_FRONTEND=noninteractive`
- [x] 3.2 Implementar helper de repos apt con guard de existencia + `apt-get update` posterior
- [x] 3.3 Implementar helper de instalación paru con guard `paru -Q`
- [x] 3.4 Corregir instalación de `paru` en Arch puro (AUR/makepkg o chaotic-aur; nunca `pacman -S paru`)

## 4. Herramientas modernas

- [x] 4.1 Añadir `mise`, `devbox` y `starship` a `PACKAGES_LINUX` (AUR) para Arch
- [x] 4.2 Configurar `mise` para Ubuntu/Debian vía PPA `ppa:jdxcode/mise` en `PACKAGES_APT_REPOS`
- [x] 4.3 Ampliar `core::internal::core::install` en `zsh/system/core/internal/linux.zsh` con dispatch apt/paru (devbox/starship instalados por sus módulos zsh en Ubuntu)
- [x] 4.4 Eliminar instaladores duplicados `tools/devbox/install.sh` y `tools/starship/install.sh` (la instalación la gestionan los módulos zsh)

## 5. Validación

- [x] 5.1 Ejecutar shellcheck sobre todos los scripts modificados y corregir hallazgos
- [ ] 5.2 Validar el flujo completo de `install.sh` (bootstrap) y `provision/script/run.sh` con `TEST=true`
