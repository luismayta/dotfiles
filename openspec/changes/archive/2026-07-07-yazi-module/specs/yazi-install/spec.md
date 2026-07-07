## ADDED Requirements

### Requirement: Auto-install yazi binary

The system SHALL install yazi when the binary is not found in $PATH. On Arch Linux, it SHALL use `pacman -S yazi`. On all other platforms (macOS, other Linux), it SHALL use `cargo install --locked yazi-fm yazi-cli`.

#### Scenario: Yazi not installed on Arch Linux
- **WHEN** the module loads and `core::exists yazi` returns false on Arch Linux
- **THEN** the system runs `core::install yazi` (which executes `paru -S yazi`) to install yazi

#### Scenario: Yazi not installed on non-Arch (macOS, other Linux)
- **WHEN** the module loads and `core::exists yazi` returns false on a non-Arch system
- **THEN** the system runs `cargo install --locked yazi-fm yazi-cli` to install yazi
- **AND** verifies the binary exists after installation

#### Scenario: Yazi already installed
- **WHEN** the module loads and `core::exists yazi` returns true
- **THEN** the system skips installation and continues loading

#### Scenario: Cargo not available for non-Arch install
- **WHEN** `core::exists cargo` returns false during install attempt
- **THEN** the system SHALL display a warning message with instructions to install Rust first
- **AND** SHALL NOT attempt the cargo install

### Requirement: Provide yazi::install public function

The system SHALL expose `yazi::install()` as a public function that delegates to `yazi::internal::install`.

#### Scenario: User calls yazi::install when yazi is missing
- **WHEN** user runs `yazi::install`
- **THEN** the function calls `yazi::internal::install`
- **AND** installs yazi via the platform-appropriate method

#### Scenario: User calls yazi::install when yazi exists
- **WHEN** user runs `yazi::install` and yazi is already in $PATH
- **THEN** the function displays an info message that yazi is already installed
- **AND** returns 0 without reinstalling
