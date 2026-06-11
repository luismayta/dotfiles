## ADDED Requirements

### Requirement: Resources font sync source in data/fonts/

The resources module SHALL have its font sync source directory under `data/fonts/` instead of `assets/fonts/`.

#### Scenario: Directory renamed to data/fonts/

- **WHEN** the resources module is initialized
- **THEN** the font sync source SHALL be at `RESOURCES_PATH/data/fonts/`

#### Scenario: Config variable defined

- **WHEN** the resources module config loads
- **THEN** a `RESOURCES_DATA_PATH` variable SHALL point to `$RESOURCES_PATH/data/`

#### Scenario: Sync function uses data/fonts/

- **WHEN** the resources sync function runs
- **THEN** it SHALL rsync from `$RESOURCES_DATA_PATH/fonts/` to the destination