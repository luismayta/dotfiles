## ADDED Requirements

### Requirement: Goenv module loads on shell start
The `zsh/modules/goenv/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with goenv functions available
- **WHEN** a shell starts
- **THEN** all `goenv::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_GOENV_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `goenv/plugin.zsh` is sourced a second time
- **THEN** it SHALL return immediately without re-executing

### Requirement: Config variables exported
The module SHALL export Go environment variables including `GOENV_ROOT`, `GOENV_ROOT_BIN`, `GOBREW_ROOT_BIN`, `GOBREW_CURRENT_BIN`, `GOBREW_DOWNLOAD_URL`, `GOENV_VERSIONS`, `GOENV_VERSION_GLOBAL`, `GOENV_INSTALL_PACKAGES`, `GO111MODULES`, and `ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH`.

#### Scenario: Config vars available after load
- **WHEN** the module is loaded
- **THEN** all config variables SHALL be exported and available in the shell environment

### Requirement: PATH and GOPATH setup
The module SHALL configure `PATH` and `GOPATH` for gobrew on load: unset `GOPATH`, prepend `~/.gobrew/current/bin` and `~/.gobrew/bin` to `PATH`, and set `GOPATH` to `~/.gobrew/current/go`.

#### Scenario: PATH configured on load
- **WHEN** the module is loaded and `~/.gobrew/bin` exists
- **THEN** `~/.gobrew/current/bin` and `~/.gobrew/bin` SHALL be prepended to `PATH` and `GOPATH` SHALL be set to `~/.gobrew/current/go`

### Requirement: gobrew auto-install
The module SHALL install gobrew if missing, using `curl -sLk <download_url> | sh`, after ensuring `curl` is available.

#### Scenario: Install gobrew on missing
- **WHEN** `gobrew` is not found and `curl` is available
- **THEN** the module SHALL run the gobrew install script and configure PATH

#### Scenario: Missing curl dependency
- **WHEN** `curl` is not available before gobrew install
- **THEN** it SHALL be installed via `core::install curl` first

### Requirement: Go version management
The module SHALL install Go versions via `gobrew install` and set a global default via `gobrew use`.

#### Scenario: Version all install
- **WHEN** `goenv::internal::version::all::install` is called
- **THEN** each version in `GOENV_VERSIONS` SHALL be installed via `gobrew install` and `gobrew use` SHALL switch to `GOENV_VERSION_GLOBAL`

#### Scenario: Version global install
- **WHEN** `goenv::internal::version::global::install` is called
- **THEN** `GOENV_VERSION_GLOBAL` SHALL be installed via `gobrew install` and activated via `gobrew use`

### Requirement: Go package management
The module SHALL install Go tool packages defined in `GOENV_INSTALL_PACKAGES` via `go install`.

#### Scenario: All packages install
- **WHEN** `goenv::internal::packages::install` is called
- **THEN** `golangci-lint` SHALL be installed first, then all packages in `GOENV_INSTALL_PACKAGES` SHALL be installed via `go install`

#### Scenario: Single package install
- **WHEN** `goenv::internal::package::install <pkg>` is called
- **THEN** the specified package SHALL be installed via `go install <pkg>`

### Requirement: gobrew upgrade
The module SHALL provide an upgrade mechanism for gobrew via `curl -sLk https://git.io/gobrew | sh`.

#### Scenario: Upgrade gobrew
- **WHEN** `goenv::internal::upgrade` is called
- **THEN** the gobrew installer SHALL be re-executed

### Requirement: Post-install hook
The module SHALL provide `goenv::post_install` for post-installation setup notification.

#### Scenario: Post-install runs
- **WHEN** `goenv::post_install` is called
- **THEN** it SHALL print a success message for `GOENV_PACKAGE_NAME`
