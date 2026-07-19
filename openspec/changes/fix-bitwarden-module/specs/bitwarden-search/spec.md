## MODIFIED Requirements

### Requirement: Search functions surface authentication errors

The system SHALL display error messages when Bitwarden CLI operations fail due to authentication issues.

#### Scenario: Authentication failure during search
- **WHEN** `bw::search` is invoked
- **AND** the Bitwarden CLI is not logged in or the session has expired
- **THEN** the system SHALL display a warning message indicating the authentication failure
- **AND** the system SHALL NOT silently swallow the error

#### Scenario: Authentication failure during typed search
- **WHEN** `bw::search::*` is invoked
- **AND** the Bitwarden CLI is not logged in or the session has expired
- **THEN** the system SHALL display a warning message indicating the authentication failure
- **AND** the system SHALL NOT silently swallow the error

## ADDED Requirements

### Requirement: Error display uses message_warning

The system SHALL use the `message_warning` function to display authentication errors.

#### Scenario: Warning message format
- **WHEN** an authentication error occurs
- **THEN** the system SHALL call `message_warning` with a descriptive error message
- **AND** the message SHALL include the specific error from the Bitwarden CLI

### Requirement: Search returns empty on error

The system SHALL return empty results when a Bitwarden CLI operation fails.

#### Scenario: Error handling
- **WHEN** `bw list items` fails
- **THEN** the system SHALL return an empty result set
- **AND** the system SHALL display a warning message
