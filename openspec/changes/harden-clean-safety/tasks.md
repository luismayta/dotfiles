## 1. Configuración

- [x] 1.1 En `zsh/modules/clean/config/base.zsh`, añadir `export CLEAN_AGGRESSIVE_PATTERNS="${CLEAN_AGGRESSIVE_PATTERNS:-}"` (default vacío, doc comentada)
- [x] 1.2 Extraer de `CLEAN_BASE_DIR_PATTERNS` los genéricos (`build|dist|out|release|debug|target|vendor|tmp|temp|coverage|eggs|venv`) y documentarlos como valores de `CLEAN_AGGRESSIVE_PATTERNS`
- [x] 1.3 Eliminar patrones muertos de `CLEAN_BASE_DIR_PATTERNS`: `docs/_build/`, `.vuepress/dist`, `env.back`
- [x] 1.4 Eliminar `.terraform` y `.task` de `CLEAN_BASE_DIR_PATTERNS` (dedupe con funciones dedicadas)
- [x] 1.5 Mover `coverage.out` de `CLEAN_BASE_DIR_PATTERNS` a `CLEAN_BASE_FILE_PATTERNS`
- [x] 1.6 Reescribir el bloque "Override Notice" del header para listar solo las variables con guarda `:-` (incluida la nueva `CLEAN_AGGRESSIVE_PATTERNS`)

## 2. Núcleo de limpieza

- [x] 2.1 En `zsh/modules/clean/internal/base.zsh`, hacer que `_cleanup::safe_remove` respete el contrato de confirmación: dry-run → reportar y retornar; `needs_confirmation` → `confirm` con el path objetivo; solo entonces `rm -rf`
- [x] 2.2 En `_cleanup::unnecessary`, fusionar `CLEAN_BASE_DIR_PATTERNS` + `CLEAN_AGGRESSIVE_PATTERNS` con dedupe por patrón (sin dobles barridos)

## 3. API pública

- [x] 3.1 En `zsh/modules/clean/pkg/base.zsh`, eliminar `cleanup::python::pyenv` del flujo de `cleanup::all`
- [x] 3.2 Reimplementar `cleanup::python::pyenv` como informativa: lista versions instaladas, advierte que borrar intérpretes es destructivo, y no elimina nada salvo `CLEAN_FORCE=true` + confirmación

## 4. Verificación

- [x] 4.1 Verificar sintaxis (`zsh -n`) de `config/base.zsh`, `internal/base.zsh` y `pkg/base.zsh`
- [x] 4.2 Con árbol de prueba y dry-run: confirmar que los genéricos (build/, dist/, tmp/) NO se listan por defecto y SÍ con `CLEAN_AGGRESSIVE_PATTERNS` seteada
- [x] 4.3 Confirmar que `cleanup::pip` (o cache equivalente) pide confirmación sin `CLEAN_FORCE`, y que `CLEAN_FORCE=true` la omite
- [x] 4.4 Confirmar que `cleanup::all` no toca `~/.pyenv/versions` (dry-run o rastreo de llamadas)
- [x] 4.5 Confirmar que `.terraform`/`.task` no se barren dos veces en `cleanup::all`
- [x] 4.6 Validar que `cleanup::help` sigue funcionando y documenta `CLEAN_AGGRESSIVE_PATTERNS`
