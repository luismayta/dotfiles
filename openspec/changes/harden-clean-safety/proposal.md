## Why

La auditoría del módulo `clean` (RobertMartin, tras `extend-clean-patterns`) detectó tres riesgos de seguridad/datos de severidad alta: (1) `CLEAN_CONFIRM` se ignora en `_cleanup::safe_remove` — el borrado de caches (`cleanup::pip`, `cargo`, `bun`, `pnpm`, `brew`, `virtualenvs`, `system::*`) hace `rm -rf` sin confirmar, contradiciendo el contrato del header; (2) `cleanup::python::pyenv` borra intérpretes completos (`~/.pyenv/versions`) y está dentro de `cleanup::all`; (3) los patrones genéricos recién añadidos (`build`, `dist`, `target`, `tmp`, `vendor`, etc.) se matchean a cualquier profundidad — `cleanup` desde `$HOME` borraría `~/.cache`, `~/.npm`, `~/.cargo`, `~/.gradle`, `~/.terraform`.

## What Changes

- **Confirmación universal en borrado de caches**: `_cleanup::safe_remove` respeta `CLEAN_CONFIRM` / `CLEAN_FORCE` / `CLEAN_DRY_RUN` igual que `_cleanup::safe_find_remove` — el 100% de las rutas de borrado pasan por confirmación.
- **`cleanup::python::pyenv` fuera de la ruta destructiva**: se elimina de `cleanup::all` (o se convierte en operación no destructiva tipo dry-run/informativa).
- **Patrones genéricos como lista opt-in**: `build`, `dist`, `out`, `release`, `debug`, `target`, `vendor`, `tmp`, `temp`, `coverage`, `eggs`, `venv` se extraen de `CLEAN_BASE_DIR_PATTERNS` a una variable separada `CLEAN_AGGRESSIVE_PATTERNS` (vacía por defecto) que el usuario activa explícitamente.
- **Correcciones de clasificación**: `coverage.out` pasa a `CLEAN_BASE_FILE_PATTERNS` (es un archivo Go); se eliminan patrones muertos (`docs/_build/`, `.vuepress/dist` con `/` que `find -name` nunca matchea); se aclara `env.back`.
- **Redundancia eliminada**: `.terraform` y `.task` se quitan de `CLEAN_BASE_DIR_PATTERNS` (ya tienen funciones dedicadas `cleanup::terraform`, `cleanup::tasks`), evitando doble barrido y doble prompt.
- **Header honesto**: el comentario de override en `config/base.zsh` se alinea con las variables que realmente tienen guarda `:-`.

## Capabilities

### New Capabilities
- `cleanup-aggressive-patterns`: lista opt-in de patrones de borrado agresivo (nombres genéricos) que el usuario activa explícitamente, excluida de la limpieza por defecto.
- `cleanup-confirmation`: contrato de confirmación universal — todo borrado destructivo respeta `CLEAN_CONFIRM` / `CLEAN_FORCE` / `CLEAN_DRY_RUN`.

### Modified Capabilities
- `cleanup-safety`: la confirmación pasa a aplicarse a TODAS las rutas de borrado (antes solo a `safe_find_remove`); `cleanup::python::pyenv` deja de ser destructivo dentro de `cleanup::all`.
- `cleanup-patterns`: la lista por defecto excluye los nombres genéricos (movidos a opt-in), corrige la clasificación de `coverage.out` y elimina patrones muertos.
- `cleanup-core`: `.terraform` y `.task` ya no se barren dos veces (dedupe con funciones dedicadas).

## Impact

- **Código afectado**: `zsh/modules/clean/config/base.zsh` (nueva `CLEAN_AGGRESSIVE_PATTERNS`, limpieza de lista, header), `zsh/modules/clean/internal/base.zsh` (`_cleanup::safe_remove` con confirmación, `_cleanup::unnecessary` consume lista opt-in), `zsh/modules/clean/pkg/base.zsh` (`cleanup::all` sin pyenv destructivo, dedupe terraform/tasks).
- **Comportamiento**: `cleanup`/`cleanup::all` piden confirmación en todas las rutas por defecto; los nombres genéricos ya no se limpian salvo opt-in explícito; `cleanup::python::pyenv` deja de borrar intérpretes.
- **Riesgo residual**: ninguna operación destructiva sin confirmación previa; usuarios que dependan de la limpieza de `build/`/`dist/` deben activar `CLEAN_AGGRESSIVE_PATTERNS`.
- **Configuración**: nueva variable documentada `CLEAN_AGGRESSIVE_PATTERNS` (default vacío); sin cambios en la API pública de funciones.
