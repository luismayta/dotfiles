## ADDED Requirements

### Requirement: Git environment variable configuration

The git module SHALL set `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1` in its config layer.

#### Scenario: Env var is exported on module load

- **WHEN** the git module loads
- **THEN** `GIT_INTERNAL_GETTEXT_TEST_FALLBACKS` SHALL be exported with value `1`

### Requirement: Git remote URL path extraction

The git module SHALL provide `git::internal::get_module_path()` that extracts the organization/repo path from the git remote origin URL.

#### Scenario: Extracts path from SSH remote

- **WHEN** the git remote origin is `git@github.com:luismayta/dotfiles.git`
- **THEN** `git::internal::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Extracts path from HTTPS remote

- **WHEN** the git remote origin is `https://github.com/luismayta/dotfiles.git`
- **THEN** `git::internal::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Falls back on missing remote

- **WHEN** there is no git remote origin configured
- **THEN** `git::internal::get_module_path` SHALL print an error message and return 0

### Requirement: FZF git commit hash selector

The git module SHALL provide `fcs()` that lets the user select a git commit hash via fzf and copies it to the clipboard.

#### Scenario: fcs selects and copies commit hash

- **WHEN** `fcs` is called in a git repository
- **THEN** the system SHALL show `git log --oneline --reverse` via fzf and copy the selected commit hash to clipboard

### Requirement: FZF git branch switcher

The git module SHALL provide `fgb()` that lets the user switch git branches via fzf-tmux.

#### Scenario: fgb switches git branches

- **WHEN** `fgb` is called in a git repository
- **THEN** the system SHALL show the 30 most recent branches via `git for-each-ref` and fzf-tmux and `git checkout` the selection
