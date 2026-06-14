## MODIFIED Requirements

### Requirement: Git module path extraction

The system SHALL use `git::internal::get_module_path()` from the git module instead of `core::git::get_module_path()` for backup path resolution.

The function behavior is identical — only the namespace and location changed (moved to `zsh/modules/git/internal/get-module-path.zsh` as `git::internal::get_module_path`).

#### Scenario: Extracts path from SSH remote

- **WHEN** the git remote origin is `git@github.com:luismayta/dotfiles.git`
- **THEN** `git::internal::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Extracts path from HTTPS remote

- **WHEN** the git remote origin is `https://github.com/luismayta/dotfiles.git`
- **THEN** `git::internal::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Falls back on missing remote

- **WHEN** there is no git remote origin configured
- **THEN** `git::internal::get_module_path` SHALL return `unknown/unknown/${PWD}`
