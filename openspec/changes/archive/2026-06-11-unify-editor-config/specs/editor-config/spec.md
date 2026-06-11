## ADDED Requirements

### Requirement: EDITOR fallback defined once in core

The `EDITOR` environment variable SHALL have a default fallback defined in `zsh/core/config/env.zsh`. The fallback SHALL NOT override an already-set `EDITOR` value. No other file SHALL define or export an `EDITOR` fallback.

#### Scenario: EDITOR not set in environment
- **WHEN** `zsh/core/config/env.zsh` is sourced and `EDITOR` is not set
- **THEN** `EDITOR` SHALL be set to `nvim`

#### Scenario: EDITOR already set in environment
- **WHEN** `zsh/core/config/env.zsh` is sourced and `EDITOR` is already set (e.g. `EDITOR=vim`)
- **THEN** `EDITOR` SHALL retain its existing value

### Requirement: Module-level EDITOR fallbacks removed

Each module that currently defines an `EDITOR` fallback SHALL have it removed. No `zsh/modules/*/config/base.zsh` file SHALL export or assign `EDITOR`.

#### Scenario: tmux module loaded
- **WHEN** `zsh/modules/tmux/config/base.zsh` is sourced
- **THEN** it SHALL NOT assign or export `EDITOR`

#### Scenario: ghq module loaded
- **WHEN** `zsh/modules/ghq/config/base.zsh` is sourced
- **THEN** it SHALL NOT assign or export `EDITOR`

#### Scenario: nvim module loaded
- **WHEN** `zsh/modules/nvim/config/base.zsh` is sourced
- **THEN** it SHALL NOT assign or export `EDITOR`

### Requirement: Redundant vim function removed from aliases module

The `function vim` defined in `zsh/modules/aliases/internal/editor.zsh` SHALL be removed. The nvim module already provides a correct `vim` → `nvim` passthrough in `zsh/modules/nvim/pkg/alias.zsh`.

#### Scenario: aliases module loaded
- **WHEN** `zsh/modules/aliases/internal/editor.zsh` is sourced
- **THEN** it SHALL NOT define a `function vim`
