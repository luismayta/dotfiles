## Why

El diagnóstico del `.terragrunt-cache` (no eliminado) demostró en producción el defecto del mecanismo de override actual: las variables `ZSH_CLEAN_BASE_DIR_PATTERNS`/`ZSH_CLEAN_BASE_FILE_PATTERNS` se exportan con guarda `:-`, y una export previa (stale-env, de una sesión iniciada antes de un cambio de patrones) queda **silenciosamente congelada** — el módulo carga la lista vieja y los patrones nuevos (`.terragrunt-cache`, `*.log`, etc.) no aplican. El usuario vio `cleanup` "funcionar" parcialmente (limpió `node_modules`, que está en ambas listas) sin que el patrón nuevo se activara. El fix manual (`unset && exec zsh`) es frágil: cualquier shell abierta antes de un pull reincide. Además, la convención actual de override ("re-exportar la variable completa antes de sourcear") hace que el usuario deba conocer y copiar la lista default completa — frágil y propenso a error. Este change introduce (1) un `unset` de los defaults al inicio del módulo para que SIEMPRE se carguen los del repo, y (2) variables de merge explícitas `ZSH_CLEAN_USER_*` como mecanismo de extensión de usuario, inmune al stale-env.

## What Changes

- **Unset anti-stale en `config/base.zsh`**: al inicio del módulo, `unset ZSH_CLEAN_BASE_DIR_PATTERNS ZSH_CLEAN_BASE_FILE_PATTERNS ZSH_CLEAN_AGGRESSIVE_PATTERNS` antes de las guardas — así los defaults del repo SIEMPRE aplican al cargar, y ninguna shell con exports viejas congela patrones obsoletos.
- **Nuevas variables de merge `ZSH_CLEAN_USER_DIR_PATTERNS` / `ZSH_CLEAN_USER_FILE_PATTERNS`** (default vacío): el usuario extiende los patrones default sin reemplazarlos ni conocer la lista completa.
- **`_cleanup::unnecessary` fusiona defaults + user** con dedupe por patrón (mismo mecanismo que tuvo `extra_dirs`).
- **Aliases legacy `CLEAN_*` preservados** (de la migración `migrate-clean-prefix`): el unset NO toca `CLEAN_*` legacy — el alias backward-compat sigue funcional.

## Capabilities

### New Capabilities
- `cleanup-user-patterns`: el usuario puede extender las listas de patrones de limpieza vía `ZSH_CLEAN_USER_DIR_PATTERNS` / `ZSH_CLEAN_USER_FILE_PATTERNS`, fusionadas con los defaults en tiempo de ejecución.

### Modified Capabilities
- `cleanup-configurability`: el mecanismo de override de patrones cambia — las variables base se re-calculan desde defaults del repo en cada carga (anti-stale), y la personalización de usuario pasa a las variables de merge `ZSH_CLEAN_USER_*`.
- `cleanup-core`: `_cleanup::unnecessary` consume defaults + user merge (no solo las variables base).

## Impact

- **Código afectado**: `zsh/modules/clean/config/base.zsh` (unset inicial + 2 vars nuevas), `zsh/modules/clean/internal/base.zsh` (`_cleanup::unnecessary` merge), `zsh/modules/clean/pkg/base.zsh` (`cleanup::help` documenta `ZSH_CLEAN_USER_*`).
- **Compatibilidad**: `CLEAN_*` legacy intactos (alias de la migración previa). Cualquier usuario que hoy re-exporte `CLEAN_BASE_DIR_PATTERNS` con la lista completa pierde ese mecanismo — reemplazado por `ZSH_CLEAN_USER_*` (documentado en el spec delta).
- **Riesgo**: cambio de contrato para overrides existentes de patrones; mitigado porque el diagnóstico confirmó 0 overrides en el repo y el único consumo real era el stale-env.
