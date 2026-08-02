## Context

El módulo `zsh/modules/clean/` se carga vía `zsh/zshrc` (loop de módulos, `~línea 58`) → `plugin.zsh` → `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`.

Los patrones de limpieza viven hoy en dos lugares:

1. **`config/base.zsh:16,20`** — declaración pública (pero **sin guarda `:-`**, rompiendo el override de usuario documentado en el header del propio archivo):
   - `CLEAN_BASE_DIR_PATTERNS="node_modules|jspm_packages|typings|.npm|.vagrant|.wercker|eggs|.eggs|*.egg-info|.pytest_cache|.hypothesis|docs/_build/|htmlcov|.mypy_cache|.lib-cov|bower_components|.venv|venv|env.back|venv.back|.next|.nuxt|.cache|.grunt|.vuepress/dist|.fusebox|.dynamodb|.task|coverage"`
   - `CLEAN_BASE_FILE_PATTERNS=".DS_Store|*.pyc|*.orig|*.retry|*.tmp|*.egg"`
2. **`internal/base.zsh:147`** — `local extra_dirs="__pycache__|vendor|.external_modules"` hardcodeado en la implementación, fusionado en `_cleanup::unnecessary`.

El split se hace con `IFS='|' read -rA` y cada patrón se pasa a `find -name` (match por **basename**, recursivo desde `.`). Patrones con `/` final o con rutas (p.ej. `docs/_build/`) no matchean con `-name` y son ruido.

## Goals / Non-Goals

**Goals:**
- Cubrir con patrones nuevos todas las categorías solicitadas: build, dependencias, caches, tooling, coverage, logs, temporales, Python, C/C++, OS.
- Eliminar el hardcodeo de `extra_dirs` en `internal/base.zsh`, moviendo esos patrones a la configuración pública.
- Restaurar la promesa de override del módulo (guarda `:-`) para que `~/.customrc` pueda extender/reemplazar la lista.
- Preservar el comportamiento seguro existente (dry-run + confirmación) sin cambios.

**Non-Goals:**
- No tocar `cleanup::terraform` / `cleanup::tasks` (funciones dedicadas con rutas propias).
- No cambiar la API pública de funciones (`cleanup`, `cleanup::*`).
- No implementar merge de variable con pipes (ver Decisiones — se descarta).
- No editar README generado (`README.md` dice DO NOT EDIT; se regenera con `task readme` si hiciera falta).

## Decisions

### D1. Un solo string `|` en `config/base.zsh`, sin slashes finales
Los patrones nuevos se agregan a los strings existentes, escritos **sin `/` final** (el `find -name` matchea basename). Los existentes con slash (`docs/_build/`, `.vuepress/dist`) se dejan intactos (ruido inofensivo, fuera de alcance limpiar deuda).

Nuevos en DIR: `build|dist|out|release|debug|target|.cache-loader|.turbo|.parcel-cache|.svelte-kit|.angular|.ruff_cache|.pyre|.tox|.nox|.scannerwork|.terragrunt-cache|.terraform|.gradle|.cargo|.lycheecache|.cq|.coverage|coverage.out|tmp|temp|.tmp|pip-wheel-metadata|CMakeFiles|cmake-build-*|Testing`
Nuevos en FILE: `*.log|Thumbs.db|Desktop.ini`

Patrones ya cubiertos por la lista existente (no duplicar): `node_modules`, `.external_modules`, `vendor`, `.cache`, `.next`, `.nuxt`, `.pytest_cache`, `.mypy_cache`, `__pycache__`, `.eggs`, `*.egg-info`, `.task`, `coverage`, `htmlcov`, `.DS_Store`, `*.tmp`.

**Alternativa descartada**: mover a archivos separados (p.ej. `config/patterns.zsh`). Más limpio, pero rompe compatibilidad con cualquier override existente y agrega un archivo para un cambio que vive naturalmente en las dos variables ya documentadas.

### D2. Mover `extra_dirs` a config pública (fin del hardcodeo)
`__pycache__`, `vendor`, `.external_modules` salen de `internal/base.zsh:147` y pasan al string de `CLEAN_BASE_DIR_PATTERNS` (los dos primeros; `.external_modules` también). `_cleanup::unnecessary` queda consumiendo únicamente las variables públicas, cumpliendo el spec `cleanup-core`.

### D3. Guardas `:-` para restaurar el override (`cleanup-configurability`)
```zsh
export CLEAN_BASE_DIR_PATTERNS="${CLEAN_BASE_DIR_PATTERNS:-node_modules|...|Testing}"
export CLEAN_BASE_FILE_PATTERNS="${CLEAN_BASE_FILE_PATTERNS:-.DS_Store|*.log|Desktop.ini}"
```
Alineado con el resto de variables del módulo (`CLEAN_BASE_CACHE_*`, `CLEAN_DRY_RUN`, `ZSH_CLEAN_ENABLED`) y con `~/.customrc` (sourceado en `zsh/zshrc:49`, antes de los módulos).

**Alternativa considerada — variable de merge `CLEAN_USER_PATTERNS`**: concatenada en `_cleanup::unnecessary` como hoy hace con `extra_dirs`. Permite append sin reemplazar defaults. **Descartada** para este change: añade una tercera variable, más superficie de API; la guarda `:-` cubre el caso de uso real (customizar), y el spec de merge (escenario "Additional user patterns") se documenta como patrón de append desde `~/.customrc` re-expandiendo la variable. Se puede añadir en un change futuro si hay demanda.

### D4. `cmake-build-*` como patrón glob de dir
`find -name "cmake-build-*"` matchea dirs cuyo basename empieza con `cmake-build-`, cubriendo `cmake-build-debug`, `cmake-build-release`, etc. Funciona igual que el `*.egg-info` existente.

## Risks / Trade-offs

- **[Patrones genéricos borran directorios legítimos]** → `build`, `dist`, `target`, `out`, `tmp`, `temp`, `release`, `debug` son nombres comunes; un proyecto con un dir `build/` que sí importa lo perdería. **Mitigación**: mecanismos existentes intactos — `CLEAN_DRY_RUN` (default en `internal/base.zsh`), confirmación interactiva, `CLEAN_CONFIRM=false` solo si el usuario lo decide. Documentar en `tasks` verificar con dry-run antes de activar borrado real.
- **[Override por guarda `:-` reemplaza TODA la lista base]** → si el usuario exporta `CLEAN_BASE_DIR_PATTERNS` sin los defaults, pierde los built-ins. **Mitigación**: documentar el patrón de append (`export CLEAN_BASE_DIR_PATTERNS="${CLEAN_BASE_DIR_PATTERNS:-}|mi_patron"` no funciona solo — ver D3) y mostrar el valor actual en `cleanup::help`/README.yaml. Trade-off aceptado vs. complejidad de merge.
- **[Duplicación de patrones si ya están en la lista]** → `node_modules`, `.pytest_cache`, etc. ya existen; agregarlos de nuevo solo duplica `find` calls. **Mitigación**: revisión cruzada en la implementación (tabla de diff en `tasks.md`).
- **[Patrones con slash no matchean]** → `docs/_build/` y `.vuepress/dist` existentes son inefectivos con `find -name`. Fuera de alcance; se dejan sin cambio para no expandir el diff.

## Migration Plan

1. Editar `zsh/modules/clean/config/base.zsh` (guardas + patrones nuevos + consolidación de `extra_dirs`).
2. Editar `zsh/modules/clean/internal/base.zsh` (eliminar `extra_dirs` local; `_cleanup::unnecessary` consume solo vars públicas).
3. Verificar: `source` del módulo en una shell limpia, `CLEAN_DRY_RUN=true cleanup` en un dir de prueba con directorios de cada categoría, y confirmar que lista los matches sin borrar.
4. Si el usuario tiene `~/.customrc`, documentar (no requiere rollback). Rollback: revertir el diff de los dos archivos.

## Open Questions

- Ninguna bloqueante. El alcance exacto de patrones viene dado por la lista del usuario; la decisión de merge (D3) está resuelta a favor de guardas `:-` + append manual.
