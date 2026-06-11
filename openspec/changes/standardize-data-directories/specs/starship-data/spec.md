## ADDED Requirements

### Requirement: Starship sync source in data/

The starship module SHALL have its sync source under `data/` with a default `starship.toml` provisioned for sync.

#### Scenario: data/ directory created

- **WHEN** the starship module is initialized
- **THEN** the sync source SHALL be at `STARSHIP_PATH/data/`

#### Scenario: Config variable defined

- **WHEN** the starship module config loads
- **THEN** a `STARSHIP_DATA_PATH` variable SHALL point to `$STARSHIP_PATH/data/`

#### Scenario: Default config provisioned

- **WHEN** the data/ directory is created
- **THEN** a `$STARSHIP_DATA_PATH/starship.toml` SHALL exist with a minimal default configuration

#### Scenario: Sync function uses data/

- **WHEN** the starship sync function runs
- **THEN** it SHALL rsync from `$STARSHIP_DATA_PATH/` to the destination (`~/.config/`)