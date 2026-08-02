## Context

La auditoría del módulo `clean` (post `extend-clean-patterns`) reveló tres brechas de seguridad/datos de severidad alta y varios defectos de la lista recién ampliada. Estado actual relevante:

- **`internal/base.zsh:45-61`** — `_cleanup::safe_remove` hace `rm -rf` directo sobre paths de cache (chequea solo dry-run, **no** confirmación). El prompt existe únicamente en `_cleanup::safe_find_remove` (usado para patrones del árbol).
- **`pkg/base.zsh:103-108`** — `cleanup::python::pyenv` borra `${HOME}/.pyenv/versions` (intérpretes completos) y está dentro de `cleanup::all` (`pkg/base.zsh:26`).
- **`config/base.zsh:16`** — `CLEAN_BASE_DIR_PATTERNS` (63 patrones) incluye nombres genéricos (`build`, `dist`, `out`, `release`, `debug`, `target`, `vendor`, `tmp`, `temp`, `coverage`, `eggs`, `venv`) matcheados a cualquier profundidad por `find -name`. `cleanup` desde `$HOME` borraría `~/.cache`, `~/.npm`, `~/.cargo`, `~/.gradle`, `~/.terraform`.
- `coverage.out` (archivo Go) está en `DIR_PATTERNS`; `docs/_build/` y `.vuepress/dist` son muertos (slashes rompen `find -name`); `.terraform`/`.task` están en patrones **y** en funciones dedicadas (doble barrido).
- El header de `config/base.zsh:4-7` promete override de "All variables" pero solo `ZSH_CLEAN_ENABLED` y las 2 de patrones tienen guarda `:-`.

## Goals / Non-Goals

**Goals:**
- Cero operaciones destructivas sin confirmación previa — `CLEAN_CONFIRM`/`CLEAN_FORCE`/`CLEAN_DRY_RUN` aplican al 100% de rutas de borrado.
- `cleanup::all` nunca borra intérpretes de Python.
- Nombres genéricos salen de la limpieza por defecto; activables explícitamente vía opt-in.
- Corregir la clasificación del cambio reciente (`coverage.out` a FILE, patrones muertos fuera, dedupe `.terraform`/`.task`) y alinear el header con la realidad.
- Mantener la API pública de funciones intacta (sin renombres — el naming es deuda histórica aceptada).

**Non-Goals:**
- No migrar naming (`cleanup::` → `clean::`, `CLEAN_` → `ZSH_CLEAN_`) — es deuda repo-wide con su propio ciclo.
- No eliminar las 15 variables muertas ni deduplicar `CLEAN_BASE_CACHE_*` vs `CLEAN_LINUX_*` — deuda de mantenibilidad, alcance separado.
- No implementar `-maxdepth`/`-prune` — optimización de rendimiento, no seguridad.
- No tocar `cleanup::linux::tmp` (borra `/tmp` sin filtro de propietario) — se anota como riesgo conocido, requiere decisión de producto.

## Decisions

### D1. `CLEAN_AGGRESSIVE_PATTERNS` — opt-in por variable, default vacío
Nueva variable en `config/base.zsh`:
```zsh
export CLEAN_AGGRESSIVE_PATTERNS="${CLEAN_AGGRESSIVE_PATTERNS:-}"
```
Contiene los genéricos: `build|dist|out|release|debug|target|vendor|tmp|temp|coverage|eggs|venv` — **solo si el usuario la setea**. `_cleanup::unnecessary` fusiona `CLEAN_BASE_DIR_PATTERNS` + `CLEAN_AGGRESSIVE_PATTERNS` (igual que hacía con `extra_dirs`), con dedupe por patrón.

**Alternativa considerada**: dejar los genéricos en la lista base y restringir con `-maxdepth 1`. Descartada: el peligro real es `cleanup` desde `$HOME` — `-maxdepth` no lo resuelve (los caches personales están a profundidad 1) y silenciosamente cambia el contrato de "recursivo desde el árbol actual". Opt-in explícito es más predecible.

**Nota**: `vendor` y `venv` ya vivían en `extra_dirs` (luego consolidados a la lista base en `extend-clean-patterns`); al moverlos a opt-in se preserva el comportamiento seguro (no borrar deps vendoreadas de Go/Composer ni venvs) y el usuario que los quiera los reactiva.

### D2. Confirmación en `_cleanup::safe_remove`
`_cleanup::safe_remove` (internal/base.zsh:45-61) pasa por el mismo contrato que `safe_find_remove`:
1. `_cleanup::is_dry_run` → reporta y retorna.
2. `_cleanup::needs_confirmation` (CLEAN_CONFIRM ≠ false && CLEAN_FORCE no seteado) → `_cleanup::confirm` con el path objetivo.
3. `rm -rf` solo tras confirmación.

Esto cubre automáticamente todas las rutas de cache: `cleanup::pip`, `cargo`, `bun`, `pnpm`, `ccache`, `pre_commit`, `virtualenvs`, `brew`, `system::*`. Un único cambio en el helper, no en cada función pública.

### D3. `cleanup::python::pyenv` fuera de `cleanup::all`
- `cleanup::python::pyenv` se elimina del flujo de `cleanup::all` (pkg/base.zsh:26).
- La función se mantiene definida (API pública intacta) pero reimplementada como **informativa/dry-run**: lista las versions instaladas y advierte que borrarlas es destructivo; no elimina nada salvo `CLEAN_FORCE=true` explícito + confirmación.

### D4. Corrección de la lista de patrones (config/base.zsh:16,20)
- Mover `coverage.out` de `DIR_PATTERNS` → `FILE_PATTERNS` (es archivo).
- Eliminar muertos: `docs/_build/`, `.vuepress/dist` (slashes; `find -name` jamás matchea).
- Eliminar `.terraform`, `.task` de `DIR_PATTERNS` (dedupe con `cleanup::terraform`/`cleanup::tasks`).
- Eliminar genéricos → `CLEAN_AGGRESSIVE_PATTERNS` (D1).
- Aclarar `env.back` → `venv.back` (typo semántico; se mantiene `env.back` fuera — no, se elimina por dudoso y no estar en la lista solicitada del usuario; ver Riesgos).

**Alternativa**: conservar `env.back`. Descartada: es ruido sin fuente confirmada; menos patrones = menos superficie.

### D5. Header honesto en `config/base.zsh`
El bloque "Override Notice" (líneas 4-7) se reescribe para listar **exactamente** las variables con guarda `:-` (`ZSH_CLEAN_ENABLED`, `CLEAN_BASE_DIR_PATTERNS`, `CLEAN_BASE_FILE_PATTERNS`, `CLEAN_AGGRESSIVE_PATTERNS` y flags `CLEAN_DRY_RUN/CONFIRM/VERBOSE/FORCE` que ya viven en internal) y anotar que el resto son internas del módulo.

## Risks / Trade-offs

- **[Footgun $HOME persistente en `CLEAN_BASE_DIR_PATTERNS`]** → `.cache`, `.npm`, `.gradle`, `.cargo`, `.terraform` siguen matcheándose a cualquier profundidad desde `$HOME`. **Mitigación**: con D2, todo pasa por confirmación; el prompt con el path exacto hace visible el peligro antes de borrar. Documentar en `cleanup::help` la advertencia de no ejecutar desde `$HOME`.
- **[Usuarios que dependían de limpiar `build/`/`dist/`/`tmp/` por defecto]** → pierden esa limpieza salvo opt-in. **Mitigación**: cambio explícito y documentado; la nueva variable aparece en el header y en `cleanup::help`.
- **[Mover `vendor`/`venv` a opt-in revierte parte de `extend-clean-patterns`]** → comportamiento intencional: los patrones eran de la lista del usuario original, pero la auditoría los marcó de riesgo (deps vendoreadas, venvs). Trade-off aceptado: seguridad > cobertura.
- **[`cleanup::python::pyenv` informativa puede confundir]** → se mantiene el mensaje claro de qué haría y cómo forzarlo; es el mismo patrón dry-run del módulo.
- **[Eliminar `env.back`]** → posible patrón legítimo de algún flujo desconocido. **Mitigación**: no estaba en la lista solicitada por el usuario ni en ninguna fuente; baja probabilidad. Reversible vía git.

## Migration Plan

1. `config/base.zsh`: nueva `CLEAN_AGGRESSIVE_PATTERNS`, limpiar `DIR_PATTERNS`/`FILE_PATTERNS`, header honesto.
2. `internal/base.zsh`: confirmación en `safe_remove`; `_cleanup::unnecessary` fusiona `CLEAN_BASE_DIR_PATTERNS` + `CLEAN_AGGRESSIVE_PATTERNS` con dedupe.
3. `pkg/base.zsh`: quitar `cleanup::python::pyenv` de `cleanup::all`; reimplementar pyenv como informativa.
4. Verificar con árbol de prueba: confirm que los genéricos NO se listan por defecto, sí con opt-in; que `cleanup::pip` pide confirmación; que `cleanup::all` no toca `~/.pyenv/versions`.
5. Rollback: revertir el diff de los 3 archivos (cambio autocontenido).

## Open Questions

- Ninguna bloqueante. La decisión sobre `cleanup::linux::tmp` (riesgo `/tmp` sin filtro de propietario) se deja documentada como deuda con etiqueta de seguridad, no se resuelve en este change.
