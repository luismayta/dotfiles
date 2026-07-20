# cleanup-modern-tools Specification

## Purpose
TBD - created by archiving change improve-zsh-clean-module. Update Purpose after archive.
## Requirements
### Requirement: Rust/Cargo cache cleanup
The system SHALL clean Rust and Cargo build caches.

#### Scenario: Clean cargo registry cache
- **WHEN** user runs `cleanup::cargo`
- **AND** cargo is installed
- **THEN** system removes `${HOME}/.cargo/registry/cache`
- **AND** removes `${HOME}/.cargo/registry/src`
- **AND** displays count of cleaned items

#### Scenario: Cargo not installed
- **WHEN** user runs `cleanup::cargo`
- **AND** cargo is not installed
- **THEN** system displays warning "cargo not found, skipping"

### Requirement: Go modules cache cleanup
The system SHALL clean Go module caches.

#### Scenario: Clean go module cache
- **WHEN** user runs `cleanup::go`
- **AND** go is installed
- **THEN** system runs `go clean -modcache`
- **AND** displays success message

#### Scenario: Go not installed
- **WHEN** user runs `cleanup::go`
- **AND** go is not installed
- **THEN** system displays warning "go not found, skipping"

### Requirement: Bun package manager cache cleanup
The system SHALL clean Bun package manager caches.

#### Scenario: Clean bun cache
- **WHEN** user runs `cleanup::bun`
- **AND** bun is installed
- **THEN** system removes `${HOME}/.bun/install/cache`
- **AND** displays success message

#### Scenario: Bun not installed
- **WHEN** user runs `cleanup::bun`
- **AND** bun is not installed
- **THEN** system displays warning "bun not found, skipping"

### Requirement: pnpm package manager cache cleanup
The system SHALL clean pnpm package manager caches.

#### Scenario: Clean pnpm store
- **WHEN** user runs `cleanup::pnpm`
- **AND** pnpm is installed
- **THEN** system runs `pnpm store prune`
- **AND** displays success message

#### Scenario: pnpm not installed
- **WHEN** user runs `cleanup::pnpm`
- **AND** pnpm is not installed
- **THEN** system displays warning "pnpm not found, skipping"

### Requirement: ccache cleanup
The system SHALL clean compiler cache.

#### Scenario: Clean ccache
- **WHEN** user runs `cleanup::ccache`
- **AND** ccache is installed
- **THEN** system runs `ccache --clear`
- **AND** displays success message

#### Scenario: ccache not installed
- **WHEN** user runs `cleanup::ccache`
- **AND** ccache is not installed
- **THEN** system displays warning "ccache not found, skipping"

### Requirement: Docker volumes cleanup
The system SHALL clean unused Docker volumes.

#### Scenario: Clean docker volumes
- **WHEN** user runs `cleanup::docker::volumes`
- **AND** docker is installed
- **THEN** system runs `docker volume prune -f`
- **AND** displays count of removed volumes

#### Scenario: Docker not installed
- **WHEN** user runs `cleanup::docker::volumes`
- **AND** docker is not installed
- **THEN** system displays warning "docker not found, skipping"

### Requirement: Integration with cleanup::all
The system SHALL include modern tool cleanup in the main cleanup function.

#### Scenario: cleanup::all includes modern tools
- **WHEN** user runs `cleanup::all`
- **THEN** system executes cleanup for cargo, go, bun, pnpm, ccache, and docker volumes
- **AND** displays progress for each tool

