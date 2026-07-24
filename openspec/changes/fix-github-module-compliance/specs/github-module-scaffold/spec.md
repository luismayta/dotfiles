## ADDED Requirements

### Requirement: Module entry point follows standard conventions

The `zsh/modules/github/plugin.zsh` entry point SHALL use `${0:A:h}` for path resolution and `[[ -n "${__ZSH_GITHUB_LOADED:-}" ]] && return` as the guard pattern. The entry point SHALL display `message_info "Loading module: github"` and source the enabled toggle AFTER config sourcing.

#### Scenario: Guard prevents double-load
- **WHEN** the module is loaded a second time
- **THEN** the guard SHALL prevent re-sourcing

#### Scenario: Path resolution uses plugin directory
- **WHEN** the module is sourced from any path
- **THEN** `${0:A:h}` SHALL resolve to the module's root directory

#### Scenario: Loading message displayed
- **WHEN** the module is sourced
- **THEN** `message_info "Loading module: github"` SHALL be displayed

### Requirement: Module has 3-layer main.zsh structure

The `zsh/modules/github/` directory SHALL contain `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`. Each `main.zsh` SHALL dispatch to OS-specific files and source the appropriate layer files.

#### Scenario: config/main.zsh sources config layer
- **WHEN** config/main.zsh is sourced
- **THEN** it SHALL source `config/base.zsh` and OS-specific config

#### Scenario: internal/main.zsh sources internal layer
- **WHEN** internal/main.zsh is sourced
- **THEN** it SHALL source `internal/base.zsh` and OS-specific internal files

#### Scenario: pkg/main.zsh sources pkg layer
- **WHEN** pkg/main.zsh is sourced
- **THEN** it SHALL source `pkg/base.zsh`, `pkg/helper.zsh`, `pkg/alias.zsh`, and OS-specific pkg files

### Requirement: Module has OS-specific placeholder files

The `zsh/modules/github/` directory SHALL contain placeholder files: `config/osx.zsh`, `config/linux.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`. Each placeholder SHALL be a minimal 2-line comment file.

#### Scenario: All placeholder files exist
- **WHEN** the module directory is enumerated
- **THEN** all 6 OS placeholder files SHALL exist

### Requirement: Config layer has enabled toggle

The `zsh/modules/github/config/base.zsh` SHALL define `ZSH_GITHUB_ENABLED` with a default value.

#### Scenario: Enabled toggle defined
- **WHEN** config/base.zsh is sourced
- **THEN** `ZSH_GITHUB_ENABLED` SHALL be defined

### Requirement: pkg layer has orchestrator and alias separation

The `zsh/modules/github/pkg/` directory SHALL contain `helper.zsh` with a `github::setup` orchestrator function and `alias.zsh` with the `ghd` alias and `editghdash` function.

#### Scenario: helper.zsh exists with setup function
- **WHEN** pkg/helper.zsh is sourced
- **THEN** `github::setup` SHALL be defined

#### Scenario: alias.zsh exists with aliases
- **WHEN** pkg/alias.zsh is sourced
- **THEN** the `ghd` alias SHALL be available
- **THEN** `editghdash` function SHALL be available
