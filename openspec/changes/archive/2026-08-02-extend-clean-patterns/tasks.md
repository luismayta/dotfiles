## 1. Configuración de patrones

- [x] 1.1 En `zsh/modules/clean/config/base.zsh`, agregar guarda `:-` a `CLEAN_BASE_DIR_PATTERNS`: `export CLEAN_BASE_DIR_PATTERNS="${CLEAN_BASE_DIR_PATTERNS:-...}"` conservando el valor default actual
- [x] 1.2 Agregar a `CLEAN_BASE_DIR_PATTERNS` los patrones de build: `build|dist|out|release|debug|target` (sin `/` final, match por basename)
- [x] 1.3 Agregar a `CLEAN_BASE_DIR_PATTERNS` los caches de tooling: `.cache-loader|.turbo|.parcel-cache|.svelte-kit|.angular|.ruff_cache|.pyre|.tox|.nox|.scannerwork|.terragrunt-cache|.terraform|.gradle|.cargo|.lycheecache|.cq`
- [x] 1.4 Agregar a `CLEAN_BASE_DIR_PATTERNS` coverage y temporales: `.coverage|coverage.out|tmp|temp|.tmp`
- [x] 1.5 Agregar a `CLEAN_BASE_DIR_PATTERNS` Python y C/C++: `pip-wheel-metadata|CMakeFiles|cmake-build-*|Testing`
- [x] 1.6 Consolidar en `CLEAN_BASE_DIR_PATTERNS` los patrones de `extra_dirs` (`__pycache__|vendor|.external_modules`) — verificar que ninguno esté ya presente para evitar duplicados
- [x] 1.7 Agregar guarda `:-` a `CLEAN_BASE_FILE_PATTERNS` y ampliar con `*.log|Thumbs.db|Desktop.ini`

## 2. Núcleo de limpieza

- [x] 2.1 En `zsh/modules/clean/internal/base.zsh` (`_cleanup::unnecessary`), eliminar el `local extra_dirs="__pycache__|vendor|.external_modules"` y el `combined_dir`; consumir solo `CLEAN_BASE_DIR_PATTERNS` y `CLEAN_BASE_FILE_PATTERNS`
- [x] 2.2 Verificar que no queden referencias a `extra_dirs` en `internal/` ni `pkg/`

## 3. Verificación

- [x] 3.1 Crear directorio de prueba con artefactos de cada categoría (build/, dist/, .turbo/, .coverage/, tmp/, __pycache__/, CMakeFiles/, *.log, Thumbs.db)
- [x] 3.2 Ejecutar `CLEAN_DRY_RUN=true cleanup` en el dir de prueba y confirmar que lista todos los matches sin borrar
- [x] 3.3 Confirmar que no se matchean directorios legítimos (falsos positivos) en un árbol de control sin artefactos
- [x] 3.4 Verificar que `~/.customrc` puede extender la lista (export con guarda antes de sourcear módulos) y que el módulo respeta el override
- [x] 3.5 Validar que `cleanup::help` sigue listando la configuración sin romperse
