## MODIFIED Requirements

### Requirement: Domain-separated internal module files

The `zsh/modules/herdr/internal/` directory SHALL contain one file per domain instead of a single monolithic `base.zsh`.

The internal file layout SHALL be:

| File | Domain | Functions |
|---|---|---|
| `base.zsh` | General utilities | `fzf_select`, `resolve_workspace_id` |
| `install.zsh` | Install & config | `install`, `config::sync` |
| `workspace.zsh` | Workspace CRUD | `list_workspaces`, `workspace_exists`, `switch_workspace`, `kill_workspace`, `workspace_attach_or_create` |
| `worktree.zsh` | Worktree CRUD | `worktree::is_git_repo`, `worktree::branch_exists`, `worktree::list`, `worktree::create`, `worktree::open`, `worktree::remove`, `worktree::fzf_select`, `worktree::resolve_path`, `worktree::resolve_workspace_id` |
| `pane.zsh` | Pane layout | `pane::setup_3_pane_layout` |

`list_templates` and `select_template` (previously listed in `base.zsh`) and `worktree::derive_repo_name` (previously listed in `worktree.zsh`) are dead code with zero callers: they SHALL be removed from the module and SHALL NOT appear in this inventory. `derive_project_name` moves out of the module to the shared system-level helper consumed by both herdr and tmux.

The same one-file-per-domain discipline SHALL apply to `zsh/modules/herdr/pkg/`: `pkg/helper.zsh` SHALL be split into cohesive modules `project.zsh`, `worktree.zsh`, `plugin.zsh`, `config-editor.zsh`, and `lifecycle.zsh`, loaded by `pkg/main.zsh`, and no `pkg/` file SHALL mix unrelated domains.

#### Scenario: New file structure exists
- **WHEN** the module is loaded
- **THEN** each file listed above SHALL exist in `zsh/modules/herdr/internal/`
- **THEN** each file SHALL contain only functions from its specified domain

#### Scenario: pkg split file structure exists
- **WHEN** the module is loaded
- **THEN** `zsh/modules/herdr/pkg/` SHALL contain `project.zsh`, `worktree.zsh`, `plugin.zsh`, `config-editor.zsh`, and `lifecycle.zsh`
- **THEN** each of those files SHALL contain only functions from its specified domain

#### Scenario: Removed dead functions are absent
- **WHEN** the module is loaded
- **THEN** `list_templates`, `select_template`, and `worktree::derive_repo_name` SHALL NOT be defined
- **THEN** `derive_project_name` SHALL be provided by the shared system-level helper rather than by `internal/`

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

The `pkg/main.zsh` file SHALL likewise source the split `pkg/` modules — `project.zsh`, `worktree.zsh`, `plugin.zsh`, `config-editor.zsh`, and `lifecycle.zsh` — in dependency order: a module MUST be sourced before any module that calls functions defined within it, and modules with no in-split dependencies SHALL be sourced first.

#### Scenario: Correct ordering
- **WHEN** `source internal/main.zsh` is executed
- **THEN** files SHALL be sourced in the order specified above
- **THEN** all functions from earlier files SHALL be available to later files

#### Scenario: pkg modules sourced in dependency order
- **WHEN** `source pkg/main.zsh` is executed
- **THEN** each split `pkg/` module SHALL be sourced after every module it depends on
- **THEN** all public `hrd::` and `hrdw::` functions SHALL be defined once loading completes

### Requirement: Functions relocate without signature changes

Every function moved from `base.zsh` to a domain file MUST retain its exact name, parameters, return codes, and behavior. No caller SHALL need updates due to relocation. The same guarantee SHALL apply to functions relocated into the split `pkg/` modules: every public API name SHALL remain unchanged during the split, and no public API name SHALL change at any point.

#### Scenario: Function moved to workspace.zsh
- **WHEN** `hrd::internal::switch_workspace "my-workspace"` is called
- **THEN** it SHALL work identically whether defined in `base.zsh` or `workspace.zsh`

#### Scenario: Function moved to worktree.zsh
- **WHEN** `hrd::internal::worktree::list` is called
- **THEN** it SHALL work identically whether defined in `base.zsh` or `worktree.zsh`

#### Scenario: Function relocated during pkg split
- **WHEN** a public API function that previously lived in `pkg/helper.zsh` is called after the split
- **THEN** it SHALL keep its exact pre-split name
- **THEN** it SHALL behave identically and require no caller updates
