## ADDED Requirements

### Requirement: Spec validation uses loadfile instead of dofile
The `auto-import.lua` script SHALL use `loadfile(path)()` instead of `dofile(path)` for spec validation to prevent execution of top-level side effects.

#### Scenario: Validation does not execute side effects
- **WHEN** `auto-import.lua` validates a spec file that has a top-level `print()` or `vim.cmd()` call
- **THEN** those calls SHALL NOT execute during validation
- **AND** the file SHALL still be validated for correct table return type
