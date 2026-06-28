## ADDED Requirements

### Requirement: Configurable SDKMAN install path

The system SHALL expose the SDKMAN install directory path as a configurable environment variable.

`SDKMAN_DIR` SHALL default to `~/.sdkman` if not explicitly set.

The SDKMAN init script path in `internal/base.zsh` SHALL use the variable instead of the hardcoded path string.

#### Scenario: Default path used when no override set

- **WHEN** the mobile module loads without `SDKMAN_DIR` being set in the environment
- **THEN** the SDKMAN init script is sourced from `~/.sdkman/bin/sdkman-init.sh`

#### Scenario: Custom path via environment variable

- **WHEN** `SDKMAN_DIR` is set to `/opt/sdkman` before the mobile module loads
- **THEN** the SDKMAN init script is sourced from `/opt/sdkman/bin/sdkman-init.sh`

#### Scenario: SDKMAN_DIR aligns with SDKMAN's own convention

- **WHEN** SDKMAN itself is installed to a custom path via `export SDKMAN_DIR=/custom/path`
- **THEN** both the mobile module and SDKMAN use the same custom path
