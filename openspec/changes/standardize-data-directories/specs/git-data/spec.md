## ADDED Requirements

### Requirement: Git sync and hooks sources in data/

The git module SHALL have its sync sources unified under `data/` — `sync/` and `template/git/hooks/` SHALL move to `data/sync/` and `data/hooks/` respectively.

#### Scenario: sync/ renamed to data/sync/

- **WHEN** the git module is initialized
- **THEN** the general sync source SHALL be at `GIT_PATH/data/sync/`

#### Scenario: hooks/ renamed to data/hooks/

- **WHEN** the git module is initialized
- **THEN** the hooks source SHALL be at `GIT_PATH/data/hooks/`

#### Scenario: Config variables defined

- **WHEN** the git module config loads
- **THEN** `GIT_DATA_PATH` SHALL point to `$GIT_PATH/data/`

#### Scenario: Sync function uses data/sync/

- **WHEN** the git sync function runs
- **THEN** it SHALL rsync from `$GIT_DATA_PATH/sync/` to the destination

#### Scenario: Hooks function uses data/hooks/

- **WHEN** the git hooks sync function runs
- **THEN** it SHALL rsync from `$GIT_DATA_PATH/hooks/` to the provision directory

#### Scenario: Hooks directory created if missing

- **WHEN** the git module is initialized
- **THEN** `$GIT_PATH/data/hooks/` SHALL exist (created with `.gitkeep` if no hooks are present)