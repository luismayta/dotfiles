## ADDED Requirements

### Requirement: Missing SCM Breeze aliases are ported to git module

The git module's `pkg/alias.zsh` SHALL include the following aliases that were previously provided by SCM Breeze but are absent from the current git module alias set:

- `gst` → `git stash`
- `gfa` → `git fetch --all`
- `gm` → `git merge`
- `grm` → `git rm`
- `gcp` → `git cherry-pick`
- `gbl` → `git blame`

These SHALL NOT duplicate any aliases already defined in `pkg/alias.zsh`. Aliases `gs`, `ga`, `gd`, `gA` SHALL NOT be added, as scmpuff already provides them.

#### Scenario: Alias file updated with new aliases
- **WHEN** `zsh/modules/git/pkg/alias.zsh` is inspected after migration
- **THEN** it SHALL contain new alias definitions for `gst`, `gfa`, `gm`, `grm`, `gcp`, `gbl`

#### Scenario: No duplicate aliases created
- **WHEN** all alias definitions in `zsh/modules/git/pkg/alias.zsh` are enumerated
- **THEN** there SHALL be no duplicate left-hand-side alias names

#### Scenario: New aliases work in shell
- **WHEN** a zsh shell sources the git module
- **THEN** `gst` SHALL invoke `git stash`, `gfa` SHALL invoke `git fetch --all`, etc.

### Requirement: scmbreeze module is removed

The entire `zsh/modules/scmbreeze/` directory SHALL be deleted with all its contents:

- `plugin.zsh`
- `config/main.zsh`, `config/base.zsh`, `config/osx.zsh`, `config/linux.zsh`
- `internal/main.zsh`, `internal/base.zsh`, `internal/osx.zsh`, `internal/linux.zsh`
- `pkg/main.zsh`, `pkg/base.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`
- `README.md`

No other file in the dotfiles SHALL reference `scmbreeze`, `scm_breeze`, `SCMBREEZE`, or `ZSH_SCMBREEZE` after migration (excluding git history).

#### Scenario: Module directory removed
- **WHEN** the filesystem under `zsh/modules/` is listed
- **THEN** `scmbreeze/` directory SHALL NOT exist

#### Scenario: No residual references to scmbreeze
- **WHEN** a grep for `scmbreeze|scm_breeze|SCMBREEZE|ZSH_SCMBREEZE` is run against all `.zsh` files in the dotfiles
- **THEN** there SHALL be zero matches (excluding git history)
