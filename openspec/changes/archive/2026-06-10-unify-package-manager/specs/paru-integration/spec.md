## ADDED Requirements

### Requirement: paru PATH is configured on Linux

When running on Linux (CachyOS/Arch), the paru binary SHALL be available in `PATH`. The configuration layer (`zsh/core/config/linux.zsh`) SHALL ensure the standard paru installation paths are included.

#### Scenario: paru in PATH
- **WHEN** a zsh session starts on Linux with CachyOS/Arch
- **THEN** `type -p paru` SHALL resolve successfully

### Requirement: Clear error message when paru is missing

If `paru` is not installed on a Linux system, calling `core::install` SHALL print a descriptive warning message using the `CORE_MESSAGE_PARU` variable, guiding the user to install paru.

#### Scenario: paru not found warning
- **WHEN** `core::install <package>` is called on Linux and `paru` is not found
- **THEN** the system SHALL print: `[WARNING]: Please install paru or use the paru module at zsh/modules/paru`

### Requirement: archlinux.sh uses paru consistently

The `archlinux.sh` script SHALL use `paru` instead of `yay` for all AUR package installations, matching the `install.sh` bootstrap script.

#### Scenario: archlinux.sh package install
- **WHEN** `archlinux.sh` is sourced on an Arch-based system
- **THEN** all package installations SHALL use `paru -S --noconfirm <package>`

### Requirement: No apt-get references on Linux

The codebase SHALL NOT contain `apt-get` installation paths, as the project only supports CachyOS/Arch on Linux.

#### Scenario: apt-get removed from ghq module
- **WHEN** `zsh/modules/ghq/internal/base.zsh` is loaded on Linux
- **THEN** it SHALL use `paru -S --noconfirm ghq` instead of falling back to `apt-get`