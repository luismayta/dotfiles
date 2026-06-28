## Why

El módulo `zsh/modules/pyenv/` gestiona el toolchain de Python (`pyenv` para versiones, `uv` como herramienta del sistema, `pip`/`pipx` para módulos), pero su nombre solo refleja `pyenv`. Desde que `uv` se ha convertido en el gestor de entornos/paquetes Python principal (integrado en `Taskfile.yml`, `nix/devShell.nix`, y templates Nix), el nombre `pyenv` es engañoso. Renombrarlo a `python` alinea el nombre con su propósito: **gestionar todo el toolchain Python** incluyendo pyenv y uv, cada uno con su propio toggle de activación.

## What Changes

- **Renombrar directorio**: `zsh/modules/pyenv/` → `zsh/modules/python/` **BREAKING**
- **Renombrar variables internas**: `ZSH_PYENV_*` → `ZSH_PYTHON_*`, `PYENV_*` → `PYTHON_*`
- **Renombrar funciones**: `pyenv::*` → `python::*` tanto en internal como en pkg
- **Renombrar constantes**: `PYENV_ROOT`, `PYENV_ROOT_BIN`, `PYENV_*` → `PYTHON_ROOT`, `PYTHON_ROOT_BIN`, `PYTHON_*`
- **Elevar `uv` a ciudadano de primera clase**: De `PYENV_SYSTEM_PACKAGES=(uv)` a `PYTHON_UV_ENABLED` con gestión dedicada dentro del módulo python (instalación, shell completions)
- **Añadir toggle `PYTHON_PYENV_ENABLED`**: Variable para activar/desactivar pyenv independientemente de uv dentro del mismo módulo
- **Actualizar referencias cruzadas**:
  - `zsh/zshenv`: variables `PYENV_ROOT` → `PYTHON_ROOT`, `PYENV_VIRTUALENV_DISABLE_PROMPT` → mover al módulo
  - `zsh/modules/clean/pkg/base.zsh`: funciones `cleanup::pyenv*` → `cleanup::python*`
  - `openspec/specs/core-messages/spec.md`: actualizar referencia a `CORE_MESSAGE_PYENV`
  - `zsh/core/config/env.zsh`: actualizar `CORE_MESSAGE_PYENV` si existe (o crearla apuntando al nuevo path)
- **CHANGELOG.md**: notación de breaking change en próxima release

## Capabilities

### New Capabilities
- `python-module`: Python toolchain module renombrado — gestión de pyenv, uv, pip/pipx, versión global, y módulos Python, con toggles independientes para pyenv (`PYTHON_PYENV_ENABLED`) y uv (`PYTHON_UV_ENABLED`)

### Modified Capabilities
- `core-messages`: La referencia `CORE_MESSAGE_PYENV` apunta al path `zsh/modules/python/` en lugar de `zsh/modules/pyenv/`

## Impact

- **BREAKING**: El path del módulo cambia. Cualquier script que haga `source` directo a `zsh/modules/pyenv/` se rompe (el loader automático de `zshrc` no se afecta porque itera `modules/*/plugin.zsh`)
- `zsh/zshenv`: limpiar vars pyenv que ahora vive en el módulo
- `zsh/modules/clean/pkg/base.zsh`: renombrar 2 funciones de cleanup
- `zsh/core/config/env.zsh`: `CORE_MESSAGE_PYENV` → apuntar a `zsh/modules/python/` (si no existe, crearla)
- `openspec/specs/core-messages/spec.md`: actualizar path de referencia
