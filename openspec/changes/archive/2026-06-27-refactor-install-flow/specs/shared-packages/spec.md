## ADDED Requirements

### Requirement: Install common packages via shared function
The bootstrap SHALL define a `setup::packages::common` function that installs packages needed on both macOS and Linux.
This function SHALL be called from both `setup::mac` and `setup::linux`.
The common packages SHALL be: `zsh`, `git`, `rsync`, `ksh`, `fd`.
Platform-specific packages SHALL remain in their respective `setup::mac` / `setup::linux` functions.

#### Scenario: Common packages on macOS
- **WHEN** `setup::mac` runs after Homebrew is installed
- **THEN** it SHALL call `setup::packages::common` after installing platform-specific packages

#### Scenario: Common packages on Linux
- **WHEN** `setup::linux` runs after paru is installed
- **THEN** it SHALL call `setup::packages::common` after installing platform-specific packages

### Requirement: Batch install on Linux
The Linux package installer SHALL pass all packages as a single argument list to `paru -S --noconfirm` instead of looping per package.

#### Scenario: All packages installed in one transaction
- **WHEN** `setup::linux` installs packages
- **THEN** `paru -S --noconfirm "${packages[@]}"` SHALL be called once with the full array
- **AND** NOT in a for loop

### Requirement: Idempotent shell change
The bootstrap SHALL only run `sudo chsh` when the current shell is not already set to the target Zsh path.
The target Zsh path SHALL be resolved dynamically via `command -v zsh` into a `ZSH_PATH` constant.

#### Scenario: Already using Zsh
- **WHEN** `$SHELL` equals the resolved `ZSH_PATH`
- **THEN** `sudo chsh` SHALL NOT be executed

#### Scenario: Not using Zsh
- **WHEN** `$SHELL` differs from the resolved `ZSH_PATH`
- **THEN** `sudo chsh -s "$ZSH_PATH" "$USER"` SHALL be executed
