## Why

El módulo `clean` de zsh solo cubre una fracción de los directorios y archivos temporales que los proyectos modernos generan (build/, dist/, target/, caches de tooling, coverage, logs, etc.). La lista de patrones actual está incompleta y además no es extensible por el usuario: `CLEAN_BASE_DIR_PATTERNS` y `CLEAN_BASE_FILE_PATTERNS` se declaran con `export` duro (sin guarda `:-`), e incluso hay patrones hardcodeados dentro de `internal/base.zsh` (`extra_dirs`), fuera de la configuración pública.

## What Changes

- Ampliar `CLEAN_BASE_DIR_PATTERNS` (`zsh/modules/clean/config/base.zsh`) con los directorios faltantes: `build`, `dist`, `out`, `release`, `debug`, `target`, caches de tooling (`.turbo`, `.parcel-cache`, `.svelte-kit`, `.angular`, `.ruff_cache`, `.pyre`, `.tox`, `.nox`, `.scannerwork`, `.terragrunt-cache`, `.terraform`, `.gradle`, `.cargo`), coverage (`.coverage`, `coverage.out`), temporales (`tmp`, `temp`, `.tmp`), Python (`pip-wheel-metadata`), C/C++ (`CMakeFiles`, `cmake-build-*`, `Testing`).
- Ampliar `CLEAN_BASE_FILE_PATTERNS` con `*.log`, `Thumbs.db`, `Desktop.ini`.
- Consolidar `extra_dirs` (`__pycache__`, `vendor`, `.external_modules`) de `internal/base.zsh` hacia la configuración pública, eliminando el hardcodeo en implementación.
- Hacer extensible la lista de patrones por usuario (guarda `:-` y/o variable de merge) respetando la convención de override documentada en el header de `config/base.zsh` y el `~/.customrc` sourceado antes de los módulos.

## Capabilities

### New Capabilities
- `cleanup-patterns`: catálogo completo de patrones de limpieza (directorios y archivos por categoría: build, dependencias, caches, tooling, coverage, logs, temporales, Python, C/C++, OS) que el núcleo del módulo consume para el borrado recursivo.

### Modified Capabilities
- `cleanup-core`: la lista de patrones consumida por `_cleanup::unnecessary` cambia (nuevos directorios/archivos) y deja de tener patrones hardcodeados en implementación (`extra_dirs`).
- `cleanup-configurability`: los patrones de limpieza pasan a ser configurables por el usuario vía variables de entorno (`CLEAN_BASE_DIR_PATTERNS`, `CLEAN_BASE_FILE_PATTERNS` y/o variable de merge), con defaults preservados.

## Impact

- **Código afectado**: `zsh/modules/clean/config/base.zsh` (declaración de patrones + guardas), `zsh/modules/clean/internal/base.zsh` (`_cleanup::unnecessary` — consume patrones desde config, sin `extra_dirs` hardcodeado).
- **Comportamiento**: `cleanup`, `cleanup::all` y `cleanup::projects` eliminarán más categorías de artefactos (build/caches/coverage/logs) en el árbol actual.
- **Riesgo**: patrones genéricos como `build`, `dist`, `target`, `out`, `tmp`, `temp` pueden coincidir con directorios de trabajo legítimos; mitigado por los mecanismos existentes de dry-run y confirmación (`cleanup-safety`).
- **Configuración**: nuevos overrides documentados para `~/.customrc`; sin cambios en dependencias ni en la API pública de funciones.
