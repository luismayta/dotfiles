## Context

El pipeline `provision/script/` es sourceado por `install.sh` después del clone. Corre en el mismo shell que `install.sh`, por lo que hereda `set -euo pipefail`. Actualmente contiene 8 bugs que impiden su funcionamiento correcto en macOS y CachyOS.

### Files afectados
- `provision/script/run.sh` (13 lines) — entry point
- `provision/script/bootstrap.sh` (62 lines) — env vars + OS detect
- `provision/script/functions.sh` (109 lines) — core functions
- `provision/script/messages.sh` (24 lines) — helper messages
- `provision/script/repo.sh` (27 lines) — **dead code, eliminar**
- `provision/script/config.sh` (10 lines) — **vars undefined, eliminar**
- `provision/script/config/base.sh` (19 lines) — keep
- `provision/script/config/osx.sh` (4 lines) — keep
- `provision/script/config/linux.sh` (5 lines) — keep

## Goals / Non-Goals

**Goals:**
- Arreglar los 8 bugs (B1-B8) en el pipeline provision/
- Eliminar `repo.sh` y `config.sh` (dead/duplicate code con bugs)
- `replace_files` debe funcionar en curl|bash (sin `read` bloqueante)
- Soporte solo macOS (brew) y CachyOS (paru)

**Non-Goals:**
- NO cambiar el sistema de mensajes de `install.sh` (ya está fixeado)
- NO refactorizar `tools/*/install.sh` (fuera de scope)
- NO añadir soporte para otras distros Linux
- NO migrar a zsh/core (no existe en bootstrap)

## Decisions

### D1: Eliminar `repo.sh` y `config.sh`
- **Por qué**: `repo.sh` duplica `clone_repo`/`upgrade_repo` de `install.sh` con variables undefined (`APP_NAME`). `config.sh` referencia vars que nunca se definen. Ambos son código muerto.
- **Alternativa**: Fixearlos. Pero añade complejidad innecesaria — `install.sh` ya maneja el clone/upgrade correctamente.
- **Decisión**: Eliminar ambos archivos. No sourcearlos desde `bootstrap.sh`.

### D2: `replace_files` sin `read` interactivo
- **Problema**: `read -r response` en curl|bash recibe EOF inmediato (stdin es el pipe). `initialize` nunca se ejecuta.
- **Opción A**: Usar variable de entorno `DOTFILES_YES=true` para saltar el prompt.
- **Opción B**: Siempre ejecutar `initialize` sin preguntar (comportamiento headless).
- **Decisión**: Opción A — por defecto preguntar si hay terminal (`-t 0`), si no, leer `DOTFILES_YES`. Si no hay terminal ni `DOTFILES_YES`, abortar con mensaje claro. Esto es seguro para curl|bash.

### D3: `dotfiles_install_factory` con paru
- **Problema**: Usa `type -p pacman` para detectar Arch, debe usar `paru`.
- **Decisión**: Cambiar a `type -p paru`. Si no existe paru pero existe pacman, instalarlo igual que en install.sh: `sudo pacman -S --noconfirm paru`.

### D4: `do_backup` con parámetro explícito
- **Problema**: Usa `$file` (variable del caller) sin definirla localmente. Con `set -u` crashea.
- **Decisión**: Recibir el filename como `$2` (el path original), derivar el backup name de ahí.

### D5: `${ret:-}` en mensajes
- **Problema**: `messages.sh:success()` y `debug()` usan `$ret` sin default. Con `set -u` crashean si el caller no tiene `ret`.
- **Decisión**: Usar `${ret:-0}` en todas las referencias a `ret` en mensajes.

## Risks / Trade-offs

- **R1: Eliminar repo.sh puede romper código externo** → No hay referencias externas. `install.sh` ya tiene su propio `clone_repo`/`upgrade_repo`.
- **R2: DOTFILES_YES es manual** → El usuario debe saber que existe. Alternativa: documentarlo en el mensaje de error. Trade-off deliberado para no sobreescribir archivos sin confirmación.
- **R3: `set -u` puede revelar bugs ocultos** → Es el objetivo: detectarlos temprano en desarrollo, no en producción.