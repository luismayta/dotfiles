# cleanup-patterns Specification

## Purpose
TBD - created by archiving change extend-clean-patterns. Update Purpose after archive.
## Requirements
### Requirement: Comprehensive build artifact patterns
The system SHALL clean common build output directories by basename match within the current tree, excluding generic names reserved for opt-in aggressive cleanup.

#### Scenario: Build directories are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `build`, `dist`, `out`, `release`, `debug`, or `target` exist in the tree
- **AND** `ZSH_CLEAN_AGGRESSIVE_PATTERNS` includes those names
- **THEN** system removes them
- **AND** displays each removed directory

#### Scenario: Generic build names not cleaned by default
- **WHEN** user runs `cleanup`
- **AND** `ZSH_CLEAN_AGGRESSIVE_PATTERNS` is not set
- **THEN** system does not remove directories named `build`, `dist`, `out`, `release`, `debug`, or `target`

#### Scenario: CMake artifacts are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `CMakeFiles` or `Testing` exist, or directories matching `cmake-build-*`
- **THEN** system removes them

### Requirement: Tooling and dependency cache patterns
The system SHALL clean tooling cache and dependency directories matched by basename.

#### Scenario: JavaScript/build tool caches are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `.turbo`, `.parcel-cache`, `.svelte-kit`, `.angular`, or `.cache-loader` exist in the tree
- **THEN** system removes them

#### Scenario: Python tooling caches are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `.ruff_cache`, `.pyre`, `.tox`, `.nox`, or `pip-wheel-metadata` exist in the tree
- **THEN** system removes them

#### Scenario: Infrastructure tool caches are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `.scannerwork`, `.terragrunt-cache`, `.gradle`, `.cargo`, `.lycheecache`, or `.cq` exist in the tree
- **THEN** system removes them

### Requirement: Coverage and log patterns
The system SHALL clean coverage output directories and log files.

#### Scenario: Coverage directories are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `.coverage` exist in the tree
- **THEN** system removes them

#### Scenario: Coverage data file is removed
- **WHEN** user runs `cleanup`
- **AND** a file named `coverage.out` exists in the tree
- **THEN** system deletes it

#### Scenario: Log files are removed
- **WHEN** user runs `cleanup`
- **AND** files matching `*.log` exist in the tree
- **THEN** system deletes them

### Requirement: Temporary and OS artifact patterns
The system SHALL clean temporary directories and cross-platform OS artifacts, excluding generic temporary names reserved for opt-in aggressive cleanup.

#### Scenario: Temporary directories removed when opted in
- **WHEN** user runs `cleanup`
- **AND** directories named `tmp`, `temp`, or `.tmp` exist in the tree
- **AND** `ZSH_CLEAN_AGGRESSIVE_PATTERNS` includes those names
- **THEN** system removes them

#### Scenario: Generic temporary names not cleaned by default
- **WHEN** user runs `cleanup`
- **AND** `ZSH_CLEAN_AGGRESSIVE_PATTERNS` is not set
- **THEN** system does not remove directories named `tmp`, `temp`, or `.tmp`

#### Scenario: OS metadata files are removed
- **WHEN** user runs `cleanup`
- **AND** files named `Thumbs.db` or `Desktop.ini` exist in the tree
- **THEN** system deletes them
