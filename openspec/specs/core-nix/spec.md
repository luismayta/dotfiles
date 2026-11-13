# core-nix Specification

## Purpose
Provides shared behavior for installing and managing CLI tools via Nix profile installs with guards for binary existence, nix-darwin availability, and idempotent nix-tooling support.

## Requirements

### Requirement: Install nix package when missing

System SHALL install a nix package via the helper when the CLI binary referenced by the package's nixpkgs attribute is not in PATH.

#### Scenario: Package not installed

- **WHEN** the helper is invoked to install a package with reference `nixpkgs#<attr>` and the bin `<attr>` is not in PATH
- **THEN** system SHALL run `nix --extra-experimental-features 'nix-command flakes' profile install/add "<package>"`

#### Scenario: Package already installed

- **WHEN** the helper is invoked to install a package with reference `nixpkgs#<attr>` and the bin `<attr>` is already in PATH
- **THEN** system SHALL short-circuit and NOT invoke `nix profile`

### Requirement: Idempotent profile detection

System SHALL NOT reinstall a package if it is already installed in the user's nix profile, regardless of whether the binary is in PATH.

#### Scenario: Profile already contains package

- **WHEN** the helper is invoked to install a package whose nixpkgs attribute is present in the user profile's installed packages list
- **THEN** system SHALL short-circuit and NOT invoke `nix profile install`

### Requirement: Skip install when managed by nix-darwin

If nix-darwin is available (`ZSH_NIX_DARWIN_AVAILABLE=true`), the helper SHALL skip user-profile install and log a warning, deferring to the declarative system profile for ownership.

#### Scenario: nix-darwin manages the tool

- **WHEN** nix-darwin is available and the tool's label matches an installed nix-darwin output
- **THEN** system SHALL skip `nix profile install` and log a warning message

#### Scenario: User invokes helper despite nix-darwin

- **WHEN** nix-darwin is available and the helper is invoked
- **THEN** system SHALL run the helper from `nix-darwin` paths and prepend configuration to `PATH`

### Requirement: Require nix on system

System SHALL NOT auto-install nix itself through the helper; if nix is missing from all known profiles (default nix profile, `~/.nix-profile`, `/run/current-system/sw`, `/etc/profiles/per-user/`), the helper SHALL exit with error instead of silently failing.

#### Scenario: nix absent from all profiles

- **WHEN** nix binary is not found in any known profile paths after restoring nix PATH via standard fallback
- **THEN** system SHALL exit with error and include message instructing user to install nix externally

#### Scenario: nix aliased via hook but not native

- **WHEN** nix command succeeds after sourcing nix profile script but is not a native binary
- **THEN** system SHALL consider it available and continue

### Requirement: Upgrade existing package

Storage SHALL provide an upgrade hook that applies `nix profile upgrade <profile>` to the specified profile without requiring separate detection of installed packages.

#### Scenario: User invokes upgrade

- **WHEN** the helper is invoked to upgrade a package via the profile reference
- **THEN** system SHALL run `nix profile upgrade` on the profile

### Requirement: Feature-detect nix command verb

System SHALL probe `nix profile --help` once to determine whether the current nix version supports `nix profile add` vs `nix profile install` as the verb for adding packages, without branching on OS.

#### Scenario: nix supports install

- **WHEN** the feature probe for `nix profile --help` returns an `--help` output containing "profile install"
- **THEN** system SHALL use `nix profile install` for all package installs

#### Scenario: nix only supports add

- **WHEN** the feature probe returns output that mentions "profile add" instead of "profile install"
- **THEN** system SHALL use `nix profile add` for all package installs

### Requirement: Hybrid binary/package detection

System SHALL check binary existence separately from package presence in the profile, respecting that nix packages may not provide the binary directly (e.g., nix-direnv does not provide a `direnv` binary).

#### Scenario: Binary exists but package missing

- **WHEN** the binary `<bin>` is in PATH but the package `<pkg>` is not installed in the user profile
- **THEN** system SHALL proceed with `nix profile install/add` to install the missing package

#### Scenario: Package exists but binary missing

- **WHEN** the package `<pkg>` is present in the profile but the binary `<bin>` is not in PATH
- **THEN** system SHALL NOT install the package again