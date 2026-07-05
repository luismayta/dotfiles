## ADDED Requirements

### Requirement: Orchestrated setup command
The system SHALL provide `herdr::setup` as a composed orchestrator that installs herdr if missing and syncs configuration.

#### Scenario: setup with herdr not installed
- **WHEN** `herdr::setup` is called and herdr is not in `$PATH`
- **THEN** `herdr::install` SHALL be called first
- **THEN** `herdr::sync` SHALL be called
- **THEN** `message_success` SHALL report setup complete

#### Scenario: setup with herdr already installed
- **WHEN** `herdr::setup` is called and herdr is already in `$PATH`
- **THEN** the system SHALL log `message_info "${HERDR_PACKAGE_NAME} is already installed."`
- **THEN** `herdr::sync` SHALL still run
- **THEN** `message_success` SHALL report setup complete

#### Scenario: setup with install failure
- **WHEN** `herdr::setup` is called and `herdr::install` fails
- **THEN** `herdr::sync` SHALL NOT run
- **THEN** `message_error` SHALL report the failure
- **THEN** the function SHALL return exit code 1

### Requirement: Post-install hook
The system SHALL provide `herdr::post_install` that runs sync and reports completion.

#### Scenario: post_install is called
- **WHEN** `herdr::post_install` is called
- **THEN** the system SHALL call `herdr::sync`
- **THEN** `message_success` SHALL log "Post Install herdr"
