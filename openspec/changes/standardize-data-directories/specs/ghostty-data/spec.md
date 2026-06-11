## ADDED Requirements

### Requirement: Ghostty sync source in data/

The ghostty module SHALL have its sync source directory under `data/` instead of `conf/`.

#### Scenario: Directory renamed to data/

- **WHEN** the ghostty module is initialized
- **THEN** the sync source SHALL be at `GHOSTTY_PATH/data/` (not `GHOSTTY_PATH/conf/`)

#### Scenario: Config variable defined

- **WHEN** the ghostty module config loads
- **THEN** a `GHOSTTY_DATA_PATH` variable SHALL point to `$GHOSTTY_PATH/data/`

#### Scenario: Sync function uses data/

- **WHEN** the ghostty sync function runs
- **THEN** it SHALL rsync from `$GHOSTTY_DATA_PATH/` to the destination (`~/.config/ghostty/`)