## Context

El bootstrap real de los dotfiles es `install.sh` en la raíz. Flujo: `setup::factory` → `detect::os` → `setup::mac` (brew + cask + nix + nix-darwin) o `setup::linux`; ambos llaman `setup::packages::common`, que hace `source config/packages.sh` y ejecuta `brew` (Darwin) o `paru -S --noconfirm` (Linux) sobre `PACKAGES_COMMON`/`PACKAGES_MAC`/`PACKAGES_LINUX`. `setup::linux` solo acepta `arch`/`cachyos`/`ID_LIKE=arch` (rechaza el resto con error). Luego `change_shell` a zsh, verifica prereqs (zsh, git, rsync), clona el repo y ejecuta `provision/script/run.sh` (paso 2 del provisioning). El runtime `core::install` en `zsh/system/core/pkg/base.zsh` ya delega a `paru -S --noconfirm` en Arch y `brew install` en macOS (specs `core-api`, `docker-module`). `config/packages.sh` hoy: `PACKAGES_COMMON=(ksh)`, `PACKAGES_MAC=(ag cmake font-source-code-pro)`, `PACKAGES_LINUX=(go npm yarn gcc ttf-jetbrains-mono-nerd)`.

## Goals / Non-Goals

**Goals:**
- Soportar Ubuntu/Debian (apt) además de Arch/CachyOS (paru) en `install.sh`
- Configurar repositorios adicionales necesarios para apt
- Instalar herramientas modernas (mise, devbox, starship, etc.)
- Ejecución idempotente y re-ejecutable sin efectos colaterales
- Alinear el gestor con `core::install` (paru en Arch, apt en Ubuntu/Debian)

**Non-Goals:**
- Cubrir macOS (ya gestionado vía brew en `setup::mac`)
- Cubrir otros gestores de paquetes (pacman directo, dnf)
- Cambiar el mecanismo de despliegue de configs (`provision/script/run.sh` paso 2)

## Decisions

1. **Ampliar `setup::linux`, no crear script nuevo**
   Se extiende el bloque `/etc/os-release` existente para aceptar `ubuntu`/`debian` además de `arch`/`cachyos`; distros no soportadas siguen rechazándose con error.
   - Alternativa: script standalone. Rechazada: duplica el bootstrap existente y rompe consistencia con `setup::factory`.

2. **Dispatch por sub-distro en `setup::packages::common`**
   Ubuntu/Debian → `apt-get` con `DEBIAN_FRONTEND=noninteractive`; Arch/CachyOS → `paru -S --noconfirm` (consistente con `core::install`).
   - Selección con el mismo `ID=`/`ID_LIKE=` de `/etc/os-release` que ya usa `setup::linux`.

3. **Configuración declarativa en `config/packages.sh`**
   Nuevos arrays `PACKAGES_APT` (deps Ubuntu/Debian) y `PACKAGES_APT_REPOS` (repos/PPAs adicionales). `PACKAGES_LINUX` queda para Arch (nombres pacman/AUR). Los configs solo declaran datos; la lógica vive en los helpers.
   - Prereq `software-properties-common` instalado antes de `add-apt-repository`.

4. **Idempotencia explícita por verificación previa**
   - Paquetes: `dpkg -s <pkg>` en apt; `paru -Q <pkg>` en Arch
   - Repos: guard de existencia antes de `add-apt-repository`
   - Mejora sobre el comportamiento de facto del gestor (que ya omite instalados) para salida consistente y checks verificables.

5. **Corregir instalación de `paru` en Arch puro**
   `sudo pacman -S --noconfirm paru` falla en Arch estándar (paru no está en repos oficiales). Instalación vía AUR (`git clone` + `makepkg -si` con `base-devel`) o habilitando chaotic-aur. En CachyOS paru ya viene preinstalado.

6. **Herramientas modernas (mise, devbox, starship)**
   - Arch: vía AUR en `PACKAGES_LINUX` (mise, devbox-bin, starship), instaladas en el bootstrap con paru
   - Ubuntu: `mise` vía PPA `ppa:jdxcode/mise` en `PACKAGES_APT_REPOS` + `PACKAGES_APT` (bootstrap); `devbox` y `starship` no tienen paquete apt → los instalan sus módulos zsh (`devbox::install` / `starship::install` vía `core::ensure`) en runtime, gracias al dispatch apt/paru de `core::internal::core::install` en `zsh/system/core/internal/linux.zsh`
   - Sin instaladores dedicados en `tools/`: la instalación de devbox/starship ya es responsabilidad de sus módulos zsh (patrón `core::ensure`)

7. **`change_shell` robusto**
   Asegurar que `zsh` esté en los paquetes instalados antes de `change_shell` (añadir `zsh` a `PACKAGES_COMMON`) para que el cambio de shell no falle en máquina limpia.

## Risks / Trade-offs

- [`pacman -S paru` falla en Arch puro] → Mitigación: instalación vía AUR/makepkg o chaotic-aur (decisión 5)
- [Scripts/instaladores upstream de tools modernas cambian o desaparecen] → Mitigación: preferir paquetes oficiales (AUR/repos apt) y solo instaladores dedicados con fallback a release pins
- [`add-apt-repository` requiere `software-properties-common`] → Mitigación: prereq explícito antes del paso de repos
- [Ejecución sin sudo falla] → Mitigación: verificación temprana de privilegios (`sudo -v`) con mensaje claro
- [`change_shell` antes de tener zsh] → Mitigación: `zsh` en `PACKAGES_COMMON` (decisión 7)
- [Diferencias Ubuntu vs Debian en repos] → Mitigación: selección por distro vía `/etc/os-release`
