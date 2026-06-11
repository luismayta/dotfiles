## ADDED Requirements

### Requirement: Module syncs opencode config
The system SHALL synchronize OpenCode configuration files from the module's data directory to `~/.config/opencode/`.

#### Scenario: Sync opencode config files
- **WHEN** `ai::opencode::sync` is called
- **THEN** files from `AI_OPENCODE_CONFIG_SOURCE_PATH` (`$AI_PATH/data/opencode/`) are rsynced to `AI_OPENCODE_CONFIG_PATH` (`~/.config/opencode/`)

#### Scenario: Sync creates target directories
- **WHEN** `ai::opencode::sync` is called and target directories do not exist
- **THEN** directories are created before rsync runs

#### Scenario: Sync opencode runtime config
- **WHEN** `ai::opencode::sync` is called
- **THEN** files from `AI_OPENCODE_RUNTIME_SOURCE_PATH` (`$AI_PATH/.opencode/`) are rsynced to `AI_OPENCODE_RUNTIME_CONFIG_PATH` (`~/.config/opencode/.opencode/`), excluding `node_modules`

#### Scenario: Sync fails without rsync
- **WHEN** `ai::opencode::sync` is called and rsync is not installed
- **THEN** an error message is displayed and the function returns 1

### Requirement: Module syncs fabric patterns
The system SHALL synchronize Fabric AI patterns from the module's data directory to `~/.config/fabric/patterns/`.

#### Scenario: Sync fabric patterns to config
- **WHEN** `ai::fabric::patterns::sync` is called
- **THEN** files from `AI_FABRIC_PATTERNS_SYNC_SOURCE` (`$AI_PATH/data/patterns/`) are rsynced with delete to `AI_FABRIC_PATTERNS_PATH` (`~/.config/fabric/patterns/`)

#### Scenario: Sync fails if source missing
- **WHEN** `ai::fabric::patterns::sync` is called and the patterns source directory does not exist
- **THEN** a warning is displayed and the function returns 1

### Requirement: Module pulls fabric patterns from remote
The system SHALL support pulling the latest fabric patterns from the fabric CLI itself.

#### Scenario: Pull remote fabric patterns
- **WHEN** `ai::fabric::patterns::pull` is called and fabric is installed
- **THEN** `fabric --updatepatterns` is executed

#### Scenario: Pull fails without fabric
- **WHEN** `ai::fabric::patterns::pull` is called and fabric is not installed
- **THEN** an error message is displayed and the function returns 1