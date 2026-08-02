# cleanup-home-guard Specification

## Purpose
TBD - created by archiving change guard-clean-home. Update Purpose after archive.
## Requirements
### Requirement: Cleanup refuses to run from HOME
The system SHALL not run tree-based cleanup when the current directory is the user's home directory.

#### Scenario: cleanup aborts at $HOME
- **WHEN** user runs `cleanup`
- **AND** `$PWD` equals `$HOME`
- **THEN** system aborts the tree cleanup
- **AND** displays a warning explaining that `$HOME` contains personal caches
- **AND** suggests running from a project directory or using `cleanup::all`

#### Scenario: cleanup::all aborts tree phase at $HOME
- **WHEN** user runs `cleanup::all`
- **AND** `$PWD` equals `$HOME`
- **THEN** system skips the tree-pattern phase
- **AND** still runs the HOME-based cache cleanup functions (which confirm individually)

#### Scenario: cleanup::projects protected
- **WHEN** user runs `cleanup::projects`
- **AND** `$PROJECTS` is set
- **THEN** system operates in `$PROJECTS` (not `$HOME`)
- **AND** the guard still applies if `$PROJECTS` resolves to `$HOME`

#### Scenario: Force overrides the guard
- **WHEN** user runs cleanup with `ZSH_CLEAN_FORCE=true` or `--force`
- **THEN** system executes the tree cleanup even from `$HOME`
- **AND** displays a prominent warning before proceeding
