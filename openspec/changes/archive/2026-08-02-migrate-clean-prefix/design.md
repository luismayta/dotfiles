## Context

Auditoría RobertMartin (post commit RD-36): el módulo `clean` es el peor infractor de naming — 1/49 vars conformes al prefijo `ZSH_<NAME>_` de `docs/guides/create-module.md` (Secciones 3 y 8). El owner propuso migrar sin backward compat; el auditor demostró que romper **silenciosamente** el flujo interactivo del owner (historial: `unset CLEAN_BASE_DIR_PATTERNS CLEAN_BASE_FILE_PATTERNS && exec zsh`; 13 vars `CLEAN_*` exportadas en entorno vivo; 26 invocaciones de `cleanup`) es el peor modo de fallo para un repo de dotfiles. Inventario: 168 refs documentales (specs activos 11, changes ~145, archive ~20, issue HAD-87 2), 0 consumidores runtime fuera del módulo. La guía (Sección 3:235-247) ordena alias backward-compat al renombrar, con precedente herdr (`zsh/modules/herdr/config/base.zsh:22-27`).

## Goals / Non-Goals

**Goals:**
- 49/49 vars conformes a `ZSH_CLEAN_*` tras la migración.
- Compatibilidad 100%: alias `CLEAN_*` funcionales para toda la superficie pública.
- Funciones intactas (`cleanup`, `cleanup::*`, `_cleanup::*`) — sin renombrado.
- Cero ruptura silenciosa de configuración existente.

**Non-Goals:**
- No renombrar funciones (decisión RobertMartin: `cleanup::` ya cumple namespacing; spec `cleanup-core` las fija como contrato).
- No migrar los otros 20 módulos sin prefijo `ZSH_` (deuda repo-wide, ciclo futuro).
- No tocar `openspec/changes/archive/` ni el issue HAD-87 (histórico).
- No eliminar las vars muertas (`CLEAN_PACKAGE_NAME`, `CLEAN_MESSAGE_NOT_IMPLEMENTED`) — solo renombrar + alias defensivo.
- No implementar el plan unset/user-patterns en este change (se hace DESPUÉS, apuntando a los nombres finales `ZSH_CLEAN_*`).

## Decisions

### D1. Renombrar todas las exports a `ZSH_CLEAN_*`
Todas las variables exportadas pasan al prefijo `ZSH_CLEAN_`:
- `config/base.zsh`: `ZSH_CLEAN_ENABLED`, `ZSH_CLEAN_BASE_DIR_PATTERNS`, `ZSH_CLEAN_BASE_FILE_PATTERNS`, `ZSH_CLEAN_AGGRESSIVE_PATTERNS`, `ZSH_CLEAN_BASE_CACHE_*` (10), `ZSH_CLEAN_PACKAGE_NAME`, `ZSH_CLEAN_MESSAGE_NOT_IMPLEMENTED`.
- `config/linux.zsh` (16), `config/osx.zsh` (9): `ZSH_CLEAN_LINUX_*`, `ZSH_CLEAN_OSX_*`.
- `internal/base.zsh:5-8`: `ZSH_CLEAN_DRY_RUN`, `ZSH_CLEAN_CONFIRM`, `ZSH_CLEAN_VERBOSE`, `ZSH_CLEAN_FORCE`.
- `plugin.zsh`: `CLEAN_PATH` → `ZSH_CLEAN_PATH="${0:A:h}"` (además mejora a `:A`, cumpliendo la guía).

### D2. Alias backward-compat obligatorio (patrón herdr)
Tras cada export canónica, alias temporal:
```zsh
export CLEAN_BASE_DIR_PATTERNS="${ZSH_CLEAN_BASE_DIR_PATTERNS}"
# remove in next cleanup cycle
```
Para TODA la superficie pública (config/ + internal flags). **Sin alias** solo para `ZSH_CLEAN_PATH` (0 refs externas verificadas).

### D3. No renombrar funciones
`cleanup`, `cleanup::*`, `_cleanup::*` quedan intactos. El spec `cleanup-core` (contrato) no se modifica. Opcional documentado (no implementado): un wrapper `function clean { cleanup "$@" }` como alias de conveniencia — se descarta por no aportar cumplimiento.

### D4. Actualizar docs/specs del cambio, no el histórico
Los specs activos (`openspec/specs/cleanup-configurability`, y cualquier ref a `CLEAN_*` en specs activos) se actualizan a `ZSH_CLEAN_*` como parte de este change (delta specs). `archive/` y HAD-87 permanecen (histórico).

## Risks / Trade-offs

- **[Aliases olvidados en ciclo de limpieza]** → mitigado con comentario estándar "remove in next cleanup cycle" + patrón herdr vigente en el repo.
- **[Doble fuente de verdad temporal]** → aceptado y controlado: los alias son unifamiliares, y el ciclo repo-wide (20 módulos pendientes) los eliminará.
- **[Refs documentales sin actualizar]** → los specs activos se actualizan en este change; el archive es histórico y NO se toca (correcto por convención).
- **[CLEAN_PATH sin alias]** → 0 refs externas verificadas por RobertMartin; riesgo nulo.

## Migration Plan

1. `config/base.zsh`: renombrar 16 exports + 10 caches + flags + alias block (patrón herdr).
2. `config/linux.zsh` (16) y `config/osx.zsh` (9): renombrar + alias.
3. `internal/base.zsh:5-8`: renombrar flags + alias; actualizar todos los usos internos de `CLEAN_*` → `ZSH_CLEAN_*`.
4. `pkg/base.zsh`: actualizar usos de `CLEAN_*` → `ZSH_CLEAN_*` en funciones y `cleanup::help`.
5. `plugin.zsh`: `CLEAN_PATH` → `ZSH_CLEAN_PATH="${0:A:h}"`.
6. Actualizar specs activos (delta) con `ZSH_CLEAN_*`.
7. Verificación: `zsh -n` en archivos tocados; `CLEAN_DRY_RUN=true cleanup` en árbol de prueba; confirmar que `unset CLEAN_BASE_DIR_PATTERNS && exec zsh` sigue funcionando (alias re-exporta); confirmar 13 vars viejas del entorno visibles tras reload vía alias; `cleanup::help` sin errores.
8. Rollback: revertir diff (autocontenido en el módulo).

## Open Questions

- Ninguna bloqueante. El cambio es mecánico (rename + alias), la superficie está inventariada por RobertMartin.
