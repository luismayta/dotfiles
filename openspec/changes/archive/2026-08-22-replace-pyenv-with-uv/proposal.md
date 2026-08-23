## Why

The `zsh/modules/python` module manages Python versions through pyenv even though uv is already a first-class tool inside the same module (via `PYTHON_UV_ENABLED`). Keeping two version managers duplicates configuration and maintenance burden, and both version sources of truth (`nix/versions.nix`, `Taskfile.yml`) still pin Python 3.11. Replacing pyenv with uv as the single version manager and standardizing on Python 3.14 removes redundant machinery and aligns the dotfiles with the current Python ecosystem. Traces to Jira HAD-100.

## What Changes

- **BREAKING**: Remove pyenv as the Python version manager from `zsh/modules/python` — all `python::internal::pyenv::*` functions, pyenv install/load logic, and pyenv-related variables (`PYTHON_PYENV_ENABLED`, `PYTHON_PACKAGE_NAME=pyenv`, `PYTHON_INSTALL_URL`, `PYTHON_ROOT=${HOME}/.pyenv`)
- Adopt uv as the sole Python version manager inside the module (uv is already installed/managed via `PYTHON_UV_ENABLED`)
- Establish Python 3.14 as the standard global version
- Sync both version sources of truth: `nix/versions.nix` (`pythonVersion = "3.11"` → `3.14`) and `Taskfile.yml` (`PYTHON_VERSION: 3.11.5` → `3.14.x`)
- Remove adjacent pyenv runtime wiring: `zsh/zshenv` (PYENV_ROOT/PATH setup, `PIPENV_PYTHON`, `PYENV_VIRTUALENV_DISABLE_PROMPT`), `zsh/modules/clean/pkg/base.zsh` (`cleanup::python::pyenv`), `zsh/modules/starship/data/starship.toml` (`pyenv_version_name = true`), and update the `CORE_MESSAGE_PYTHON` message text in `zsh/system/core/config/env.zsh`
- Scope directive (Luchex): NO file under `openspec/` is modified by the implementation — archived changes and live specs stay read-only; known spec drift after removal is documented in design.md, not fixed here

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `python-module`: Version management requirements move from pyenv to uv — pyenv toggles, installation, and version operations are replaced by uv-managed versions with 3.14 as the default global version

## Impact

- **Code**: `zsh/modules/python/{plugin.zsh,internal/*.zsh,config/*.zsh,pkg/*.zsh}`, `zsh/zshenv`, `zsh/modules/clean/pkg/base.zsh`, `zsh/modules/starship/data/starship.toml`, `zsh/system/core/config/env.zsh`, `nix/versions.nix`, `Taskfile.yml`
- **Breaking**: Users relying on pyenv shims (`~/.pyenv`), `pyenv install/global`, or the `PYTHON_PYENV_ENABLED` toggle lose that path; interpreters previously installed via pyenv are not migrated automatically
- **Dependencies**: uv becomes required for Python version management when the module is enabled
- **Out of scope**: any modification under `openspec/` (existing specs and archived changes)
