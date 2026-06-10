## Context

`install.sh` es el script bootstrap principal que los usuarios ejecutan via `curl -fsSL https://raw.githubusercontent.com/luismayta/dotfiles/main/install.sh | bash`. Corre en un entorno limpio — sin `zsh/`, sin `core::*`, sin mensajes centralizados. Actualmente tiene 31 hallazgos: 8 bugs (variables undefined, exit sin código, mensajes post-fallo), 8 warnings (PATH hardcoded, brew/git failures silenciosos), 8 dead code items (funciones nunca llamadas, checks Travis, estilo obsoleto), 8 style issues, 7 maintenance issues.

El script llama a `provision/script/run.sh` como paso post-clone, que también necesita hardening.

## Goals / Non-Goals

**Goals:**
- Arreglar todos los bugs funcionales en `install.sh` (B1-B8 del análisis).
- Remover dead code confirmado (D1-D8).
- Hardening con `set -euo pipefail` y errores con mensaje + nombre.
- Soporte multi-plataforma (Linux/macOS) removiendo PATH hardcoded.
- Mantener autocontenido — sin dependencias de `zsh/core/` ni archivos no disponibles en curl|bash.
- Hardening básico de `provision/script/run.sh` para errores detectados.

**Non-Goals:**
- NO migrar sistema de mensajes a `zsh/core/` (inviable en curl|bash).
- NO refactor completo del provision flow.
- NO cambiar el contrato público (flags, argumentos, comportamiento esperado).
- NO tocar `ghq/internal/main.zsh:17` (guard con `> /dev/null`, excluido por semántica distinta).

## Decisions

### D1: `set -euo pipefail` como default
- **Opción**: Añadir al inicio con manejo explícito de comandos que pueden fallar (e.g., `brew info`, `git clone`).
- **Alternativa**: `set -e` solo (ub Menos seguro). No usar errexit (más verboso).
- **Decisión**: `set -euo pipefail` + wrappers con `|| true` para fallos esperados. Pipefail evita errores silenciosos en pipelines.

### D2: Variables con `local` o declaración explícita
- **Opción**: `local ret=0`, `local APP_NAME`, `local GIT_BRANCH` en cada función.
- **Alternativa**: Usar `readonly` para constantes.
- **Decisión**: `local` para mutables, `readonly` para constantes tipo `APP_NAME`, `DOTFILES_REPO` si se declaran dentro de funciones.

### D3: `exit` sin código → `return 1` o `exit 1`
- **Opción**: En funciones de validación usar `return 1`. En puntos de no-retorno usar `exit 1` con mensaje.
- **Alternativa**: Siempre `exit 1`.
- **Decisión**: `return 1` en helpers (pueden ser llamadas desde otros scripts), `exit 1` en el flujo principal.

### D4: Reemplazo del sistema de mensajes inline
- **Opción**: Simplificar a `echo`/`printf` con prefijos (`[OK]`, `[FAIL]`, `[SKIP]`, `[INFO]`) — sin colores ANSI en curl|bash (pueden no estar disponibles).
- **Alternativa**: Usar `tput` para colores (portable POSIX).
- **Decisión**: `printf` con prefijos ASCII. Sin colores para máxima compatibilidad en el pipe curl|bash.

### D5: Detección de brew multi-plataforma
- **Opción**: Detectar `/opt/homebrew/bin/brew` (Apple Silicon) y `/usr/local/bin/brew` (Intel/Linux) dinámicamente.
- **Alternativa**: Dejar que `brew` se resuelva del PATH (ya debería estar en PATH de login shell).
- **Decisión**: Detectar brew via `command -v brew` después de preparar PATH. NO hardcodear rutas.

### D6: paru como package manager en Arch Linux
- **Opción**: Usar `paru` (AUR helper) que wrappea pacman y soporta AUR.
- **Alternativa**: `pacman` directo (solo oficiales, sin AUR), `yay` (similar a paru).
- **Decisión**: `paru` por ser el estándar del usuario para Arch Linux. Si no existe, instalarlo primero con `pacman -S --noconfirm paru`. 
- **Detección**: No confiar en `uname` solo. Leer `/etc/os-release` y verificar `ID=arch`. Si no es Arch Linux → `exit 1` con mensaje "Unsupported Linux distribution. Only Arch Linux is supported."

### D7: Detección de distribución Linux (CachyOS / Arch)
- **Contexto**: La distro del usuario es CachyOS, que es Arch-based pero tiene `ID=cachyos` en `/etc/os-release`.
- **Opción**: Verificar `ID=arch` (solo Arch vanilla).
- **Alternativa**: Verificar `ID_LIKE=arch` (cubre cualquier Arch-based: CachyOS, EndeavourOS, Manjaro).
- **Decisión**: Verificar `ID=arch` OR `ID=cachyos` OR `ID_LIKE=arch`. Esto cubre Arch vanilla, CachyOS, y cualquier otra distro Arch-based.

## Risks / Trade-offs

- **R1: Riesgo de romper el flujo curl|bash en shells antiguos** → `set -euo pipefail` no está disponible en POSIX sh antiguo. Mitigación: Shebang `#!/usr/bin/env bash` explícito, no asumir `/bin/bash`.
- **R2: Eliminar dead code puede romper usos externos** → Ningún hallazgo de dead code tiene referencias en el repo. Bajo riesgo.
- **R3: Mensajes sin color se ven "feos"** → Trade-off deliberado: el pipe curl|bash no garantiza terminal interactiva. Los prefijos `[OK]/[FAIL]` son legibles en crudo.
- **R4: `exit 1` con errexit puede ocultar errores intermedios** → Mitigación: usar `trap` para imprimir mensaje antes de salir.

## Open Questions

- (ninguna — los hallazgos están claros y las decisiones son unívocas)
