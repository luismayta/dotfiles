## Context

`zsh/zshrc` es el entry point de la configuración zsh, sourceado desde `~/.zshrc`. Este archivo define paths, carga el core system (`zsh/core/`), modules (`zsh/modules/`), y plugins via antidote.

Auditoría actual reveló 6 bugs que impiden la carga correcta:

1. `DOTFILES_MOD_DIR` apunta a `zsh/mod/` que no existe (el directorio real es `zsh/core/`)
2. Core nunca se carga → `CUSTOMRC`, `path::clean`, `core::install` no disponibles
3. `type -p path::clean` no detecta funciones zsh (solo busca en PATH)
4. `FPATH` asignado con valor de `PATH` en vez de limpiar `FPATH`
5. Shebang `#!/usr/bin/env ksh` en vez de `zsh`
6. Sin completions (`compinit`) en Linux

El core system (`zsh/core/main.zsh`) carga `config/`, `internal/`, y `pkg/` — donde se definen variables de entorno (`CUSTOMRC`, `DOTFILES_BACKUP_DIR`, etc.) y funciones (`path::clean`, `core::install`, etc.).

## Goals / Non-Goals

**Goals:**
- `zsh/zshrc` carga correctamente en Arch Linux (CachyOS) y macOS
- `zsh/core/main.zsh` se sourcea correctamente desde `zsh/zshrc`
- `path::clean`, `CUSTOMRC`, y `core::*` disponibles en runtime
- Completions funcionales en Linux
- Compatibilidad con `set -u` (no unbound variables)

**Non-Goals:**
- Refactor de `zsh/core/` internals (no se toca su estructura)
- Cambios en `zsh/modules/` (cada módulo se carga via plugin.zsh y funciona)
- Migración de usuarios existentes (backward compat vía `DOTFILES_MOD_DIR` como alias)

## Decisions

### D1: DOTFILES_CORE_DIR reemplaza DOTFILES_MOD_DIR
- **Opción A** (elegida): Nueva variable `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"`. Clara, semántica, el directorio se llama `core/`.
- **Opción B**: Renombrar `mod/` a `core/`. Riesgo de romper referencias externas al path.
- **Opción C**: Crear un symlink `mod/` → `core/`. Workaround, no soluciona la raíz.
- **Decisión**: `DOTFILES_CORE_DIR`. Se exporta en `zsh/core/config/paths.zsh` y se usa en `zshrc`.

### D2: (( $+functions[path::clean] )) en vez de type -p
- **Problema**: `type -p` busca en PATH (binarios). `path::clean` es función zsh.
- **Opción A** (elegida): `(( $+functions[path::clean] ))` — sintaxis zsh nativa para检测 funciones cargadas.
- **Opción B**: `functions path::clean &>/dev/null`. Funciona pero más verboso.
- **Opción C**: `whence -w path::clean`. Estándar pero menos conocido.

### D3: CUSTOMRC con fallback en zshrc
- **Problema**: `CUSTOMRC` se define en `zsh/core/config/paths.zsh`, que no se cargaba porque core no cargaba. Circular dependency.
- **Decisión**: Mantener `CUSTOMRC` en paths.zsh (única fuente de verdad), pero agregar fallback en `zshrc` antes del source: `${CUSTOMRC:-${HOME}/.customrc}`.

## Risks / Trade-offs

- **[Backward compat]**: Usuarios existentes que referencian `DOTFILES_MOD_DIR` en custom configs podrían romperse. **Mitigación**: Exportar `DOTFILES_MOD_DIR` como alias de `DOTFILES_CORE_DIR` en paths.zsh por un periodo de transición.
- **[FPATH corruption]**: El bug actual asigna `PATH` a `FPATH`. Al corregirlo, FPATH recupera su valor real de zsh (rutas de funciones). Esto podría exponer functions que antes no se encontraban. **Mitigación**: Es el comportamiento correcto; cualquier función ahora detectable antes no lo era por el bug.