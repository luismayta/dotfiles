## ADDED Requirements

### Requirement: Domain-separated internal module files

The `zsh/modules/herdr/internal/` directory SHALL contain one file per domain instead of a single monolithic `base.zsh`.

The file layout SHALL be:

| File | Domain | Functions |
|---|---|---|
| `base.zsh` | General utilities | `fzf_select`, `derive_project_name`, `list_templates`, `select_template`, `resolve_workspace_id` |
| `install.zsh` | Install & config | `install`, `config::sync` |
| `workspace.zsh` | Workspace CRUD | `list_workspaces`, `workspace_exists`, `switch_workspace`, `kill_workspace`, `workspace_attach_or_create` |
| `worktree.zsh` | Worktree CRUD | `worktree::is_git_repo`, `worktree::derive_repo_name`, `worktree::branch_exists`, `worktree::list`, `worktree::create`, `worktree::open`, `worktree::remove`, `worktree::fzf_select`, `worktree::resolve_path`, `worktree::resolve_workspace_id` |
| `pane.zsh` | Pane layout | `pane::setup_3_pane_layout` |

#### Scenario: New file structure exists
- **WHEN** the module is loaded
- **THEN** each file listed above SHALL exist in `zsh/modules/herdr/internal/`
- **THEN** each file SHALL contain only functions from its specified domain

#### Scenario: Missing domain file
- **WHEN** internal/main.zsh is sourced
- **THEN** the module SHALL source every file listed above
- **THEN** if any file is missing, the module SHALL fail to load with an error

### Requirement: Sourcing order respects dependencies

The `internal/main.zsh` file SHALL source domain files in dependency order. A file MUST be sourced before any file that depends on functions defined within it.

The REQUIRED sourcing order SHALL be:

1. `base.zsh` — general utilities (no internal dependencies)
2. `install.zsh` — depends on base helpers
3. `workspace.zsh` — depends on base helpers
4. `worktree.zsh` — depends on base helpers
5. `pane.zsh` — depends on base helpers
6. `linux.zsh` — unchanged
7. `osx.zsh` — unchanged

#### Scenario: Correct ordering
- **WHEN** `source internal/main.zsh` is executed
- **THEN** files SHALL be sourced in the order specified above
- **THEN** all functions from earlier files SHALL be available to later files

### Requirement: Functions relocate without signature changes

Every function moved from `base.zsh` to a domain file MUST retain its exact name, parameters, return codes, and behavior. No caller SHALL need updates due to relocation.

#### Scenario: Function moved to workspace.zsh
- **WHEN** `hrd::internal::switch_workspace "my-workspace"` is called
- **THEN** it SHALL work identically whether defined in `base.zsh` or `workspace.zsh`

#### Scenario: Function moved to worktree.zsh
- **WHEN** `hrd::internal::worktree::list` is called
- **THEN** it SHALL work identically whether defined in `base.zsh` or `worktree.zsh`
