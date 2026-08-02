## Why

El módulo `clean` es el peor infractor de la convención de naming del repo: 1 de 49 variables exportadas usa el prefijo `ZSH_<NAME>_` que exige `docs/guides/create-module.md` (Secciones 3 y 8). RobertMartin auditó la migración y confirmó: la dirección es correcta (48/49 vars no conformes), pero eliminar backward compatibility **rompería silenciosamente** el flujo interactivo del usuario — el historial de shell muestra manipulación directa de `CLEAN_BASE_DIR_PATTERNS`/`CLEAN_BASE_FILE_PATTERNS` (`unset` + `exec zsh`), 13 vars `CLEAN_*` viven exportadas en el entorno actual, y hay 26 invocaciones de `cleanup` registradas. El inventario muestra 0 consumidores runtime fuera del módulo (168 refs son documentales), pero la pérdida silenciosa de configuración es el peor modo de fallo para un repo de dotfiles. La convención escrita del repo (guía Sección 3, líneas 235-247) **ordena** alias backward-compat al renombrar vars, con precedente canónico en `zsh/modules/herdr/`.

## What Changes

- **Renombrar las 49 exports** `CLEAN_*` → `ZSH_CLEAN_*` en `config/base.zsh`, `config/linux.zsh`, `config/osx.zsh` e `internal/base.zsh:5-8` (flags `CLEAN_DRY_RUN/CONFIRM/VERBOSE/FORCE`).
- **Aliases backward-compat obligatorios** para toda la superficie pública: `export CLEAN_X="${ZSH_CLEAN_X}"` (patrón herdr, comentario "remove in next cleanup cycle"). Sin alias solo para `CLEAN_PATH` → `ZSH_CLEAN_PATH` (0 refs externas).
- **NO renombrar funciones**: `cleanup::` y `_cleanup::` quedan como contrato (spec `cleanup-core`), con 26 invocaciones interactivas activas. `cleanup::` ya cumple el namespacing `<name>::`.
- **`CLEAN_PACKAGE_NAME`** (hoy muerta) → `ZSH_CLEAN_PACKAGE_NAME` con alias defensivo.

## Capabilities

### New Capabilities
- `cleanup-naming-convention`: todas las variables de entorno del módulo usan prefijo `ZSH_CLEAN_`, con aliases backward-compat temporales `CLEAN_*` para la superficie pública.

### Modified Capabilities
- `cleanup-configurability`: las variables de configuración documentadas (`CLEAN_DRY_RUN`, `CLEAN_CONFIRM`, `CLEAN_BASE_DIR_PATTERNS`, `CLEAN_BASE_FILE_PATTERNS`, caches) pasan a `ZSH_CLEAN_*` manteniendo el alias `CLEAN_*` funcional como fallback de compatibilidad.

## Impact

- **Código afectado**: `zsh/modules/clean/config/base.zsh`, `config/linux.zsh`, `config/osx.zsh`, `internal/base.zsh` (flags), `plugin.zsh` (`CLEAN_PATH` → `ZSH_CLEAN_PATH`).
- **Compatibilidad**: 100% preservada vía aliases — cualquier `export CLEAN_*` previo o lectura de `CLEAN_*` en entornos existentes sigue funcionando.
- **Docs/artefactos**: los specs activos (`openspec/specs/cleanup-*`) y los docs del plan actual se actualizan a `ZSH_CLEAN_*`; `openspec/changes/archive/` y el issue HAD-87 NO se tocan (histórico).
- **Sin cambios de API de funciones** — `cleanup`, `cleanup::*` y `_cleanup::*` intactos.
