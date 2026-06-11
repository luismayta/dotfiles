## ADDED Requirements

### Requirement: Function call names resolve to existing definitions

All `namespace::function` call expressions in `.sh` and `.zsh` files SHALL reference a function name that has a corresponding `function namespace::function {` definition elsewhere in the codebase.

#### Scenario: Cross-reference passes for all files
- **WHEN** a static analysis tool scans all `.sh` and `.zsh` files
- **THEN** every `name::function` call expression SHALL have a matching `function name::function {` definition
- **AND** the analysis SHALL report any unmatched calls as errors

#### Scenario: Case-sensitive matching
- **WHEN** comparing a call site against definitions
- **THEN** the comparison SHALL be case-sensitive
- **AND** differing capitalization (e.g. `Goenv` vs `goenv`) SHALL be treated as a mismatch

#### Scenario: Namespace segment count matches
- **WHEN** a call uses a fully-qualified name (e.g. `starship::internal::starship::install`)
- **THEN** the definition SHALL use the identical number of namespace segments
- **AND** extra or missing segments SHALL be treated as a mismatch
