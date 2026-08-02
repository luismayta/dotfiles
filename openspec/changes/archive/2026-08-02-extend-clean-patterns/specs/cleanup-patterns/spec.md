## ADDED Requirements

### Requirement: Comprehensive build artifact patterns
The system SHALL clean common build output directories by basename match within the current tree.

#### Scenario: Build directories are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `build`, `dist`, `out`, `release`, `debug`, or `target` exist in the tree
- **THEN** system removes them
- **AND** displays each removed directory

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
- **AND** directories named `.scannerwork`, `.terragrunt-cache`, `.terraform`, `.gradle`, `.cargo`, `.lycheecache`, or `.cq` exist in the tree
- **THEN** system removes them

### Requirement: Coverage and log patterns
The system SHALL clean coverage output directories and log files.

#### Scenario: Coverage directories are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `.coverage` or `coverage.out` exist in the tree
- **THEN** system removes them

#### Scenario: Log files are removed
- **WHEN** user runs `cleanup`
- **AND** files matching `*.log` exist in the tree
- **THEN** system deletes them

### Requirement: Temporary and OS artifact patterns
The system SHALL clean temporary directories and cross-platform OS artifacts.

#### Scenario: Temporary directories are removed
- **WHEN** user runs `cleanup`
- **AND** directories named `tmp`, `temp`, or `.tmp` exist in the tree
- **THEN** system removes them

#### Scenario: OS metadata files are removed
- **WHEN** user runs `cleanup`
- **AND** files named `Thumbs.db` or `Desktop.ini` exist in the tree
- **THEN** system deletes them
