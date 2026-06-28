## Requirements

### Requirement: Python toolchain module toggles pyenv independently

The module SHALL respect `$PYTHON_PYENV_ENABLED` to enable or disable pyenv management.

#### Scenario: pyenv is skipped when disabled

- **WHEN** `$PYTHON_PYENV_ENABLED` is `false`
- **THEN** the module SHALL NOT install or load pyenv
- **AND** SHALL NOT install Python versions via pyenv

#### Scenario: pyenv is managed when enabled

- **WHEN** `$PYTHON_PYENV_ENABLED` is `true` (default)
- **THEN** the module SHALL manage pyenv installation, loading, and version management

### Requirement: Python toolchain module manages pyenv installation

The module SHALL manage the installation and loading of `pyenv` (Python version manager) at `$PYTHON_ROOT` (default: `$HOME/.pyenv`).

#### Scenario: Module loads pyenv into PATH

- **WHEN** the python module's `internal/main.zsh` is sourced
- **THEN** `$PYTHON_ROOT_BIN` (`$PYTHON_ROOT/bin`) SHALL be prepended to `$PATH`
- **AND** `$PYTHON_ROOT/shims` SHALL be prepended to `$PATH`

#### Scenario: Module installs pyenv if missing

- **WHEN** `pyenv` is not found on the system after loading
- **THEN** the module SHALL clone `$PYTHON_INSTALL_URL` into `$PYTHON_ROOT`

#### Scenario: Module installs configured Python versions

- **WHEN** the module initializes
- **THEN** it SHALL iterate `$PYTHON_VERSIONS` and install each via `pyenv install` if not already installed
- **AND** set `$PYTHON_VERSION_GLOBAL` as the global version

### Requirement: Python toolchain module manages pip modules

The module SHALL install configured Python packages via `pip`/`pipx`.

#### Scenario: Module installs configured Python modules

- **WHEN** the module initializes and pyenv is ready
- **THEN** each package in `$PYTHON_MODULES` SHALL be installed via `python -m pip install --user --upgrade` if not already present

#### Scenario: Module installs poetry via pipx

- **WHEN** the module initializes and pyenv is ready
- **THEN** `poetry` SHALL be installed via `pipx` if not already present

### Requirement: Python toolchain module manages uv installation

The module SHALL manage `uv` (astral-sh/uv) as a first-class Python tool, enabled via `$PYTHON_UV_ENABLED`.

#### Scenario: uv is installed when enabled

- **WHEN** `$PYTHON_UV_ENABLED` is `true` and `uv` is not found
- **THEN** the module SHALL install `uv` via `core::ensure uv`

#### Scenario: uv installation is skipped when disabled

- **WHEN** `$PYTHON_UV_ENABLED` is `false`
- **THEN** the module SHALL NOT attempt to install or load `uv`

#### Scenario: uv shell completions are generated

- **WHEN** `$PYTHON_UV_ENABLED` is `true` and `uv` is installed
- **THEN** the module SHALL generate completions via `uv generate-shell-completion zsh`
- **AND** source them for the current session

### Requirement: Python toolchain module exposes public API

The module SHALL expose public functions under the `python::` namespace.

#### Scenario: python::version::global is callable

- **WHEN** `python::version::global` is called
- **THEN** it SHALL set the global pyenv version to `$PYTHON_VERSION_GLOBAL`

#### Scenario: python::module::install is callable

- **WHEN** `python::module::install <package>` is called
- **THEN** it SHALL install the package via `python -m pip install --user --upgrade <package>`

#### Scenario: python::info displays module state

- **WHEN** `python::info` is called
- **THEN** it SHALL display the current Python and uv versions, pyenv root, uv status, pyenv toggle state, uv toggle state, and installed modules

### Requirement: Module defines idempotent loading guard

The module SHALL prevent double-loading via an idempotency guard variable.

#### Scenario: Module guard prevents double source

- **WHEN** `plugin.zsh` is sourced more than once
- **THEN** the second source SHALL exit immediately via `__ZSH_PYTHON_LOADED` guard
