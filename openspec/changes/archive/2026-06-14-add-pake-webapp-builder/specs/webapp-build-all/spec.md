## ADDED Requirements

### Requirement: Build all configured web apps

The system SHALL provide a function to build all web apps listed in the `APPS_WEB_APPS_BUILD` config array.

#### Scenario: Build all configured web apps successfully
- **WHEN** `APPS_WEB_APPS_BUILD` contains `"Jira:https://codip.atlassian.net"` and the user calls `apps::webapp::all::build`
- **THEN** the system SHALL parse each `name:url` entry and call `apps::internal::webapp::build` for each
- **THEN** the system SHALL log a success message when all builds complete

#### Scenario: Build all with empty config
- **WHEN** `APPS_WEB_APPS_BUILD` is empty and the user calls `apps::webapp::all::build`
- **THEN** the system SHALL log an informational message that no web apps are configured
- **THEN** the system SHALL return successfully

#### Scenario: Build all with partial failures
- **WHEN** `APPS_WEB_APPS_BUILD` contains multiple entries and one build fails
- **THEN** the system SHALL log an error for the failed entry
- **THEN** the system SHALL continue building the remaining entries

#### Scenario: Public function delegates to internal
- **WHEN** the user calls `apps::webapp::all::build`
- **THEN** the system SHALL delegate to `apps::internal::webapp::all::build`
