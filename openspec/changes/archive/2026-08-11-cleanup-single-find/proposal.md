## Why

`cleanup` ejecuta un `find` por patrón y pide confirmación por grupo: con ~40 patrones de directorios y ~10 de archivos, una sola pasada lanza decenas de invocaciones de `find` y decenas de prompts `[y/N]`. La limpieza es correcta pero lenta y tediosa de confirmar.

## What Changes

- `_cleanup::unnecessary` consolida todos los patrones (dir + file, base + user) en **una sola invocación de `find`** con una expresión combinada (`-name a -o -name b ...`) en lugar de un `find` por patrón.
- El barrido de directorios y el de archivos se ejecutan cada uno con un **único `find`** y una **única confirmación** que reporta los grupos afectados.
- Se preserva la semántica de borrado actual (mismo conjunto de patrones, mismos flags `-exec rm -rf {} +` / `-delete`), el `guard_home`, dry-run, verbose y `ZSH_CLEAN_FORCE`.
- Sin cambios en `config/base.zsh`: los patrones y su merge (`ZSH_CLEAN_BASE_*` + `ZSH_CLEAN_USER_*`) se mantienen intactos.

## Capabilities

### New Capabilities

- *ninguna*

### Modified Capabilities

- `cleanup-core`: la ejecución consolidada de patrones pasa de un `find` por patrón a un único `find` con expresión combinada — refuerza el requirement "Consolidated cleanup functions" y su escenario "No duplicate pattern matching" (cero comandos `find` redundantes).
- `cleanup-confirmation`: el barrido por patrones solicita una única confirmación consolidada (con detalle de grupos afectados) en lugar de un prompt por patrón; dry-run, force y confirm-disabled siguen aplicando igual.

## Impact

- `zsh/modules/clean/internal/base.zsh` — `_cleanup::unnecessary` (orquestación consolidada) y helpers `_cleanup::safe_find_remove` / `_cleanup::safe_find_delete` (construcción de la expresión combinada y mensajes con detalle de grupos).
- `zsh/modules/clean/pkg/base.zsh` — `cleanup` sin cambios funcionales (wrapper intacto).
- `zsh/modules/clean/config/base.zsh` — sin cambios.
- README.yaml/README.md — actualización de la descripción del flujo de confirmación si describe el prompt por patrón.
- Sin dependencias nuevas; solo `find` estándar POSIX/GNU (ya requerido).
