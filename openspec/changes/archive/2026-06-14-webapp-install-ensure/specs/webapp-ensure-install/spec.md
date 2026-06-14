## ADDED Requirements

### Requirement: Webapp functions in dedicated file
The system SHALL organize webapp lifecycle functions (build, install, ensure) in `internal/webapp.zsh`, separate from `internal/build.zsh`.

#### Scenario: File extraction
- **WHEN** the module is loaded
- **THEN** webapp functions SHALL be sourced from `internal/webapp.zsh` instead of `internal/build.zsh`

### Requirement: Webapp ensure install
The system SHALL provide an idempotent function that builds and installs all webapps defined in `APPS_WEB_APPS_BUILD`.

#### Scenario: All webapps installed
- **WHEN** `apps::internal::webapp::all::install()` is called and all webapps in `APPS_WEB_APPS_BUILD` are already built and installed
- **THEN** the system SHALL skip rebuild and reinstall for already-present webapps

#### Scenario: Webapp not yet built
- **WHEN** `apps::internal::webapp::all::install()` is called and a webapp artifact is missing
- **THEN** the system SHALL build the webapp via `apps::internal::webapp::build()` before installing

#### Scenario: Webapp built but not installed
- **WHEN** `apps::internal::webapp::all::install()` is called and a webapp artifact exists but is not installed
- **THEN** the system SHALL install the webapp via `apps::internal::webapp::install()`

### Requirement: Public API wrappers in pkg/
The system SHALL expose `apps::webapp::all::install()` and `apps::webapp::ensure()` as thin wrappers in `pkg/base.zsh`, mirroring the `apps::packages::install()` pattern.

#### Scenario: Public wrapper calls internal
- **WHEN** `apps::webapp::all::install()` is called
- **THEN** it SHALL delegate to `apps::internal::webapp::all::install()`

#### Scenario: Public ensure wrapper
- **WHEN** `apps::webapp::ensure()` is called
- **THEN** it SHALL delegate to `apps::internal::webapp::ensure()`
