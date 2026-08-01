## ADDED Requirements

### Requirement: Shell variables holding paths end in _PATH
All repo-defined shell environment variables that hold filesystem paths SHALL use the `_PATH` suffix. Variables holding non-path data (flags, names, arrays of options) SHALL NOT use the `_PATH` suffix.

#### Scenario: Repo-defined path variables use _PATH
- **WHEN** a repo-defined shell env var is assigned a filesystem path in `zsh/`, `provision/`, `bin/`, or `tools/`
- **THEN** the variable name SHALL end in `_PATH` (e.g. `DOTFILES_CORE_PATH`, `ZSH_NOTIFY_CONFIG_PATH`)

#### Scenario: Non-path variables do not use _PATH
- **WHEN** a repo-defined shell env var holds a flag, name, or option list
- **THEN** the variable name SHALL NOT end in `_PATH` (e.g. `ZSH_DISABLED_MODULES`, `DEVOPS_ATUIN_INIT_FLAGS`)

### Requirement: _DIR exceptions are explicit
The following variables SHALL keep the `_DIR` suffix as documented exceptions: `APPS_WEB_APPS_BUILD_DIR` (scratch/build directory) and third-party-owned variables (`SDKMAN_DIR`, `XDG_RUNTIME_DIR`, `XDG_CONFIG_HOME`).

#### Scenario: Build directory keeps _DIR
- **WHEN** `APPS_WEB_APPS_BUILD_DIR` is referenced in `zsh/modules/apps/`
- **THEN** it SHALL keep its `_DIR` name (semantic build/scratch directory, not a config path)

#### Scenario: Third-party variables are not renamed
- **WHEN** `SDKMAN_DIR`, `XDG_RUNTIME_DIR`, or `XDG_CONFIG_HOME` are referenced in the repo
- **THEN** they SHALL keep their original names (owned by third-party tools; renaming would break them)
