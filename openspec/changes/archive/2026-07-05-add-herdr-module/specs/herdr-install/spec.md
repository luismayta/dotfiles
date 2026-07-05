## ADDED Requirements

### Requirement: Auto-install herdr binary
The system SHALL automatically install the herdr binary when the module is loaded and herdr is not in `$PATH`.

#### Scenario: herdr not installed on first load
- **WHEN** the herdr module is sourced
- **THEN** the install function SHALL detect herdr is absent via `core::exists herdr`
- **THEN** the install function SHALL run `curl -fsSL https://herdr.dev/install.sh` piped to `sh`
- **THEN** the install function SHALL verify herdr is available after installation via `core::exists herdr`

#### Scenario: herdr already installed
- **WHEN** the herdr module is sourced and herdr is already in `$PATH`
- **THEN** the system SHALL skip installation and log `message_info "${HERDR_PACKAGE_NAME} is already installed."`

#### Scenario: install script fails
- **WHEN** the primary install script fails (non-zero exit)
- **THEN** the system SHALL attempt fallback via `brew install herdr` on macOS
- **THEN** the system SHALL log `message_error` if both methods fail
- **THEN** the system SHALL return exit code 1

### Requirement: Dependency management
The system SHALL ensure `curl` is available before attempting installation.

#### Scenario: curl missing before install
- **WHEN** the install function is called
- **THEN** `core::ensure curl` SHALL run first to install curl if missing

### Requirement: Public install command
The system SHALL expose `herdr::install` as a user-callable function.

#### Scenario: user invokes herdr::install
- **WHEN** the user runs `herdr::install`
- **THEN** the system SHALL delegate to `herdr::internal::install`
- **THEN** the system SHALL report success or failure via `message_*` functions
