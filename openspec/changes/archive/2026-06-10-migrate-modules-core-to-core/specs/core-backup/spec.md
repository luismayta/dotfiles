## ADDED Requirements

### Requirement: Project backup snapshot

The system SHALL provide `core::backup::snapshot()` in `zsh/core/internal/backup.zsh` that creates a timestamped backup of the current project to `CORE_PROJECTS_BACKUP_PATH` using rsync.

#### Scenario: Successful project backup

- **WHEN** `core::backup::snapshot` is called inside a git repository
- **THEN** the system SHALL rsync the project directory to `${CORE_PROJECTS_BACKUP_PATH}/${module_path}/${branch}` with excludes for `.git`, `.task`, `.terraform`, `.venv`, `__pycache__`, `.mypy_cache`, `.pytest_cache`, `node_modules`, and `.DS_Store`

#### Scenario: Backup preserves git branch info

- **WHEN** `core::backup::snapshot` is called on branch `feature/my-thing`
- **THEN** the backup target SHALL convert the branch name to `feature/my-thing` (slashes preserved)

### Requirement: Git module path extraction

The system SHALL provide `core::git::get_module_path()` in `zsh/core/internal/git.zsh` that extracts the organization/repo path from the git remote origin URL.

#### Scenario: Extracts path from SSH remote

- **WHEN** the git remote origin is `git@github.com:luismayta/dotfiles.git`
- **THEN** `core::git::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Extracts path from HTTPS remote

- **WHEN** the git remote origin is `https://github.com/luismayta/dotfiles.git`
- **THEN** `core::git::get_module_path` SHALL return `luismayta/dotfiles`

#### Scenario: Falls back on missing remote

- **WHEN** there is no git remote origin configured
- **THEN** `core::git::get_module_path` SHALL return `unknown/unknown/${PWD}`

### Requirement: Public backup wrapper

The system SHALL provide `core::snapshot()` in `zsh/core/pkg/helper/backup.zsh` as the public API entry point that delegates to `core::backup::snapshot`.

#### Scenario: core::snapshot delegates to internal

- **WHEN** `core::snapshot` is called
- **THEN** it SHALL delegate to `core::backup::snapshot`
