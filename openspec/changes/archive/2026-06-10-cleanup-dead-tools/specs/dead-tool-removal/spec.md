## ADDED Requirements

### Requirement: Remove dead antibody tool installer
The system SHALL remove the `tools/antibody/` directory and its contents, as antibody is dead code replaced by antidote with no remaining callers.

#### Scenario: No remaining references to antibody
- **WHEN** searching the codebase for "antibody" after removal
- **THEN** no references to the antibody tool installer SHALL exist

### Requirement: Remove dead brew tool installer
The system SHALL remove the `tools/brew/` directory and its contents, as brew installation is handled by `install.sh:setup::mac()` and this script is never called.

#### Scenario: brew install.sh is removed
- **WHEN** inspecting the `tools/` directory
- **THEN** `tools/brew/install.sh` SHALL NOT exist

### Requirement: Remove dead wakatime tool installer
The system SHALL remove the `tools/wakatime/` directory and its contents, as wakatime is not in the `APPS` array and references undefined variables.

#### Scenario: wakatime install.sh is removed
- **WHEN** inspecting the `tools/` directory
- **THEN** `tools/wakatime/install.sh` SHALL NOT exist