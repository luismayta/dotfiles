## Why

`cleanup` ya opera correctamente sobre el pwd según la configuración (verificado empíricamente), pero la auditoría de seguimiento (KenThompson, post `harden-clean-safety`) confirmó dos brechas de seguridad residuales: (1) ejecutar `cleanup` desde `$HOME` borraría caches reales (`~/.cache`, `~/.npm`, `~/.cargo`, `~/.gradle`, `.tmp`) porque esos nombres siguen en `CLEAN_BASE_DIR_PATTERNS` y no hay ningún guard contra `$PWD == $HOME`; (2) `_cleanup::safe_find_delete` borra archivos (`*.log`, `*.pyc`, `*.tmp`, `.DS_Store`) con `-delete` directo sin confirmación, rompiendo el contrato que `harden-clean-safety` estableció para `safe_remove` y `safe_find_remove`.

## What Changes

- **Guard de `$HOME` en `cleanup`**: antes de ejecutar la limpieza del árbol, si `$PWD == $HOME` el módulo aborta con un mensaje claro (y sugerencia de usar `cleanup::all` o un directorio de proyecto). El guard cubre `cleanup`, `cleanup::all` y `cleanup::projects` (que hace `cd` a `$PROJECTS`).
- **Confirmación en `_cleanup::safe_find_delete`**: el borrado de archivos pasa por el mismo contrato que `safe_remove`/`safe_find_remove` — dry-run reporta, `needs_confirmation` confirma con el path/patrón, y solo entonces `-delete`.
- **Documentación del guard en `cleanup::help`**: la advertencia de no ejecutar desde `$HOME` pasa de texto suelto a comportamiento real.

## Capabilities

### New Capabilities
- `cleanup-home-guard`: el módulo rechaza limpiar el árbol cuando el directorio actual es `$HOME`, evitando borrados destructivos de caches personales.

### Modified Capabilities
- `cleanup-safety`: la confirmación pasa a aplicarse también al borrado de archivos por patrón (`safe_find_delete`), cerrando la última ruta de borrado sin prompt.

## Impact

- **Código afectado**: `zsh/modules/clean/pkg/base.zsh` (`cleanup`, `cleanup::all`, `cleanup::projects` — guard), `zsh/modules/clean/internal/base.zsh` (`_cleanup::safe_find_delete` — confirmación), `cleanup::help` (documentación).
- **Comportamiento**: `cleanup` desde `$HOME` no ejecuta la limpieza del árbol (aborta con aviso); archivos por patrón piden confirmación por defecto.
- **Compatibilidad**: ningún cambio de API; los flags `CLEAN_DRY_RUN` / `CLEAN_CONFIRM` / `CLEAN_FORCE` siguen gobernando el flujo. El guard es omitible con `CLEAN_FORCE=true` (override explícito del usuario).
- **Riesgo residual**: usuarios que sí quieran limpiar desde `$HOME` deben usar `CLEAN_FORCE=true` o `cleanup::all` (que limpia caches con confirmación individual).
