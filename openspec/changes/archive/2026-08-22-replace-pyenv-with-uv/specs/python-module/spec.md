## MODIFIED Requirements

### Requirement: Python toolchain module manages pip modules

The module SHALL install configured Python packages via `pip`/`pipx`.

#### Scenario: Module installs configured Python modules

- **WHEN** the module initializes and uv is ready
- **THEN** each package in `$PYTHON_MODULES` SHALL be installed via `python -m pip install --user --upgrade` if not already present

#### Scenario: Module installs poetry via pipx

- **WHEN** the module initializes and uv is ready
- **THEN** `poetry` SHALL be installed via `pipx` if not already present

### Requirement: Python toolchain module exposes public API

The module SHALL expose public functions under the `python::` namespace.

#### Scenario: python::version::global is callable

- **WHEN** `python::version::global` is called
- **THEN** it SHALL ensure `$PYTHON_VERSION_GLOBAL` is installed via `uv python install`
- **AND** set it as the uv-managed default version

#### Scenario: python::module::install is callable

- **WHEN** `python::module::install <package>` is called
- **THEN** it SHALL install the package via `python -m pip install --user --upgrade <package>`

#### Scenario: python::info displays module state

- **WHEN** `python::info` is called
- **THEN** it SHALL display the current Python and uv versions, uv status, uv toggle state, and installed modules

## REMOVED Requirements

### Requirement: Python toolchain module toggles pyenv independently

**Reason**: pyenv is replaced by uv as the sole version manager (Jira HAD-100).

**Migration**: uv manages versions inside the same module, gated by `PYTHON_UV_ENABLED`; users migrate interpreters manually via `uv python install`.

### Requirement: Python toolchain module manages pyenv installation

**Reason**: pyenv is replaced by uv as the sole version manager (Jira HAD-100).

**Migration**: uv manages versions inside the same module, gated by `PYTHON_UV_ENABLED`; users migrate interpreters manually via `uv python install`.

## ADDED Requirements

### Requirement: Python toolchain module defaults to Python 3.14

The module SHALL establish Python 3.14 as the default global version when initialized.

#### Scenario: Module sets Python 3.14 as default global version

- **WHEN** the module initializes
- **THEN** the default Python version SHALL be 3.14
