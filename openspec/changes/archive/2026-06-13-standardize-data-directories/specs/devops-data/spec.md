## ADDED Requirements

### Requirement: Devops k9s config source in data/k9s/

The devops module SHALL have its k9s config sync source under `data/k9s/` instead of `conf/k9s/`.

#### Scenario: Directory renamed to data/k9s/

- **WHEN** the devops module is initialized
- **THEN** the k9s sync source SHALL be at `DEVOPS_PATH/data/k9s/` (not `DEVOPS_PATH/conf/k9s/`)

#### Scenario: Config variable defined

- **WHEN** the devops module config loads
- **THEN** `DEVOPS_DATA_PATH` SHALL point to `$DEVOPS_PATH/data/`

#### Scenario: Sync function uses data/k9s/

- **WHEN** the devops k9s sync function runs
- **THEN** it SHALL rsync from `$DEVOPS_DATA_PATH/k9s/` to the destination