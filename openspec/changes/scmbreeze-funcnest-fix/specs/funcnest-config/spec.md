## ADDED Requirements

### Requirement: FUNCNEST is raised in core env before any module loads

The core env configuration SHALL set `FUNCNEST` to a minimum of 5000 in `zsh/core/config/env.zsh`, so it is in effect before any module (including scmbreeze) loads.

#### Scenario: FUNCNEST is exported in core/env.zsh
- **WHEN** the shell starts
- **AND** `zsh/core/config/env.zsh` is sourced
- **THEN** `FUNCNEST` SHALL be set to at least `5000` and exported

#### Scenario: SCM Breeze loads after FUNCNEST is set
- **WHEN** `scmbreeze::internal::load` is called
- **AND** `FUNCNEST` is already set to `5000`
- **THEN** `scmb_expand_args` SHALL NOT hit the recursion limit during git status shortcut expansion
