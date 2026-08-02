## Why

`provision/script/` es código huérfano tras la migración de antidote a zsh/system (commit 6268d9eb). El único punto vivo es `install.sh:269` (`exec bash "${PATH_REPO}/provision/script/run.sh"`), pero esa cadena está rota: `run.sh` (set -euo pipefail) → `bootstrap.sh` define `ZSH_PATH=${PATH_REPO}/zsh` → `deploy_core_data` hace `rsync "${ZSH_PATH}/core/data/." "${HOME}/"` y `zsh/core/data/` ya no existe (migró a `zsh/system/core` en 34d2963c) → toda instalación fresh vía `curl|bash` aborta ahí (en máquinas existentes con `~/.zshrc` presente no se aborta porque `initialize` no corre). `bootstrap.sh`, `functions.sh` (8 funciones), `config/` (base/linux/osx, 2 vacíos) y `test.sh` tienen 0 referencias de código vivo fuera del directorio; `test.sh` espera `PATH_RVM` que ya no existe.

Por qué ahora: la migración de antidote eliminó el loop de tools y dejó `provision/script` como cascarón; su funcionalidad ya está reimplementada en `bin/dotfiles::upgrade` (vía `zsh/system/core/main.zsh`) y en la carga de `zsh/zshrc`.

## What Changes

- **BREAKING**: Eliminar el directorio `provision/script/` completo (`bootstrap.sh`, `run.sh`, `test.sh`, `config/`, `functions.sh`).
- En `install.sh:269`: reemplazar el `exec` de `run.sh` por copia directa de `zsh/zshrc` y `zsh/zshenv` a `$HOME` (preservar el comportamiento fresh que hoy hace `deploy_configs` ANTES del aborto).
- Actualizar el comentario obsoleto de `config/packages.sh:4` ("Sourced by both install.sh (bootstrap) and provision scripts" → "Sourced by install.sh").

## Capabilities

### New Capabilities
- `provision-script-removal`: Elimina el directorio `provision/script/`, remueve toda referencia a él en `install.sh` y `config/packages.sh`, y preserva la copia de `zsh/zshrc` + `zsh/zshenv` a `$HOME` durante la instalación fresh.

### Modified Capabilities
<!-- Sin cambios de requisitos a nivel spec existentes: es remoción de código huérfano, no un cambio de comportamiento especificado en openspec/specs/ -->

## Impact

- **Código eliminado**: `provision/script/{bootstrap.sh,run.sh,test.sh,config/,functions.sh}` (6 entradas).
- **Código modificado**: `install.sh` (punto del exec de run.sh, línea ~269), `config/packages.sh` (comentario línea 4).
- **NO se toca**: `bin/dotfiles::upgrade`, `zsh/system/`, `common/`, ni el flujo de `install.sh` más allá del punto del exec.
- **Riesgo conocido**: el fresh ya no ejecuta el rsync de `config/` → `~/.config/` ni `Library` (ya roto hoy; sin regresión funcional).
- **Sistema afectado**: instalación fresh de dotfiles vía `curl|bash`.
