# cleanup-aggressive-patterns Specification

## Purpose
TBD - created by archiving change harden-clean-safety. Update Purpose after archive.
## Requirements
### Requirement: Aggressive patterns are opt-in
The system SHALL keep generic directory names out of the default cleanup list, exposing them via a separate opt-in variable.

#### Scenario: Generic names not cleaned by default
- **WHEN** user runs `cleanup`
- **AND** `ZSH_CLEAN_AGGRESSIVE_PATTERNS` is not set
- **THEN** system does not remove directories named `build`, `dist`, `out`, `release`, `debug`, `target`, `vendor`, `tmp`, `temp`, `coverage`, `eggs`, or `venv`
- **AND** the default `ZSH_CLEAN_BASE_DIR_PATTERNS` excludes those names

#### Scenario: Generic names removed when opted in
- **WHEN** user sets `ZSH_CLEAN_AGGRESSIVE_PATTERNS="build|dist|target"` before module load
- **AND** runs `cleanup`
- **THEN** system removes matching directories named `build`, `dist`, or `target`
- **AND** still applies confirmation/dry-run guards

#### Scenario: No duplicates across lists
- **WHEN** cleanup executes
- **AND** a pattern is present in both `ZSH_CLEAN_BASE_DIR_PATTERNS` and `ZSH_CLEAN_AGGRESSIVE_PATTERNS`
- **THEN** system matches the pattern only once
