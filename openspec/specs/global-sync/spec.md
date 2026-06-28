# global-sync Specification

## Purpose
TBD - created by archiving change dotfiles-sync-global. Update Purpose after archive.
## Requirements
### Requirement: Unified sync entry point

The system SHALL provide a single function `dotfiles::sync` that executes all registered module sync functions in a deterministic order.

#### Scenario: Invoke dotfiles::sync
- **WHEN** user runs `dotfiles::sync`
- **THEN** all registered module sync functions SHALL be executed in order
- **AND** a per-module status report SHALL be printed at the end

#### Scenario: Explicit module list
- **WHEN** `dotfiles::sync` executes
- **THEN** it SHALL use a declarative ordered list, not autodiscovery
- **AND** the list SHALL be defined in `zsh/core/pkg/sync.zsh`

#### Scenario: Disabled module skipped
- **WHEN** a module has `ZSH_<MODULE>_ENABLED=false`
- **THEN** `dotfiles::sync` SHALL skip its sync function
- **AND** report it as "skipped" in the final summary

### Requirement: Deterministic execution order

The system SHALL execute sync functions in a defined order that respects implicit dependencies.

#### Scenario: Ordering by category
- **WHEN** `dotfiles::sync` runs
- **THEN** terminal emulator syncs SHALL run first
- **AND** prompt syncs SHALL run after terminals
- **AND** tool syncs (git, ssh, editor) SHALL run after prompts
- **AND** remaining tool syncs SHALL run last

#### Scenario: Order preserved on re-run
- **WHEN** `dotfiles::sync` runs multiple times
- **THEN** the execution order SHALL be identical each time

### Requirement: Failure isolation

A failure in one module sync SHALL NOT prevent subsequent module syncs from executing.

#### Scenario: Single module fails
- **WHEN** a module sync returns a non-zero exit code
- **THEN** `dotfiles::sync` SHALL continue to the next module
- **AND** the failed module SHALL be marked with ✗ in the final summary

#### Scenario: All modules complete
- **WHEN** all module syncs complete
- **THEN** `dotfiles::sync` SHALL print a final summary showing:
  - Total modules synced
  - Total errors
  - Total skipped

### Requirement: Existing sync functions preserved

The `dotfiles::sync` function SHALL NOT modify or replace any existing module-specific `::sync` functions.

#### Scenario: Individual sync still works
- **WHEN** user runs `ghostty::sync` directly
- **THEN** it SHALL behave exactly as before this change
- **AND** the global `dotfiles::sync` SHALL call the same function internally

