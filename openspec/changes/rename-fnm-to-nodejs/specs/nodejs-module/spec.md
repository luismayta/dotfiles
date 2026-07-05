## MODIFIED Requirements

### Requirement: Node.js module loads on shell start
The `zsh/modules/nodejs/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with nodejs functions available
- **WHEN** a shell starts
- **THEN** all `nodejs::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_NODEJS_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `nodejs/plugin.zsh` is sourced a second time
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
- **WHEN** `nodejs::internal::version::all::install` is called
- **THEN** each version in `NODEJS_VERSIONS` SHALL be installed via `fnm install` and `fnm use` SHALL switch to `NODEJS_VERSION_GLOBAL`

#### Scenario: Version global install
- **WHEN** `nodejs::internal::version::global::install` is called
- **THEN** `NODEJS_VERSION_GLOBAL` SHALL be installed and aliased as default

### Requirement: NPM package manager
The module SHALL install npm packages defined in `NODEJS_PACKAGES` array via `yarn global add` (after installing yarn through npm if missing).

#### Scenario: NPM packages install
- **WHEN** `nodejs::internal::packages::install` is called
- **THEN** yarn SHALL be installed globally if missing, then all packages in `NODEJS_PACKAGES` SHALL be installed via `yarn global add`

### Requirement: Dependency check before install
The module SHALL verify `curl` and `unzip` are available before attempting fnm installation, installing them via `core::install` if missing.

#### Scenario: Missing curl dependency
- **WHEN** `curl` is not available before fnm install
- **THEN** it SHALL be installed via `core::install curl` first

#### Scenario: Missing unzip dependency
- **WHEN** `unzip` is not available before fnm install
- **THEN** it SHALL be installed via `core::install unzip` first

### Requirement: Post-install hook
The module SHALL provide `nodejs::post_install` for post-installation setup.

#### Scenario: Post-install runs
- **WHEN** `nodejs::post_install` is called
- **THEN** it SHALL print success message for `NODEJS_TOOL_NAME`
