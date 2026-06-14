## ADDED Requirements

### Requirement: Build single web app from URL

The system SHALL provide a function to build a native desktop web app from a URL using pake.

#### Scenario: Build a web app successfully
- **WHEN** the user calls `apps::webapp::build "https://example.com" "MyApp"`
- **THEN** the system SHALL execute `pake https://example.com --name MyApp --width 1200 --height 800 --hide-title-bar --targets zst`
- **THEN** the system SHALL log a success message

#### Scenario: Build with missing URL
- **WHEN** the user calls `apps::webapp::build "" "MyApp"`
- **THEN** the system SHALL log an error indicating URL is required
- **THEN** the system SHALL return with a non-zero exit code

#### Scenario: Build with missing name
- **WHEN** the user calls `apps::webapp::build "https://example.com" ""`
- **THEN** the system SHALL log an error indicating name is required
- **THEN** the system SHALL return with a non-zero exit code

#### Scenario: Build when pake is not installed
- **WHEN** the user calls `apps::webapp::build "https://example.com" "MyApp"` and `pake` is not installed
- **THEN** the system SHALL log an error indicating pake is required
- **THEN** the system SHALL return with a non-zero exit code

#### Scenario: Public function delegates to internal
- **WHEN** the user calls `apps::webapp::build "https://example.com" "MyApp"`
- **THEN** the system SHALL delegate to `apps::internal::webapp::build "https://example.com" "MyApp"`
