## Context

El dotfiles provisioning system tiene dos fases: **bootstrap** (`install.sh`) y **provision** (`provision/script/`). Actualmente comparten lógica mediante duplicación — `detect::os` existe en ambos lados, `program_exists` tiene dos implementaciones que divergen, y hay dos sistemas de mensajería incompatibles (`message::info/success/error` vs `msg/success/error`).

El handoff entre fases usa 4 niveles de sourcing implícito:
`install.sh → source run.sh → source bootstrap.sh → source messages.sh + functions.sh`

No hay interfaz explícita entre capas. Si un source falla, el error es silencioso y difícil de debuggear.

El refactor `refactor-install-flow` (completado) mejoró `install.sh`, pero dejó intacto `provision/script/` y las duplicaciones entre ambos.

## Goals / Non-Goals

**Goals:**
- Crear un directorio `lib/` con funciones compartidas (detect::os, program_exists, change_shell, messaging) sourceable desde cualquier script
- Eliminar toda duplicación entre `install.sh` y `provision/script/`
- Hacer declarativa la lista de paquetes en `config/packages.sh`
- Reemplazar el handoff `source` por `exec bash` con contexto explícito vía env vars
- Split de `initialize()` en funciones con responsabilidad única
- Eliminar código muerto y corregir inseguridades identificadas

**Non-Goals:**
- NO cambiar la lógica de negocio de instalación (qué paquetes se instalan, cómo se configura zsh, etc.)
- NO migrar a otro lenguaje o framework
- NO cambiar la estructura de `tools/` individuales (antidote)
- NO refactorizar `install.sh` más allá de remover duplicación y mover `ZSH_PATH`

## Decisions

### D1: Shared Library en `lib/` (no en `provision/lib/`)

Las funciones compartidas sirven a bootstrap Y provision — el directorio debe estar en la raíz del repo, no dentro de `provision/`.

**Estructura:**
```
lib/
├── common.sh     # detect::os, program_exists, change_shell
├── messages.sh   # msg::info, msg::success, msg::error, msg::warn
└── colors.sh     # ANSI color constants
```

**Alternativa considerada:** Ponerlo en `provision/lib/` — descartado porque `install.sh` desde la raíz tendría que hacer `source provision/lib/common.sh`, lo cual es confuso conceptualmente. `lib/` en raíz es simétrico para ambos.

### D2: Namespace `msg::` para mensajería

En lugar de `message::info` (install.sh) o `info`/`success` (messages.sh), unificar bajo `msg::info`, `msg::success`, `msg::error`, `msg::warn`.

**Contrato:**
- `msg::*` solo imprimen (nunca hacen `exit`)
- Quien llama decide si continuar o salir después del mensaje
- Consistente con el principio de *single responsibility* (print ≠ control flow)

**Alternativa considerada:** Mantener los namespaces separados — descartado porque el objetivo es precisamente eliminar la duplicación.

### D3: `change_shell` como función compartida

Extraer `chsh -s "${ZSH_PATH}" "${USER}"` a `change_shell()` en `lib/common.sh`. Usada desde `setup::mac` y `setup::linux`.

**Condición:** `change_shell` ejecuta `chsh` solo si `$SHELL != $ZSH_PATH` (idempotente, heredado del refactor anterior).

### D4: Handoff vía `exec bash` en lugar de `source`

Cambiar `source "${PATH_REPO}/provision/script/run.sh"` por:
```bash
export DOTFILES_ROOT="${PATH_REPO}"
export DOTFILES_OS
DOTFILES_OS=$(detect::os)
exec bash "${PATH_REPO}/provision/script/run.sh"
```

**Por qué:**
- Cada fase corre en su propio shell — sin leakage de variables/funciones
- Si provision falla, no arrastra el shell de bootstrap
- `exec` reemplaza el proceso actual (no deja procesos zombies)

**Alternativa considerada:** Seguir con `source` pero documentar la interfaz — descartado porque `exec bash` es más robusto y elimina el acoplamiento implícito.

### D5: Paquetes declarativos en `config/packages.sh`

```bash
PACKAGES_COMMON=(zsh git rsync ksh fd)
PACKAGES_MAC=(brew-core-packages...)
PACKAGES_LINUX=(paru-packages...)
```

Las funciones `setup::mac::packages` y `setup::linux::packages` itera estos arrays. `setup::packages::common` se renombra a `setup::packages::ensure_common` y se simplifica.

### D6: `BASH_SOURCE[0]` para rutas estructurales

En `bootstrap.sh`, reemplazar:
```bash
ROOT_DIR=$(pwd)
```
por:
```bash
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
```

Esto asegura que las rutas son correctas sin importar desde dónde se invoque el script.

### D7: Fail loud en sourcing

Reemplazar sourcing condicional silencioso:
```bash
[ -r "${file}" ] && source "${file}"
```
por:
```bash
[ -r "${file}" ] || { echo "FATAL: ${file} not found" >&2; exit 1; }
source "${file}"
```

## Risks / Trade-offs

| Riesgo | Mitigación |
|--------|------------|
| **R1: `exec bash` cambia el comportamiento si provision espera variables del shell padre** | Exportar explícitamente `DOTFILES_ROOT` y `DOTFILES_OS` antes del exec. Provision ya se inicializa con `bootstrap.sh` que setea sus propias vars |
| **R2: Mover `ZSH_PATH` a después de instalar paquetes puede requerir re-evaluación** | La variable se asigna justo después de `setup::packages::common` y antes de `setup::nix` y `chsh` |
| **R3: Renombrar funciones de messaging puede romper código no cubierto por tests** | Solo hay dos consumers: `install.sh` y `provision/script/`. Ambos se actualizan en el mismo cambio. No hay API externa |
| **R4: `lib/` introduce una dependencia adicional en el path de sourcing** | bootstrap.sh y install.sh sourcean `lib/` al inicio. Si falta, fail loud (D7) |

## Migration Plan

1. Crear `lib/common.sh`, `lib/messages.sh`, `lib/colors.sh`
2. Actualizar `install.sh` para sourcear `lib/` y remover duplicación
3. Actualizar `provision/script/bootstrap.sh` para sourcear `lib/` y remover duplicación
4. Actualizar `provision/script/functions.sh` y `messages.sh` para usar `lib/`
5. Cambiar handoff a `exec bash`
6. Crear `config/packages.sh` y refactorizar funciones de instalación
7. Corregir `ZSH_PATH`, `printf`, `>>/dev/null`, `HOME=~`, `die()`
8. Shellcheck + `bash -n` en todos los archivos modificados

Rollback: `git checkout` del commit anterior — todos los cambios son atómicos en un solo commit.

## Open Questions

*(ninguna — todas las decisiones están resueltas en este documento)*
