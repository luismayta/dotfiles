## Context

Auditoría de seguimiento post `harden-clean-safety` (KenThompson, verificación empírica del flujo pwd): `cleanup` opera correctamente sobre el pwd consumiendo `CLEAN_BASE_DIR_PATTERNS` + `CLEAN_AGGRESSIVE_PATTERNS` + `CLEAN_BASE_FILE_PATTERNS`. Quedaron dos brechas:

1. **Sin guard de `$HOME`**: `cleanup` desde `$HOME` borraría `~/.cache`, `~/.npm`, `~/.cargo`, `~/.gradle` (nombres en la lista base, matcheados a cualquier profundidad). Verificado: esos dirs existen en el host.
2. **`_cleanup::safe_find_delete` sin confirmación** (internal/base.zsh:100-123): `find ... -delete` directo. `safe_remove` (línea 61-63) y `safe_find_remove` (línea 94) sí confirman; el borrado de archivos por patrón quedó fuera del contrato.

Estado relevante:
- `cleanup` (pkg/base.zsh:49-53) → `_cleanup::unnecessary`.
- `cleanup::all` (pkg/base.zsh:6-46) → `_cleanup::unnecessary` (árbol) + caches HOME-based + tasks/terraform + projects.
- `cleanup::projects` (pkg/base.zsh:182-193) → `cd "${PROJECTS}"` + `cleanup` + `cd` back (único `cd` del módulo).
- `_cleanup::safe_find_delete` (internal/base.zsh:100-123) → `find "${search_path}" -type f -name "${pattern}" -delete` con dry-run.

## Goals / Non-Goals

**Goals:**
- Cero borrados de árbol desde `$HOME` sin override explícito (`CLEAN_FORCE=true`).
- Cerrar la última ruta de borrado sin confirmación (archivos por patrón).
- Guard cubre `cleanup`, `cleanup::all` (fase árbol) y `cleanup::projects`.
- Documentar el comportamiento en `cleanup::help`.

**Non-Goals:**
- No tocar las funciones de cache HOME-based (`cleanup::pip`, `cleanup::cargo`, etc.) — ya confirman individualmente y son el mecanismo correcto para limpiar `$HOME`.
- No resolver el stale-env de `${VAR:-...}` (riesgo MEDIO detectado) — requiere decisión de recarga de entorno, no de código del módulo.
- No renombrar nada ni migrar naming (deuda repo-wide aceptada).
- No añadir `-maxdepth`/`-prune` (rendimiento, alcance aparte).

## Decisions

### D1. Guard en un helper reutilizable `_cleanup::guard_home`
Nuevo helper en `internal/base.zsh` (junto a los otros `_cleanup::`):
```zsh
_cleanup::guard_home() {
    [[ "${PWD}" == "${HOME}" ]] || return 0
    message_warning "Refusing to clean the current directory: it is your HOME (${HOME})."
    message_warning "Personal caches (~/.cache, ~/.npm, ~/.cargo) live here and would be deleted."
    message_warning "Run from a project directory, use cleanup::all, or set CLEAN_FORCE=true to override."
    return 1
}
```
`cleanup` y `cleanup::all` lo invocan al inicio (fase árbol); `cleanup::projects` lo invoca tras `cd "${PROJECTS}"` (cubre el caso `$PROJECTS == $HOME`).

**Alternativa considerada**: comparar con `$HOME` usando `realpath`/`readlink -f` para symlinks. Descartada: añade dependencia de binario externo; el caso de symlink apuntando a HOME es un edge improbable y `PWD` en zsh ya es canónico.

**Alternativa considerada**: guard en `_cleanup::unnecessary` (núcleo). Descartada: `_cleanup::unnecessary` es el núcleo que `cleanup::tasks`/`cleanup::terraform` también usan en contextos válidos; el guard pertenece a la capa de orquestación (pkg), no al núcleo.

### D2. `CLEAN_FORCE` como override del guard
El guard retorna 1 (aborta) salvo que `CLEAN_FORCE` sea true. `cleanup` hace:
```zsh
function cleanup {
    _cleanup::guard_home || return 1
    ...
}
```
Con `CLEAN_FORCE=true`, `guard_home` muestra warning pero retorna 0. Consistente con el contrato existente de `needs_confirmation`/`FORCE`.

### D3. Confirmación en `_cleanup::safe_find_delete`
Replicar el patrón de `safe_find_remove` (internal/base.zsh:70-97): tras el dry-run, si `needs_confirmation`, llamar `_cleanup::confirm "Remove matched files (${pattern})?"` y abortar con `return 0` si el usuario declina; si acepta, proceder al `find ... -delete`. Mantener `CLEAN_VERBOSE`/logging existente.

**Nota**: a diferencia de `safe_find_remove` (que cuenta y confirma una vez por patrón), `safe_find_delete` confirmará una vez por patrón con los paths listados por dry-run. Trade-off aceptado: consistencia de contrato > ergonomía.

### D4. Documentación en `cleanup::help`
Añadir una sección al help (pkg/base.zsh) describiendo: (a) el guard de `$HOME` y el override `CLEAN_FORCE=true`; (b) que la limpieza de archivos por patrón confirma por defecto. Texto corto, alineado con el formato existente.

## Risks / Trade-offs

- **[`cleanup::all` desde `$HOME` aún borra caches]** → es el diseño: las funciones de cache confirman individualmente y son el mecanismo explícito. El guard solo protege la fase de árbol. Documentado en help.
- **[Confirmación por patrón en `safe_find_delete` añade fricción]** → 10 patrones de file = hasta 10 prompts por `cleanup`. **Mitigación**: el usuario puede `CLEAN_CONFIRM=false` o `CLEAN_FORCE=true` (documentado); el prompt es el precio de la seguridad.
- **[`CLEAN_FORCE=true` desactiva el guard]** → override explícito y ruidoso (warning prominente). Es la misma semántica de force en todo el módulo.
- **[Stale-env `${VAR:-...}`]** → fuera de alcance; se documenta en el help que tras cambios de patrones conviene recargar la shell (`exec zsh`). No hay fix seguro automático sin perder la convención de override.

## Migration Plan

1. `internal/base.zsh`: añadir `_cleanup::guard_home`; añadir confirmación en `_cleanup::safe_find_delete`.
2. `pkg/base.zsh`: invocar guard en `cleanup`, `cleanup::all`, `cleanup::projects`; actualizar `cleanup::help`.
3. Verificación: `cleanup` desde `$HOME` aborta (dry-run); desde proyecto funciona; `CLEAN_FORCE=true` desde `$HOME` advierte y procede; archivos por patrón piden confirmación; `zsh -n` en los 2 archivos.
4. Rollback: revertir diff de los 2 archivos (autocontenido).

## Open Questions

- Ninguna bloqueante. El comportamiento de `cleanup::projects` con `$PROJECTS` vacío ya está manejado (warning + return).
