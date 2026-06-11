## ADDED Requirements

### Requirement: Module loads with idempotency guard
The rvm module SHALL define a `__ZSH_RVM_LOADED` guard variable to prevent double-loading.

#### Scenario: First load initializes module
- **WHEN** `plugin.zsh` is sourced for the first time
- **THEN** it SHALL set `__ZSH_RVM_LOADED=1`
- **THEN** it SHALL source config, internal, and pkg layers

#### Scenario: Subsequent loads are skipped
- **WHEN** `plugin.zsh` is sourced again
- **THEN** it SHALL return immediately if `__ZSH_RVM_LOADED` is already set

### Requirement: RVM installation
The module SHALL support installing RVM via the official installer script, including GPG key import.

#### Scenario: Full RVM install
- **WHEN** `rvm::install` is called
- **THEN** the system SHALL import required GPG keys
- **THEN** the system SHALL download and run the RVM installer
- **THEN** the system SHALL load RVM into the current shell
- **WHEN** on macOS with OpenSSL@3
- **THEN** the system SHALL ensure OpenSSL@3 is installed via Homebrew before RVM install

### Requirement: RVM loading
The module SHALL load RVM into the current shell environment by sourcing RVM scripts and adding RVM bin to PATH.

#### Scenario: Load RVM
- **WHEN** `rvm::load` is called
- **THEN** `RVM_ROOT/bin` SHALL be added to PATH
- **THEN** `RVM_ROOT/scripts/rvm` SHALL be sourced if it exists

### Requirement: Ruby version management
The module SHALL support installing specific Ruby versions via RVM.

#### Scenario: Install specific version
- **WHEN** `rvm::install::version::global` is called
- **THEN** the version defined in `RVM_VERSION_GLOBAL` SHALL be installed
- **THEN** that version SHALL be set as the default

#### Scenario: Install all configured versions
- **WHEN** `rvm::install::versions` is called
- **THEN** all versions in `RVM_VERSIONS` array SHALL be installed
- **THEN** `RVM_VERSION_GLOBAL` SHALL be set as the default

### Requirement: Gem packages installation
The module SHALL support installing a predefined set of Ruby gem packages.

#### Scenario: Install gem packages
- **WHEN** `rvm::package::all::install` is called
- **THEN** the system SHALL install all gems listed in `RVM_PACKAGES`

### Requirement: macOS OpenSSL@3 integration
On macOS, Ruby compilation SHALL use the Homebrew-installed OpenSSL@3 library path.

#### Scenario: Compile Ruby with OpenSSL@3
- **WHEN** installing a Ruby version on macOS
- **THEN** the install command SHALL include `--with-openssl-dir=$(brew --prefix openssl@3)`
- **THEN** `/opt/homebrew/opt/openssl@3.0/bin` SHALL be added to PATH

### Requirement: Auto-install on shell start
The module SHALL attempt to load RVM on shell startup and install it if not present.

#### Scenario: Shell start without RVM
- **WHEN** the module loads and RVM is not installed
- **THEN** `core::ensure` SHALL install curl and gpg if missing
- **THEN** RVM SHALL be installed automatically