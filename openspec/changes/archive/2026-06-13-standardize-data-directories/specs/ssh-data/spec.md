## ADDED Requirements

### Requirement: SSH config sync source in data/

The ssh module SHALL have its config sync source directory under `data/` instead of `conf/`.

#### Scenario: Directory renamed to data/

- **WHEN** the ssh module is initialized
- **THEN** the sync source SHALL be at `SSH_PATH/data/` (not `SSH_PATH/conf/`)

#### Scenario: Config variable defined

- **WHEN** the ssh module config loads
- **THEN** a `SSH_DATA_PATH` variable SHALL point to `$SSH_PATH/data/`

#### Scenario: Sync function uses data/

- **WHEN** the ssh sync function runs
- **THEN** it SHALL rsync from `$SSH_DATA_PATH/` to the destination (`~/.ssh/`)