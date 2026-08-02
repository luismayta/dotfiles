## Context

Tras la migración de antidote a `zsh/system` (6268d9eb) y el mover de `zsh/core/data` a `zsh/system/core` (34d2963c), `provision/script/` quedó como código huérfano. Su única referencia viva es `install.sh:269`, donde `exec bash "${PATH_REPO}/provision/script/run.sh"` arranca una cadena rota: `run.sh` (set -euo pipefail) → `bootstrap.sh` → `deploy_core_data` hace `rsync "${ZSH_PATH}/core/data/." "${HOME}/"`, pero `zsh/core/data/` ya no existe → cualquier instalación fresh (`curl|bash`, stdin no TTY) aborta ahí. En máquinas existentes con `~/.zshrc` presente el aborto no ocurre porque `initialize` no corre. El resto de piezas (`bootstrap.sh`, `functions.sh` con 8 funciones, `config/base|linux|osx` con 2 vacíos, `test.sh` que espera `PATH_RVM` inexistente) no tienen ninguna referencia de código vivo fuera del directorio.

La funcionalidad que otrora proveía ya está reimplementada en `bin/dotfiles::upgrade` (vía `zsh/system/core/main.zsh`) y en la carga de `zsh/zshrc`.

## Goals / Non-Goals

**Goals:**
- Eliminar por completo el directorio `provision/script/` y toda referencia viva a él.
- Preservar el comportamiento de instalación fresh que copia `zsh/zshrc` y `zsh/zshenv` a `$HOME` (hoy lo hace `deploy_configs` en `run.sh` antes de abortar).
- Dejar documentación del repo coherente (comentario de `config/packages.sh:4`).

**Non-Goals:**
- No tocar `bin/dotfiles::upgrade`, `zsh/system/`, `common/` ni el flujo de `install.sh` más allá del punto del `exec` de `run.sh`.
- No migrar/refactorizar ninguna pieza de `provision/script` hacia otro lugar.
- No corregir el rsync de `config/` → `~/.config/`/`Library` (ya roto hoy y fuera de alcance).

## Decisions

### Decisión 1: ELIMINAR el directorio completo, sin migrar piezas
`git rm -r provision/script` elimina las 6 entradas (`bootstrap.sh`, `run.sh`, `test.sh`, `config/`, `functions.sh`).

- **Racional**: cada pieza tiene un sucesor — deploy de zshrc/config → `bin/dotfiles::upgrade` y el loader de `zsh/system`; paths → `zsh/system/core/config/paths.zsh` (`LOCAL_PATH_BIN`, `DOTFILES_ZSH_PATH`); vars de `config/base.sh` → `DOTFILES_GIT_URI` / `DOTFILES_GIT_BRANCH` en `install.sh`.
- **Alternativa rechazada (a)**: reparar `run.sh` apuntando el rsync a `zsh/system/core/` → duplicaría `bin/dotfiles::upgrade` y añadiría superficie de mantenimiento para un camino que ya no se usa.

### Decisión 2: `install.sh:269` — copia directa de zshrc/zshenv en lugar del exec
Reemplazar `exec bash "${PATH_REPO}/provision/script/run.sh"` por `cp` de `zsh/zshrc` → `~/.zshrc` y `zsh/zshenv` → `~/.zshenv` (con `msg::success` si las funciones de mensajería están sourceadas; si no, `echo` simple).

- **Racional**: el flujo fresh (`curl|bash` → stdin no TTY → `replace_files` → `initialize` → `deploy_configs`) era quien copiaba `zshrc`/`zshenv` a `$HOME` antes de abortar en `deploy_core_data`. Sin esta copia, una instalación fresh arrancaría zsh con defaults y sin dotfiles.
- **Alternativa rechazada (b)**: no copiar nada y confiar en `bin/dotfiles::upgrade` manual post-install → degrada la UX de instalación fresh (zsh arrancaría sin dotfiles hasta el primer upgrade).

### Decisión 3: `config/packages.sh:4` — comentario actualizado
El comentario pasa de "Sourced by both install.sh (bootstrap) and provision scripts" a "Sourced by install.sh".

## Risks / Trade-offs

- **El fresh ya no ejecuta el rsync de `config/`** → `~/.config/` ni `Library` → ya está roto hoy (aborta antes en `deploy_core_data`); sin regresión funcional, mitiga además el aborto silencioso.
- **Cambio de comportamiento en install.sh** → cambio mínimo y localizado (un solo bloque `exec` → dos `cp`), revisable en diff.
- **Referencias restantes en docs/openspec** → son historial del cambio, no código vivo; se verifican con grep acotado en T4.
