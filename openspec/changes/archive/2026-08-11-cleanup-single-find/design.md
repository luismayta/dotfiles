## Context

Hoy `_cleanup::unnecessary` (`zsh/modules/clean/internal/base.zsh:156-171`) itera patrón por patrón llamando `_cleanup::safe_find_remove` (`find -type d -name PAT -exec rm -rf {} +`) y `_cleanup::safe_find_delete` (`find -name PAT -delete`), cada una con su propio `wc -l` y su propio prompt `[y/N]`. Con ~40 patrones dir + ~10 file, eso son ~50 invocaciones de `find` y hasta ~50 confirmaciones por pasada.

Motivación completa en proposal.md. Los requirements exactos están en `specs/cleanup-core/spec.md` y `specs/cleanup-confirmation/spec.md` de este change.

## Goals / Non-Goals

**Goals:**
- Reducir a 2 invocaciones de `find` por pasada de `cleanup` (1 listado/conteo + 1 borrado por sweep dir y file).
- Un solo prompt consolidado por sweep (dirs y files), con total y grupos afectados.
- Mantener byte a byte la semántica de borrado, el merge de patrones, `guard_home`, dry-run, verbose y `ZSH_CLEAN_FORCE`.

**Non-Goals:**
- No cambiar `config/base.zsh` ni el conjunto de patrones.
- No aceptar argumentos de carpeta en `cleanup` (decidido: fuera de alcance).
- No tocar caches por ruta (`_cleanup::safe_remove`) — mantienen su confirmación individual.
- No introducir dependencias externas (awk, parallel, etc.).

## Decisions

### D1: Expresión `find` combinada construida con array, sin eval

Todos los patrones de un sweep se combinan en una única expresión con `-o`:

```zsh
local -a expr=()
for p in "${patterns[@]}"; do
    (( ${#expr[@]} > 0 )) && expr+=(-o)
    expr+=(-name "${p}")
done
```

Con más de un patrón se agrupa con paréntesis escapados — **obligatorio** por la precedencia de `find`: `-o` liga más débil que la conjunción implícita, así que sin `\( ... \)` el `-exec`/`-delete` final quedaría pegado solo al último `-name` y el resto de patrones se evaluaría sin acción de borrado.

- Dirs: `find . -type d \( -name a -o -name b ... \) -exec rm -rf {} +`
- Files: `find . \( -name a -o -name b ... \) -delete`

Alternativas descartadas: concatenar strings y pasar a `eval` (inseguro), y un `find` por patrón (estado actual, lento).

### D2: Una sola pasada de listado para conteo y reporte de grupos

En vez de `wc -l` por patrón, un único `find` de listado puebla un array zsh (split por líneas con `${(@f)...}`), de donde se deriva:

- **Total**: tamaño del array.
- **Grupos afectados**: basenames únicos (`${item:t}`) y, por cada patrón, `[[ "${basenames[(I)${p}]}" -gt 0 ]]` — el subscript `[(I)]` aplica globbing nativo de zsh, cubriendo patrones como `*.log` y `cmake-build-*` sin dependencias.

Costo del desglose: O(patrones × basenames únicos) — decenas × decenas en la práctica, despreciable frente a la pasada de `find`.

### D3: Dos sweeps independientes (dirs y files), dos prompts consolidados

Se preserva la separación actual: dirs con `-exec rm -rf {} +` (borra árboles enteros) y files con `-delete` (solo archivos). Cada sweep hace su listado, su prompt consolidado ("Remove N items (dirs) matching: g1, g2, …?") y su borrado. `guard_home` sigue cubriendo el árbol completo.

### D4: Duplicados eliminados de la expresión

El merge `BASE|AGGRESSIVE|USER` puede contener el mismo patrón en dos listas; se dedupe antes de construir la expresión para cumplir "no duplicate pattern terms" y no inflar el prompt.

## Risks / Trade-offs

- [Expresión `find` mal agrupada → borrado parcial silencioso] → Mitigación: agrupación `\( ... \)` explícita cuando hay >1 patrón, construcción por array (sin eval) y validación con dry-run (`ZSH_CLEAN_DRY_RUN=true`) antes del primer uso real.
- [Comportamiento distinto GNU find vs BSD find (macOS)] → `-name`, `-exec {} +` y `-delete` son estándar en ambos; se evita `-printf` (no POSIX).
- [Paths con saltos de línea rompen el split del listado] → Debilidad ya presente hoy (`wc -l`); los basenames afectados son rutas de cache/build sin saltos de línea en la práctica. Se mitiga parcialmente con `${(@f)}`.
- [2 invocaciones de `find` por sweep en vez de 1 teórica] → Aceptado: la pasada de listado es necesaria para el reporte de grupos y el conteo previo a la confirmación; el ahorro real es pasar de ~50 invocaciones a 4 por pasada de `cleanup`.
- [Prompt consolidado es menos granular que hoy] → Aceptado explícitamente por el usuario (decisión del alcance); el detalle de grupos afectados compensa la pérdida de granularidad.

## Migration Plan

Cambio contenido en el módulo `zsh/modules/clean`; sin estado externo ni migración de datos. Rollback: revert del commit (el wrapper público `cleanup` no cambia su firma). Verificación previa al merge: `ZSH_CLEAN_DRY_RUN=true zsh -c 'cleanup'` en un directorio con fixtures (node_modules, .next, *.log) y comparar el conjunto de rutas listadas contra el comportamiento actual.
