## ADDED Requirements

### Requirement: Configurable cmdline-tools version

The system SHALL expose the Android cmdline-tools download version as a configurable environment variable.

ANDROID_CMDLINE_TOOLS_VERSION SHALL default to `11076708` if not explicitly set.

The download URL in `internal/base.zsh` SHALL use the variable instead of the hardcoded version string.

#### Scenario: Default version used when no override set

- **WHEN** the mobile module loads without `ANDROID_CMDLINE_TOOLS_VERSION` being set in the environment
- **THEN** the cmdline-tools download URL uses version `11076708`

#### Scenario: Custom version via environment variable

- **WHEN** `ANDROID_CMDLINE_TOOLS_VERSION` is set to `12345678` before the mobile module loads
- **THEN** the cmdline-tools download URL uses version `12345678`

#### Scenario: Version defined in config/android.zsh

- **WHEN** the user sets `export ANDROID_CMDLINE_TOOLS_VERSION=99999999` in a zsh config file sourced before the mobile module
- **THEN** the cmdline-tools download URL uses version `99999999`
