# bootstrap-install

## Requirements

### REQ-BI-001: Script autocontenido y portable
- `install.sh` debe ejecutarse sin dependencias externas (solo bash POSIX).
- No debe importar ni depender de archivos de `zsh/core/` ni de ningún otro módulo del proyecto.
- Debe funcionar en macOS (Intel y Apple Silicon) y Linux.

### REQ-BI-002: Variables definidas y consistentes
- Toda variable debe ser declarada con `local` (dentro de funciones) o `readonly` (constantes).
- `APP_NAME` debe estar definido (no vacío).
- `GIT_BRANCH` debe estar definido (no vacío).
- `DOTFILES_REPO` debe estar definido.

### REQ-BI-003: Manejo de errores con salida controlada
- `exit` siempre debe recibir código numérico explícito (0 para éxito, 1+ para error).
- Errores críticos (brew no encontrado, git clone fallido, cd fallido) deben abortar con mensaje.
- Usar `set -euo pipefail` al inicio del script.
- Mensajes de error deben incluir nombre del paso fallido.

### REQ-BI-004: Sin dead code
- Funciones no utilizadas deben ser eliminadas (e.g., `message::warning`, `message::debug`, `check_config_and_bootstrap`).
- Variables no referenciadas deben ser eliminadas.
- Checks de plataforma obsoletos (e.g., `TRAVIS`, `CODESPACES`) deben ser eliminados a menos que tengan uso activo.
- Comentarios fantasma y estilo CSS legacy deben ser removidos.

### REQ-BI-005: Sistema de mensajes autocontenido
- Debe usar `printf` con prefijos ASCII legibles: `[OK]`, `[FAIL]`, `[SKIP]`, `[INFO]`, `[WARN]`.
- Sin dependencia de colores ANSI ni `tput` (no garantizados en pipe curl|bash).
- Los mensajes deben ser informativos y distinguibles entre éxito, fallo, omisión y advertencia.

### REQ-BI-006: Detección dinámica de brew
- `PATH` de brew debe detectarse en runtime, no hardcodearse.
- Soporte para `/opt/homebrew` (Apple Silicon) y `/usr/local` (Intel/Linux).
- Debe fallar con mensaje claro si brew no está instalado.

### REQ-BI-007: Mensajes de estado correctos
- Mensaje de éxito solo debe mostrarse tras operación exitosa.
- Mensaje de fallo debe corresponder al comando fallido (no genérico).
- No mostrar "installed successfully" si el clone/install falló.

### REQ-BI-008: Hardening de provision scripts
- `provision/script/run.sh` debe tener manejo de errores básico (exit on failure).
- Debe respetar `set -e` del caller.

### REQ-BI-009: Instalación con paru en Arch Linux
- En Linux SOLO se soporta Arch Linux. Cualquier otra distro debe abortar con mensaje de error.
- Debe usar `paru` como package manager (soporta AUR + oficiales).
- `paru` debe estar instalado antes de usarlo (instalarlo via `pacman -S --noconfirm paru` si no existe).
- Los packages de Linux deben incluir: `git`, `go`, `npm`, `yarn`, `gcc`, `rsync`.
- No mostrar mensaje de éxito si paru falló.
- Detectar distribución Arch-based via `/etc/os-release` — verificar `ID=arch` o `ID=cachyos` o `ID_LIKE=arch`. No solo `uname`.