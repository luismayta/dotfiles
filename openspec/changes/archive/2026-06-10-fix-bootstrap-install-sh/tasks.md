## 1. Variables y headers

- [x] 1.1 Declarar `readonly APP_NAME="dotfiles"`, `readonly DOTFILES_REPO="luismayta/dotfiles"`, `readonly GIT_BRANCH="main"` como constantes globales
- [x] 1.2 Añadir `set -euo pipefail` después del shebang
- [x] 1.3 Convertir `ret`, `program`, `src` a `local` dentro de sus respectivas funciones
- [x] 1.4 Eliminar `build_script`, `install_dotfiles`, `install_zsh_plug`, `ask_for_brew` obsoletos o unificarlos con funciones activas

## 2. Sistema de mensajes

- [x] 2.1 Reemplazar funciones `message::*` inline con `printf` basado en prefijos: `ok`, `fail`, `skip`, `info`, `warn`
- [x] 2.2 Homogeneizar estilo: `ok` usa `[OK]`, `fail` usa `[FAIL]`, `skip` usa `[SKIP]`, `info` usa `[INFO]`, `warn` usa `[WARN]`
- [x] 2.3 Eliminar `message::warning` (nunca llamada) y `message::debug` (nunca llamada)

## 3. Manejo de errores

- [x] 3.1 Reemplazar `exit` sin argumento con `exit 1` en checks de programa no encontrado
- [x] 3.2 Reemplazar `exit` sin argumento con `return 1` en helpers de validación
- [x] 3.3 Añadir chequeo explícito de salida tras `git clone` y no mostrar "installation completed successfully" si falló
- [x] 3.4 Añadir `|| exit 1` con mensaje en `cd "${src}"` y otros comandos críticos
- [x] 3.5 Añadir trap para mensaje de error genérico: `trap 'fail "bootstrap failed at line $LINENO"' ERR`

## 4. Detección de brew multi-plataforma

- [x] 4.1 Reemplazar `PATH="/opt/homebrew/bin:$PATH"` hardcoded con detección dinámica
- [x] 4.2 Fallar con mensaje claro si brew no está instalado
- [x] 4.3 Verificar que el ubicado brew funciona correctamente

## 5. Linux con paru (Arch Linux)

- [x] 5.1 Reemplazar `setup::linux`: detectar `paru` primero, instalarlo con `pacman -S --noconfirm paru` si no existe
- [x] 5.2 Usar `paru -S --noconfirm` en lugar de `sudo pacman -S --noconfirm`
- [x] 5.3 Package list: `git go npm yarn gcc rsync`
- [x] 5.4 Mantener `npm install -g n` después de instalar paquetes
- [x] 5.5 Detectar distribución Arch-based via `/etc/os-release` — verificar `ID=arch` OR `ID=cachyos` OR `ID_LIKE=arch`
- [x] 5.6 Si no es Arch Linux → `exit 1` con mensaje "Unsupported Linux distribution"

## 6. Dead code removal

- [x] 6.1 Eliminar función `check_config_and_bootstrap` (obsoleta, no llamada)
- [x] 6.2 Eliminar variables y checks de `TRAVIS`, `CODESPACES` si no tienen uso activo
- [x] 6.3 Eliminar comentarios fantasma (líneas con # sin propósito)
- [x] 6.4 Eliminar referencias a `install_zsh_plug` y `install_dotfiles` si están muertas

## 7. Hardening de provision scripts

- [x] 7.1 Añadir `set -euo pipefail` o al menos `set -e` en `provision/script/run.sh`
- [x] 7.2 Verificar que `provision/script/run.sh` no use variables undefined
