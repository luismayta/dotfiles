## MODIFIED Requirements

### Requirement: Consolidated cleanup functions
The system SHALL consolidate duplicate cleanup logic into unified functions, with all directory/file patterns declared in module configuration rather than hardcoded in implementation, no pattern swept twice, and all patterns swept in a single consolidated `find` invocation.

#### Scenario: cleanup::unnecessary integrated into cleanup
- **WHEN** user runs `cleanup`
- **THEN** system executes all unnecessary file cleanup patterns
- **AND** does not call separate `cleanup::unnecessary` function

#### Scenario: All patterns swept in a single find invocation
- **WHEN** cleanup operations execute
- **THEN** all directory patterns are evaluated by one consolidated find command per sweep operation
- **AND** all file patterns are evaluated by one separate consolidated find command per sweep operation
- **AND** no per-pattern `find` command executes

#### Scenario: No duplicate pattern matching
- **WHEN** cleanup operations execute
- **THEN** each file pattern is matched only once
- **AND** the consolidated `find` expression contains no duplicate pattern terms

#### Scenario: Dedicated functions own their patterns
- **WHEN** user runs `cleanup::all`
- **THEN** patterns with dedicated functions (`cleanup::terraform` for `.terraform`, `cleanup::tasks` for `.task`) are handled only by those functions
- **AND** the base pattern list does not duplicate them

#### Scenario: All patterns sourced from configuration
- **WHEN** `_cleanup::unnecessary` executes
- **THEN** directory patterns come from `ZSH_CLEAN_BASE_DIR_PATTERNS` merged with `ZSH_CLEAN_USER_DIR_PATTERNS`
- **AND** file patterns come from `ZSH_CLEAN_BASE_FILE_PATTERNS` merged with `ZSH_CLEAN_USER_FILE_PATTERNS`
- **AND** no additional patterns are hardcoded inside `internal/base.zsh`

#### Scenario: Consolidated sweep reports grouped counts
- **WHEN** the consolidated sweep finds items
- **THEN** system reports the total item count and the affected pattern groups before removing them
