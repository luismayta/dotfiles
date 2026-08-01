## ADDED Requirements

### Requirement: Support Ubuntu/Debian and Arch Linux distributions
The install script SHALL support Ubuntu/Debian (apt) and Arch-based distributions (Arch/CachyOS, paru), rejecting any other Linux distribution.

#### Scenario: Ubuntu/Debian accepted
- **WHEN** the install script runs on Ubuntu or Debian
- **THEN** setup SHALL proceed using `apt-get`

#### Scenario: Arch-based accepted
- **WHEN** the install script runs on Arch or CachyOS
- **THEN** setup SHALL proceed using `paru`

#### Scenario: Unsupported distribution rejected
- **WHEN** the install script runs on another Linux distribution
- **THEN** it SHALL print an error and exit non-zero

### Requirement: Install system dependencies via native package manager
The system SHALL install system-level dependencies using the native package manager: `apt-get` on Ubuntu/Debian and `paru -S --noconfirm` on Arch Linux.

#### Scenario: System dependencies installed on Ubuntu/Debian
- **WHEN** the install script runs on an Ubuntu/Debian system
- **THEN** the declared dependencies SHALL be installed via `apt-get install -y`

#### Scenario: System dependencies installed on Arch Linux
- **WHEN** the install script runs on an Arch Linux system
- **THEN** the declared dependencies SHALL be installed via `paru -S --noconfirm`

#### Scenario: Dependency already installed
- **WHEN** a declared dependency is already installed
- **THEN** the script SHALL skip reinstalling it

### Requirement: Configure additional repositories
The system SHALL configure additional repositories required by the tools before installing them: apt repositories/PPAs on Ubuntu/Debian; AUR access via paru on Arch Linux.

#### Scenario: Missing apt repository is added
- **WHEN** a required apt repository is not configured on Ubuntu/Debian
- **THEN** the script SHALL add it and refresh the package index with `apt-get update`

#### Scenario: apt repository already configured
- **WHEN** a required apt repository is already configured
- **THEN** the script SHALL not duplicate its configuration

#### Scenario: paru available on Arch Linux
- **WHEN** the install script runs on Arch Linux and `paru` is not installed
- **THEN** `paru` SHALL be installed from the AUR (makepkg) or via chaotic-aur — never `pacman -S paru` from official repos

### Requirement: Install modern tools
The system SHALL install modern development tools (mise, devbox, starship, etc.) after system dependencies and repositories are configured.

#### Scenario: Modern tools installed on Arch
- **WHEN** system dependencies and repositories are ready on Arch Linux
- **THEN** each declared modern tool SHALL be installed via `paru` (AUR packages)

#### Scenario: Modern tools installed on Ubuntu/Debian
- **WHEN** system dependencies and repositories are ready on Ubuntu/Debian
- **THEN** each declared modern tool SHALL be installed via apt (official repos) or by its zsh module installer via `core::install`

### Requirement: Idempotent execution
Re-running the install script on the same system SHALL reach the same final state without errors or duplicates.

#### Scenario: Second run
- **WHEN** the script is executed a second time on the same system
- **THEN** already-present packages SHALL NOT be reinstalled

#### Scenario: No pending changes
- **WHEN** all dependencies and tools are already installed
- **THEN** the script SHALL exit successfully without modifying the system
