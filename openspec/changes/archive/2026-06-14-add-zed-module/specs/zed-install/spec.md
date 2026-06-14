## ADDED Requirements

### Requirement: Install Zed Editor
The system SHALL install the Zed Editor using the official install script when requested.

#### Scenario: Successful installation
- **WHEN** `zed::install` is called and Zed is not already installed
- **THEN** the system downloads and runs the official Zed install script from `https://zed.dev/install.sh`
- **THEN** the system reports success with `message_success`

#### Scenario: Zed already installed
- **WHEN** `zed::install` is called and Zed is already present
- **THEN** the system returns immediately without downloading anything

#### Scenario: curl not available
- **WHEN** `zed::install` is called and `curl` is not installed
- **THEN** the system reports an error with `message_error` and returns exit code 1

#### Scenario: Install script fails
- **WHEN** the Zed install script exits with a non-zero status
- **THEN** the system reports an error with `message_error` and returns exit code 1

### Requirement: Detect Zed Editor presence
The system SHALL provide a function to check if Zed Editor is installed.

#### Scenario: Zed is installed
- **WHEN** `zed::exists` is called and `zed` binary is found in PATH
- **THEN** the system returns truthy

#### Scenario: Zed is not installed
- **WHEN** `zed::exists` is called and `zed` binary is not found
- **THEN** the system returns falsy
