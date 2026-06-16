## Context

El módulo `zsh/modules/devops` fue escrito como un módulo independiente con sus propias constantes y helpers, antes de que `zsh/core` madurara como capa base. Hoy `zsh/core` provee:

- `$EDITOR` (definido en `config/env.zsh` con fallback a `nvim`)
- `$LOCAL_PATH_BIN` (`${HOME}/.local/bin`)
- Funciones `path::append`/`path::prepend` (en `internal/path.zsh`)
- Funciones `message_info`, `message_warning`, `message_error`, `message_success` (en `pkg/base.zsh` → `internal/api.zsh`)
- `core::ensure`, `core::exists`, `core::install` para gestión de paquetes

El módulo devops ya usa `message_*`, `core::ensure`, `core::exists`, `core::install` de core, lo que confirma que la dependencia existe. El problema son las variables que devops declara por su cuenta solapándose con las de core.

## Goals / Non-Goals

**Goals:**
- Eliminar toda variable en `zsh/modules/devops` que tenga un equivalente directo en `zsh/core`
- Reemplazar manipulaciones manuales de `PATH` por `path::append`/`path::prepend`
- Unificar el editor usado por kubectl y k9s a `$EDITOR`
- Renombrar/prefijar variables internas que no se exportan para claridad

**Non-Goals:**
- NO cambiar la estructura general del módulo (config/internal/pkg se mantiene)
- NO modificar el comportamiento de `plugin.zsh` ni la carga del módulo
- NO tocar `zsh/core` — todos los cambios son en devops
- NO migrar a otro gestor de paquetes

## Decisions

### 1. `DEVOPS_KUBECTL_KUBE_EDITOR` → `$EDITOR`
- **Decisión**: Eliminar `DEVOPS_KUBECTL_KUBE_EDITOR="vim"`. Donde se necesite el editor (`editk9s`), usar `$EDITOR`.
- **Rationale**: Core ya define `EDITOR` con fallback a `nvim`. Tener un editor separado para kubectl crea confusión y desactualización (core usa nvim, devops tenía vim).
- **Alternativa considerada**: Mantener la variable pero darle valor `$EDITOR`. Descartado porque añade indirección innecesaria.

### 2. `DEVOPS_KUBECTL_LOCAL_PATH_BIN` → `LOCAL_PATH_BIN`
- **Decisión**: Eliminar `DEVOPS_KUBECTL_LOCAL_PATH_BIN="/usr/local/bin"`. No hay referencias a esta variable fuera de su declaración.
- **Rationale**: `LOCAL_PATH_BIN="${HOME}/.local/bin"` en core cubre el path estándar para binarios locales.

### 3. `DEVOPS_ARCHITECTURE_NAME` → derivar inline
- **Decisión**: Eliminar variable. Donde se necesite, usar `$(uname -m)`.
- **Rationale**: Solo se usa en `DEVOPS_ARCHITECTURE_NAME="darwin-${ARCH_NAME}"` y `"linux-${ARCH_NAME}"`, y `ARCH_NAME` no está definido en ningún lado del códigobase — es una variable externa del sistema.

### 4. `DEVOPS_APPLICATION_PATH` → eliminar
- **Decisión**: Eliminar `DEVOPS_APPLICATION_PATH="/Applications"`. No tiene referencias en el módulo.
- **Rationale**: Código muerto.

### 5. Manipulación manual de `PATH` → `path::append`
- **Decisión**: En `internal/tfenv.zsh` y `internal/kubectl.zsh`, reemplazar `export PATH="${PATH}:..."` por `path::append "..."` y `[ -e "..." ] && export PATH="...:${PATH}"` por `path::prepend "..."`.
- **Rationale**: Consistencia con el resto del dotfiles y manejo más limpio (ya existe `path::append`/`path::prepend` en core).

### 6. Ausencia de guard de idempotencia en `config/base.zsh`
- **Decisión**: No tocar — `plugin.zsh` ya tiene el guard `__ZSH_DEVOPS_LOADED`.
- **Rationale**: El guard a nivel de plugin es suficiente.

## Risks / Trade-offs

- **[Bajo] Cambio de `vim` a `$EDITOR` (nvim)**: Si alguien tenía `EDITOR=vim` explícito, no hay cambio. Si confiaba en `DEVOPS_KUBECTL_KUBE_EDITOR=vim` porque `$EDITOR` no estaba definido, ahora usará `nvim`. **Mitigación**: Core define `: "${EDITOR:=nvim}"`, así que siempre hay fallback. El cambio es hacia adelante.
- **[Bajo] Paths**: `LOCAL_PATH_BIN` apunta a `~/.local/bin` mientras `DEVOPS_KUBECTL_LOCAL_PATH_BIN` apuntaba a `/usr/local/bin`. Si algún flujo dependía de `/usr/local/bin`, podría romperse. **Mitigación**: La variable no se referencia en ningún lado del módulo; es código muerto.
- **[Medio] Riesgo de regression en PATH**: Cambiar `export PATH="${PATH}:${DEVOPS_TFENV_ROOT_BIN}"` a `path::append "${DEVOPS_TFENV_ROOT_BIN}"` es semánticamente idéntico. **Mitigación**: Verificar que `path::append` existe en core y hace lo mismo (sí: `[ -e "${1}" ] && export PATH="${PATH}:${1}"`).
