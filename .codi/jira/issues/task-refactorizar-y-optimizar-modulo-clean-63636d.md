# Task: Refactorizar y optimizar módulo clean

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Mejorar la estructura, eliminar duplicación y optimizar el módulo de limpieza zsh
- component: DevOps
- labels: [refactor, zsh, cleanup, optimization]
- parentEpic:
- issueKey: HAD-87

## Scenario

El módulo `zsh/modules/clean` presenta múltiples problemas de diseño que afectan mantenibilidad y rendimiento:

1. **Archivos vacíos**: `config/linux.zsh`, `config/osx.zsh`, `internal/base.zsh`, `internal/helper.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `pkg/helper.zsh`, `pkg/alias.zsh` — todos vacíos, solo con headers.

2. **Duplicación severa**: Las funciones `cleanup::unnecessary` y `cleanup` comparten ~80% del mismo patrón de `find` con opciones de eliminación. `cleanup::projects` invoca `cleanup` que a su vez llama `cleanup::unnecessary`, creando ejecución redundante.

3. **Hardcoded paths macOS**: Rutas como `~/Library/Caches/pip` están hardcodeadas en `pkg/base.zsh` sin verificación de plataforma.

4. **Linux incompleto**: `pkg/linux.zsh` solo tiene stubs que muestran `CLEAN_MESSAGE_NOT_IMPLEMENTED` para `system::trash` y `system::logs`.

5. **Sin manejo de errores**: No hay validación de permisos, ni modo dry-run, ni logging estructurado.

6. **Nomenclatura inconsistente**: Mezcla de `cleanup::pip` (sin namespace jerárquico) vs `cleanup::python::pyenv` (con namespace).

### Acceptance Tests

1. Eliminar o consolidar archivos vacíos del módulo
2. Eliminar duplicación entre `cleanup::unnecessary` y `cleanup` — una sola función maestra
3. Implementar `cleanup::system::trash` y `cleanup::system::logs` para Linux
4. Unificar manejo de errores con helper centralizado
5. Agregar flag `CLEAN_DRY_RUN` para modo simulación (no eliminar, solo mostrar)
6. Estandarizar nomenclatura: todos los cleanup usan namespace `cleanup::{category}::{action}`
7. Los scripts existentes en `bin/` que usan el módulo continúan funcionando
8. Documentar cada función con shellcheck compliance

### Sources:

- https://github.com/luismayta/dotfiles.git