## ADDED Requirements

### Requirement: fd auto-install in core

The `zsh/core/pkg/helper/core.zsh` SHALL auto-install `fd` via `core::install fd` if not already present, since `fd` is used by `FZF_CTRL_T_COMMAND`, `fa`, and `fo` functions.

#### Scenario: fd auto-install on macOS
- **WHEN** `zsh/core/pkg/helper/core.zsh` loads on macOS and `fd` is not installed
- **THEN** `core::exists fd` returns false
- **AND** `core::install fd` is invoked, which runs `brew install fd`

#### Scenario: fd auto-install on Linux
- **WHEN** `zsh/core/pkg/helper/core.zsh` loads on Linux (CachyOS/Arch) and `fd` is not installed
- **THEN** `core::exists fd` returns false
- **AND** `core::install fd` is invoked, which runs `paru -S --noconfirm fd`
