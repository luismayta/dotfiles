## ADDED Requirements

### Requirement: Declarative package lists in config file
The system SHALL define all installable packages in `config/packages.sh` as arrays, organized by category.

`config/packages.sh` SHALL define:
- `PACKAGES_COMMON` — packages installed on every OS (zsh, git, rsync, ksh, fd)
- `PACKAGES_MAC` — packages installed only on macOS
- `PACKAGES_LINUX` — packages installed only on Linux

The installer functions (`setup::mac`, `setup::linux`) SHALL iterate the corresponding array.

`setup::packages::ensure_common` SHALL iterate `PACKAGES_COMMON` and call `brew install` (macOS) or `paru -S` (Linux) for each package.

`setup::mac::packages` SHALL iterate `PACKAGES_MAC` and call `brew install` (or `brew install --cask` as appropriate).

`setup::linux::packages` SHALL iterate `PACKAGES_LINUX` using batch `paru -S --noconfirm "${PACKAGES_LINUX[@]}"`.

#### Scenario: install.sh sources config/packages.sh
- **WHEN** `install.sh` starts
- **THEN** it SHALL source `config/packages.sh` to load all package arrays

#### Scenario: adding a new package requires one file change
- **WHEN** a developer adds a package to `PACKAGES_COMMON` in `config/packages.sh`
- **THEN** it SHALL be installed on both macOS and Linux without modifying any installer function

#### Scenario: Linux batch install uses shared array
- **WHEN** `setup::linux` runs
- **THEN** it SHALL call `paru -S --noconfirm "${PACKAGES_LINUX[@]}"` (single transaction, no loop)
