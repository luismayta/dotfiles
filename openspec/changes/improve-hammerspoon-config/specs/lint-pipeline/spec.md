## ADDED Requirements

### Requirement: Luacheck configuration

The project SHALL include a `.luacheckrc` file at the root of `zsh/modules/hammerspoon/data/` that configures linting for all Hammerspoon Lua files.

#### Scenario: Standard globals are configured
- **WHEN** luacheck runs against any `.lua` file in the data directory
- **THEN** the globals `hs` and `spoon` SHALL be pre-declared as read-only globals

#### Scenario: Correct Lua version
- **WHEN** luacheck validates the syntax
- **THEN** it SHALL use `std = "lua5.3"` (Lua version used by Hammerspoon)

#### Scenario: Files with --luacheck: globals are respected
- **WHEN** a file has a `-- luacheck: globals` comment
- **THEN** luacheck SHALL respect those file-level declarations without false positives

### Requirement: Validation in pre-commit pipeline

The existing project validation pipeline (Taskfile / pre-commit) SHALL include a luacheck step for Hammerspoon Lua files.

#### Scenario: Luacheck runs on commit
- **WHEN** a `.lua` file under `zsh/modules/hammerspoon/data/` is staged
- **THEN** the pre-commit hook SHALL run `luacheck` on that file and fail if warnings or errors are found

#### Scenario: All files pass with zero warnings
- **WHEN** `luacheck .` is run from `zsh/modules/hammerspoon/data/`
- **THEN** it SHALL exit with code 0 and produce zero warnings and zero errors (no suppressions except for the configured globals)
