## ADDED Requirements

### Requirement: Skip Nix installation via environment flag
The bootstrap SHALL skip Nix installation when the environment variable `SKIP_NIX` is set to a non-empty value.
The check SHALL happen at the top of `setup::nix` before any installation logic.
When skipped, a message SHALL be displayed indicating Nix was skipped.

#### Scenario: SKIP_NIX is set
- **WHEN** `SKIP_NIX=true` is exported in the environment
- **THEN** `setup::nix` SHALL print "[INFO]: Skipping Nix installation (SKIP_NIX=true)" and return immediately
- **AND** no curl/download shall occur

#### Scenario: SKIP_NIX is unset (default)
- **WHEN** `SKIP_NIX` is not set or empty
- **THEN** `setup::nix` SHALL proceed with normal Nix installation

### Requirement: Install Nix via official script
The system SHALL install Nix single-user (`--no-daemon`) using the official script at `https://nixos.org/nix/install`.
After installation, `~/.nix-profile/etc/profile.d/nix.sh` SHALL be sourced for the current session.

#### Scenario: Successful Nix installation
- **WHEN** `setup::nix` runs and Nix is not already installed
- **THEN** the official Nix install script SHALL be downloaded and executed with `--no-daemon`
- **AND** the Nix profile SHALL be sourced for the current session

#### Scenario: Nix already installed
- **WHEN** `setup::nix` runs and `type -p nix` succeeds
- **THEN** `setup::nix` SHALL skip installation and return immediately
