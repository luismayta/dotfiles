## 1. Rename module directory

- [x] 1.1 `git mv zsh/modules/pyenv/ zsh/modules/python/` — rename the module directory preserving git history

## 2. Update plugin.zsh (entry point)

- [x] 2.1 Edit `zsh/modules/python/plugin.zsh` — rename idempotency guard `__ZSH_PYENV_LOADED` → `__ZSH_PYTHON_LOADED`
- [x] 2.2 Edit `zsh/modules/python/plugin.zsh` — rename root path var `ZSH_PYENV_PATH` → `ZSH_PYTHON_PATH`
- [x] 2.3 Edit `zsh/modules/python/plugin.zsh` — update `message_info "Loading module: pyenv"` → `"Loading module: python"`

## 3. Update config/ files

- [x] 3.1 Edit `zsh/modules/python/config/main.zsh` — rename `ZSH_PYENV_PATH` → `ZSH_PYTHON_PATH` in source paths
- [x] 3.2 Edit `zsh/modules/python/config/base.zsh` — rename all vars: `ZSH_PYENV_ENABLED` → `ZSH_PYTHON_ENABLED`, `PYENV_ROOT` → `PYTHON_ROOT`, `PYENV_ROOT_BIN` → `PYTHON_ROOT_BIN`, `PYENV_PACKAGE_NAME` → `PYTHON_PACKAGE_NAME`, `PYENV_VERSIONS` → `PYTHON_VERSIONS`, `PYENV_VERSION_GLOBAL` → `PYTHON_VERSION_GLOBAL`, `PYENV_MODULES` → `PYTHON_MODULES`, `PYENV_VIRTUALENV_DISABLE_PROMPT` → `PYTHON_VIRTUALENV_DISABLE_PROMPT`, `ZSH_PYENV_LAZY_VIRTUALENV` → `ZSH_PYTHON_LAZY_VIRTUALENV`, `PYENV_INSTALL_URL` → `PYTHON_INSTALL_URL`, `PYENV_PACKAGE_NAME` → `PYTHON_PACKAGE_NAME`
- [x] 3.3 Edit `zsh/modules/python/config/base.zsh` — add new var `PYTHON_PYENV_ENABLED="${PYTHON_PYENV_ENABLED:-true}"` and `PYTHON_UV_ENABLED` alongside existing vars
- [x] 3.4 Edit `zsh/modules/python/config/linux.zsh` — replace `PYENV_SYSTEM_PACKAGES=(uv)` with `# uv gestionado por python module via PYTHON_UV_ENABLED`
- [x] 3.5 Edit `zsh/modules/python/config/osx.zsh` — update comment to say "python" instead of "pyenv"

## 4. Update internal/ files

- [x] 4.1 Edit `zsh/modules/python/internal/main.zsh` — rename `ZSH_PYENV_PATH` → `ZSH_PYTHON_PATH`, `pyenv::internal::pyenv::load` → `python::internal::pyenv::load`, replace `PYENV_SYSTEM_PACKAGES` loop with uv-conditional block (guarded by `PYTHON_UV_ENABLED`)
- [x] 4.2 Edit `zsh/modules/python/internal/main.zsh` — replace `for pkg in "${PYENV_SYSTEM_PACKAGES[@]}"; do core::ensure "${pkg}"; done` with uv-conditional block: if `PYTHON_UV_ENABLED` is true, ensure uv is installed
- [x] 4.3 Edit `zsh/modules/python/internal/base.zsh` — rename all functions: `pyenv::internal::pyenv::install` → `python::internal::pyenv::install`, `pyenv::internal::pyenv::load` → `python::internal::pyenv::load`, `pyenv::internal::version::all::install` → `python::internal::version::all::install`, `pyenv::internal::version::global::install` → `python::internal::version::global::install`, `pyenv::internal::module::install` → `python::internal::module::install`, `pyenv::internal::modules::install` → `python::internal::modules::install`, `pyenv::internal::poetry::install` → `python::internal::poetry::install`
- [x] 4.4 Edit `zsh/modules/python/internal/base.zsh` — rename all variable references: `PYENV_PACKAGE_NAME` → `PYTHON_PACKAGE_NAME`, `PYENV_INSTALL_URL` → `PYTHON_INSTALL_URL`, `PYENV_ROOT_BIN` → `PYTHON_ROOT_BIN`, `PYENV_ROOT` → `PYTHON_ROOT`, `PYENV_VERSIONS` → `PYTHON_VERSIONS`, `PYENV_VERSION_GLOBAL` → `PYTHON_VERSION_GLOBAL`, `PYENV_MODULES` → `PYTHON_MODULES`
- [x] 4.5 Add uv internal functions to `zsh/modules/python/internal/base.zsh` — `python::internal::uv::load` and `python::internal::uv::completions`, guarded by `PYTHON_UV_ENABLED`

## 5. Update pkg/ files (public API)

- [x] 5.1 Edit `zsh/modules/python/pkg/main.zsh` — rename `ZSH_PYENV_PATH` → `ZSH_PYTHON_PATH`
- [x] 5.2 Edit `zsh/modules/python/pkg/base.zsh` — rename all functions: `pyenv::upgrade` → `python::upgrade`, `pyenv::install` → `python::install`, `pyenv::version::all::install` → `python::version::all::install`, `pyenv::version::global::install` → `python::version::global::install`, `pyenv::modules::install` → `python::modules::install`, `pyenv::module::install` → `python::module::install`, `pyenv::post_install` → `python::post_install`, `pyenv::load` → `python::load`, `pyenv::poetry::install` → `python::poetry::install`
- [x] 5.3 Edit `zsh/modules/python/pkg/base.zsh` — rename internal call references: `pyenv::internal::*` → `python::internal::*`, vars `PYENV_PACKAGE_NAME` → `PYTHON_PACKAGE_NAME`, `PYENV_ROOT` → `PYTHON_ROOT`

## 6. Update README.md

- [x] 6.1 Edit `zsh/modules/python/README.md` — update module name from pyenv to python, rename all function references and variable references

## 7. Update cross-references in zshenv

- [x] 7.1 Edit `zsh/zshenv` — replace `PYENV_ROOT` → `PYTHON_ROOT` in the `if ! type -p pyenv` block
- [x] 7.2 Edit `zsh/zshenv` — remove `PYENV_VIRTUALENV_DISABLE_PROMPT` since it lives in the module config now
- [x] 7.3 Edit `zsh/zshenv` — update `PIPENV_PYTHON="${PYENV_ROOT}/shims/python"` → `"${PYTHON_ROOT}/shims/python"` if kept

## 8. Update cross-references in clean module

- [x] 8.1 Edit `zsh/modules/clean/pkg/base.zsh` — rename `cleanup::pyenv` → `cleanup::python::pyenv`
- [x] 8.2 Edit `zsh/modules/clean/pkg/base.zsh` — rename `cleanup::pyenv::virtualenvs` → `cleanup::python::virtualenvs`
- [x] 8.3 Edit `zsh/modules/clean/pkg/base.zsh` — update `PYENV_VIRTUALENV_CACHE_PATH` → `PYTHON_VIRTUALENV_CACHE_PATH`
- [x] 8.4 Edit `zsh/modules/clean/pkg/base.zsh` — update `PYENV_VIRTUALENV_PATH` → `PYTHON_VIRTUALENV_PATH`

## 9. Update core-messages references

- [x] 9.1 Edit `zsh/core/config/env.zsh` — add `CORE_MESSAGE_PYTHON` referencing `zsh/modules/python/` (if not already present; the old `CORE_MESSAGE_PYENV` was planned but never created)
- [x] 9.2 Verify no remaining references to `CORE_MESSAGE_PYENV` in the repo

## 10. Update specs references

- [x] 10.1 Edit `openspec/specs/core-messages/spec.md` — update "CORE_MESSAGE_PYENV" scenario to reference `CORE_MESSAGE_PYTHON` and `zsh/modules/python/`

## 11. Final validation

- [x] 11.1 Run `grep -rn "pyenv" zsh/ --include="*.zsh" --include="*.toml" --include="*.md" | grep -v "PYENV_NAME" | grep -v "openspec/changes/" | grep -v "pyenv_version_name" | grep -v "CHANGELOG.md"` — confirm zero remaining references to old names
- [x] 11.2 Run `lsp_diagnostics` on all edited files to catch syntax errors
- [x] 11.3 Run `zsh -n zsh/modules/python/plugin.zsh` to validate syntax
