## ADDED Requirements

### Requirement: The system SHALL categorize desktop applications by functional group
The apps config SHALL define separate array variables for each application category: IDE Tools, JetBrains, Communication, Knowledge, DevOps, Database Clients, Browser, Android, Mobile, VPN Clients, Project Management, and Web Apps — following the existing structure in `config/base.zsh`.

#### Scenario: Category arrays are defined
- **WHEN** the apps config is loaded
- **THEN** each category SHALL have its own array variable prefixed with `APPS_` followed by the category name in UPPER_SNAKE_CASE (e.g., `APPS_BROWSER`, `APPS_DEVOPS`)

### Requirement: The system SHALL resolve app names per operating system using __DARWIN / __LINUX suffix arrays
Each category SHALL define two OS-specific raw arrays with `__DARWIN` and `__LINUX` suffixes. The public `APPS_<CATEGORY>` array SHALL be populated at load time based on `$OSTYPE`. The existing architecture of `config/base.zsh` + `config/osx.zsh` + `config/linux.zsh` SHALL be preserved.

#### Scenario: macOS app names are selected on Darwin
- **WHEN** `$OSTYPE` matches `darwin*`
- **THEN** `APPS_<CATEGORY>` SHALL contain the values from `APPS_<CATEGORY>__DARWIN`

#### Scenario: Arch Linux app names are selected on Linux
- **WHEN** `$OSTYPE` matches `linux*`
- **THEN** `APPS_<CATEGORY>` SHALL contain the values from `APPS_<CATEGORY>__LINUX`, using Arch Linux package names (official or AUR)

#### Scenario: Unknown OS falls back to Darwin names
- **WHEN** `$OSTYPE` matches neither `darwin*` nor `linux*`
- **THEN** `APPS_<CATEGORY>` SHALL default to the `__DARWIN` values

### Requirement: The OS-specific config files SHALL remain for exclusive apps
`config/osx.zsh` SHALL continue to define macOS-only apps (raycast, unite, orbstack, arc, tunnelblick) appended to `APPS_PACKAGES`. `config/linux.zsh` SHALL be populated with Linux-only apps when applicable. These files SHALL NOT duplicate apps already defined in `base.zsh`.

#### Scenario: OSX config adds macOS-only apps
- **WHEN** the config is loaded on macOS
- **THEN** `APPS_PACKAGES` SHALL include macOS-only apps from `config/osx.zsh` (raycast, unite, orbstack, arc, tunnelblick)

#### Scenario: Linux config can be populated with Linux-only apps
- **WHEN** the config is loaded on Linux
- **THEN** `APPS_PACKAGES` MAY include Linux-only apps from `config/linux.zsh` if defined

### Requirement: The config file SHALL follow goenv module formatting conventions
The file SHALL include a `#!/usr/bin/env ksh` shebang, encoding header, file description block with `File:` and `Description:` fields, a `shellcheck shell=bash` directive, section header comments, and inline variable documentation — matching `zsh/modules/goenv/config/base.zsh`.

#### Scenario: File header structure is applied
- **WHEN** the apps base config file is opened
- **THEN** it SHALL contain a shebang, an encoding comment, a file description block, and sectioned variable declarations with inline comments

### Requirement: The system SHALL preserve the APPS_PACKAGES aggregate
The `APPS_PACKAGES` array SHALL continue to merge all resolved `APPS_<CATEGORY>` arrays plus OS-specific extras into a single list, unchanged in behavior.

#### Scenario: APPS_PACKAGES aggregates all categories
- **WHEN** the config is loaded
- **THEN** `APPS_PACKAGES` SHALL contain the flattened union of all resolved `APPS_<CATEGORY>` arrays and OS-specific extras
