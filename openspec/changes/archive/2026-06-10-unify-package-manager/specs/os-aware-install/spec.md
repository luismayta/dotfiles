## ADDED Requirements

### Requirement: `core::install` uses OS-specific override pattern

The `core::internal::core::install()` function SHALL use zsh function override across OS-specific files:

- **api.zsh**: Base definition that prints an error for unsupported OS and returns non-zero
- **osx.zsh**: Override with `brew install <packages>` (moved from api.zsh)
- **linux.zsh**: Override with `paru -S --noconfirm <packages>` (new)
- No conditional dispatch (`$OSTYPE` checks) in api.zsh — the override is achieved by load order (api.zsh loaded first, then osx.zsh or linux.zsh)

#### Scenario: Install package on macOS
- **WHEN** `core::install ripgrep` is called on a system where `$OSTYPE` starts with `darwin`
- **THEN** the function SHALL execute `brew install ripgrep`

#### Scenario: Install package on Linux (CachyOS/Arch)
- **WHEN** `core::install ripgrep` is called on a system where `$OSTYPE` starts with `linux`
- **THEN** the function SHALL execute `paru -S --noconfirm ripgrep`

#### Scenario: Package manager not found on macOS
- **WHEN** `core::install ripgrep` is called on macOS but `brew` is not installed
- **THEN** the function SHALL print the `CORE_MESSAGE_BREW` warning and skip installation

#### Scenario: Package manager not found on Linux
- **WHEN** `core::install ripgrep` is called on Linux but `paru` is not installed
- **THEN** the function SHALL print the `CORE_MESSAGE_PARU` warning and skip installation

### Requirement: `core::ensure` works cross-platform

The `core::ensure` function (which calls `core::exists` → `core::install`) SHALL work identically on both macOS and Linux without caller changes.

#### Scenario: Ensure package on macOS
- **WHEN** `core::ensure ripgrep` is called on macOS and ripgrep is not installed
- **THEN** `core::exists ripgrep` returns false and `core::install ripgrep` is invoked, which runs `brew install ripgrep`

#### Scenario: Ensure package on Linux
- **WHEN** `core::ensure ripgrep` is called on Linux and ripgrep is not installed
- **THEN** `core::exists ripgrep` returns false and `core::install ripgrep` is invoked, which runs `paru -S --noconfirm ripgrep`

### Requirement: `core::multiplatform::install` dispatches by OS

The `core::internal::multiplatform::install()` function SHALL be implemented (currently a no-op warning) and SHALL:
- On macOS: execute brew bundle or install platform-specific packages
- On Linux: execute paru group installs or install platform-specific packages

#### Scenario: Multiplatform install on macOS
- **WHEN** `core::multiplatform::install` is called on macOS
- **THEN** it SHALL execute the macOS-specific platform install logic

#### Scenario: Multiplatform install on Linux
- **WHEN** `core::multiplatform::install` is called on Linux
- **THEN** it SHALL execute the Linux-specific platform install logic
