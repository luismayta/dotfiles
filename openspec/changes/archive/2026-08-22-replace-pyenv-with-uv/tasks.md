## 1. Module Core — zsh/modules/python

- [x] 1.1 Edit `config/base.zsh`: remove pyenv variables (`PYTHON_PYENV_ENABLED`, `PYTHON_PACKAGE_NAME=pyenv`, `PYTHON_INSTALL_URL`, `~/.pyenv`-rooted `PYTHON_ROOT`/`PYTHON_ROOT_BIN`); keep `PYTHON_UV_ENABLED=true`; set `PYTHON_VERSION_GLOBAL=3.14`
- [x] 1.2 Edit `internal/base.zsh`: remove `python::internal::pyenv::install`/`::load` and pyenv version helpers; add uv-based equivalents (`uv python install "${PYTHON_VERSION_GLOBAL}"`, uv-managed default)
- [x] 1.3 Edit `internal/main.zsh`: drop pyenv dispatch and the `core::exists pyenv` guard; ensure uv when `PYTHON_UV_ENABLED` is true
- [x] 1.4 Edit `pkg/base.zsh` + `pkg/main.zsh`: repoint public API internals from `python::internal::pyenv::*` to the new uv internals
- [x] 1.5 Edit `plugin.zsh`: replace the luismayta/zsh-pyenv port comment with a uv-based module description
- [x] 1.6 Edit `README.md` + `README.yaml`: document uv-managed versions and Python 3.14 as default
- [x] 1.7 Install uv via official astral.sh installer script (create-module guide pattern) instead of package-manager ensure

## 2. Adjacent Runtime Wiring

- [x] 2.1 Edit `zsh/zshenv`: delete the pyenv block (`PYENV_ROOT`/PATH wiring, `PIPENV_PYTHON`, `PYENV_VIRTUALENV_DISABLE_PROMPT`)
- [x] 2.2 Edit `zsh/modules/clean/pkg/base.zsh`: RETAIN `cleanup::python::pyenv` (Luchex overrode design D6 — kept as the legacy-pyenv-interpreter removal tool for migration machines)
- [x] 2.3 Edit `zsh/modules/starship/data/starship.toml`: remove `pyenv_version_name = true`
- [x] 2.4 Edit `zsh/system/core/config/env.zsh`: rewrite `CORE_MESSAGE_PYTHON` text to reference the python module / uv without mentioning pyenv

## 3. Version Sources of Truth

- [x] 3.1 Edit `nix/versions.nix`: `pythonVersion = "3.11"` → `"3.14"` with matching `pkgs.python314` attribute
- [x] 3.2 Edit `Taskfile.yml`: `PYTHON_VERSION: 3.11.5` → latest available 3.14.x patch (same minor as nix)

## 4. Verification

- [x] 4.1 Grep sweep: zero pyenv references in active code (`zsh/`, `nix/`, `Taskfile.yml`), excluding `openspec/` and `CHANGELOG.md`
- [x] 4.2 Lint/shellcheck all changed zsh files
- [x] 4.3 Fresh-shell smoke test: module loads, uv resolves Python 3.14 as default
