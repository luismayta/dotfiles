## Why

Las configuraciones, funciones y variables de git están dispersas en `zsh/core/` cuando deberían pertenecer al módulo `zsh/modules/git/`. Esto rompe el principio de separación de dominios: el core no debería contener lógica específica de git. Al consolidar todo en el módulo git, mejoramos la mantenibilidad y la coherencia arquitectónica.

## What Changes

- Mover `zsh/core/config/git.zsh` (env var `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS`) a `zsh/modules/git/config/git.zsh`
- Mover `zsh/core/internal/git.zsh` (función `core::git::get_module_path`) a `zsh/modules/git/internal/` renombrada como `git::internal::get_module_path`
- Mover funciones `fcs()` y `fgb()` de `zsh/core/pkg/helper/core.zsh` a `zsh/modules/git/pkg/fzf.zsh`
- Actualizar `zsh/core/internal/backup.zsh` para que use el nuevo namespace `git::internal::get_module_path`
- Remover los `source` de los archivos movidos en `zsh/core/config/main.zsh` y `zsh/core/internal/main.zsh`

## Capabilities

### New Capabilities
- `git-aliases`: Consolidación de configuraciones, funciones internas y helpers de git actualmente dispersos en `zsh/core/` dentro del módulo `zsh/modules/git/`

### Modified Capabilities
- `core-helpers`: Remover funciones `fcs()` y `fgb()` del helper core (se trasladan al módulo git)
- `core-api`: Remover `core::git::get_module_path` del core API (se traslada al módulo git)
- `core-backup`: Actualizar referencia a `core::git::get_module_path` → `git::internal::get_module_path`

## Impact

- **Archivos a mover**: `zsh/core/config/git.zsh`, `zsh/core/internal/git.zsh`
- **Archivos a modificar**: `zsh/core/config/main.zsh`, `zsh/core/internal/main.zsh`, `zsh/core/internal/backup.zsh`, `zsh/core/pkg/helper/core.zsh`
- **Archivos a crear**: `zsh/modules/git/config/git.zsh`, `zsh/modules/git/internal/get-module-path.zsh`, `zsh/modules/git/pkg/fzf.zsh`
- **Archivos a modificar en git module**: `zsh/modules/git/config/main.zsh`, `zsh/modules/git/internal/main.zsh`, `zsh/modules/git/pkg/main.zsh`
- **Dependencias**: Ninguna externa. Las funciones `fcs`/`fgb` ya dependen de `fzf` que está en core.
