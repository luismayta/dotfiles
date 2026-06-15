## MODIFIED Requirements

### Requirement: Package installation skips already-installed packages
The system SHALL only install a package if it is not already present on the system.

#### Scenario: Package already installed
- **WHEN** `apps::internal::packages::install()` is called and a package in `APPS_PACKAGES` is already installed
- **THEN** the system SHALL skip installation for that package

#### Scenario: Package not installed
- **WHEN** `apps::internal::packages::install()` is called and a package in `APPS_PACKAGES` is not installed
- **THEN** the system SHALL install that package
