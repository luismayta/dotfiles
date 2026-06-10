## ADDED Requirements

### Requirement: FNM module loads on shell start
The `zsh/modules/fnm/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with fnm functions available
- **WHEN** a shell starts
- **THEN** all `fnm::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_FNM_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `fnm/plugin.zsh` is sourced a second time
- **THEN** it SHALL return immediately without re-executing

### Requirement: FNM binary auto-install
The module SHALL install FNM via the official install script if `fnm` is not found, after ensuring `curl` and `unzip` are available.

#### Scenario: Install on missing fnm
- **WHEN** `fnm` is not found and `curl` is available
- **THEN** the module SHALL run `curl -fsSL https://fnm.vercel.app/install | bash`

### Requirement: FNM binary PATH setup
The module SHALL add `~/.local/share/fnm` to `PATH` and evaluate `fnm env` when the FNM directory exists.

#### Scenario: FNM path configured
- **WHEN** `~/.local/share/fnm` exists
- **THEN** it SHALL be prepended to `PATH` and `eval "$(fnm env)"` SHALL be executed

### Requirement: Node.js version management
The module SHALL install specified Node.js versions via `fnm install` and set a default alias.

#### Scenario: Version all install
- **WHEN** `fnm::internal::version::all::install` is called
- **THEN** each version in `FNM_VERSIONS` SHALL be installed via `fnm install` and `fnm use` SHALL switch to `FNM_VERSION_GLOBAL`

#### Scenario: Version global install
- **WHEN** `fnm::internal::version::global::install` is called
- **THEN** `FNM_VERSION_GLOBAL` SHALL be installed and aliased as default

### Requirement: NPM package manager
The module SHALL install npm packages defined in `FNM_PACKAGES` array via `yarn global add` (after installing yarn through npm if missing).

#### Scenario: NPM packages install
- **WHEN** `fnm::internal::packages::install` is called
- **THEN** yarn SHALL be installed globally if missing, then all packages in `FNM_PACKAGES` SHALL be installed via `yarn global add`

### Requirement: Dependency check before install
The module SHALL verify `curl` and `unzip` are available before attempting fnm installation, installing them via `core::install` if missing.

#### Scenario: Missing curl dependency
- **WHEN** `curl` is not available before fnm install
- **THEN** it SHALL be installed via `core::install curl` first

#### Scenario: Missing unzip dependency
- **WHEN** `unzip` is not available before fnm install
- **THEN** it SHALL be installed via `core::install unzip` first

### Requirement: Post-install hook
The module SHALL provide `fnm::post_install` for post-installation setup.

#### Scenario: Post-install runs
- **WHEN** `fnm::post_install` is called
- **THEN** it SHALL print success message for `FNM_PACKAGE_NAME`
