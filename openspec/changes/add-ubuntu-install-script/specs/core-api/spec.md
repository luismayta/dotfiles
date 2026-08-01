## ADDED Requirements

### Requirement: core::install supports apt on Ubuntu/Debian
The system SHALL delegate `core::install <tool>` to the native package manager on Linux: `apt-get` on Ubuntu/Debian and `paru -S --noconfirm` on Arch/CachyOS.

#### Scenario: core::install delegates to apt on Ubuntu/Debian
- **WHEN** `core::install <tool>` is called on Ubuntu or Debian
- **THEN** the function SHALL delegate to `apt-get install -y <tool>`

#### Scenario: core::install delegates to paru on Arch
- **WHEN** `core::install <tool>` is called on Arch or CachyOS
- **THEN** the function SHALL delegate to `paru -S --noconfirm <tool>`
