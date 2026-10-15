## MODIFIED Requirements

### Requirement: Create worktree from current directory
The system SHALL provide a function `hrdw::create <name>` that creates a git worktree from the current directory using `herdr worktree create --cwd . --branch <name>` and opens it as a herdr workspace. If a prefix (`feature/`, `fix/`, `bugfix/`, `hotfix/`, `chore/`) is missing, the system SHALL auto-prepend `feature/`. The worktree SHALL be opened under the label `{project_context}/{branch_leaf}`, where `{branch_leaf}` is the final segment of the branch name, and the zsh implementation and the bash CLI SHALL build this label identically.

#### Scenario: Create worktree with branch auto-prefixing
- **WHEN** user invokes `hrdw::create RD-21` from a git repository
- **THEN** the system auto-prepends `feature/` → branch becomes `feature/RD-21`
- **THEN** the system runs `herdr worktree create --cwd . --branch feature/RD-21 --focus`
- **THEN** the new worktree opens as a herdr workspace in the focused pane

#### Scenario: Create worktree with explicit prefix
- **WHEN** user invokes `hrdw::create hotfix/login-bug` from a git repository
- **THEN** the system uses the branch as-is: `hotfix/login-bug` (no prefix added)
- **THEN** the system runs `herdr worktree create --cwd . --branch hotfix/login-bug --focus`

#### Scenario: Create worktree without branch name
- **WHEN** user invokes `hrdw::create` from a git repository without a branch argument
- **THEN** the system SHALL show usage: `"Usage: hrdw::create <branch-name>"`

#### Scenario: Worktree label identical on zsh and bash paths
- **WHEN** a worktree for branch `feature/RD-21` is created in a given project context
- **THEN** the worktree label SHALL be `{project_context}/RD-21`
- **THEN** `hrdw::create` and `hrdw-create` SHALL build the same label from the same inputs

### Requirement: Open worktree via fzf
The system SHALL provide a function `hrdw::open` that lists all worktrees and lets the user select one via fzf, then opens the selected worktree using `herdr worktree open`. The workspace SHALL be resolved by its label, honoring the legacy-label fallback, and an existing workspace SHALL be opened rather than recreated.

#### Scenario: Open worktree via fzf
- **WHEN** user invokes `hrdw::open`
- **THEN** the system SHALL display an fzf selector with all worktrees
- **THEN** after selection, the system SHALL call `herdr worktree open --path <selected-path> --focus` to focus the worktree workspace

#### Scenario: Open worktree by branch name (direct)
- **WHEN** user invokes `hrdw::open RD-21`
- **THEN** the system SHALL auto-prefix to `feature/RD-21` (same prefix logic as create)
- **THEN** the system SHALL resolve the branch to its worktree path
- **THEN** the system SHALL call `herdr worktree open --path <resolved-path> --focus`

#### Scenario: Existing workspace opened, not recreated
- **WHEN** the derived label is absent from the workspace list
- **AND** the legacy `{parent_dir}-{current_dir}` label matches an existing workspace
- **THEN** the system SHALL resolve to that existing workspace
- **AND** the system SHALL open it without creating a new workspace

### Requirement: Module integration
The system SHALL follow existing herdr module conventions: public API functions SHALL be spread across cohesive `pkg/` modules (the split produces `project.zsh`, `worktree.zsh`, `plugin.zsh`, `config-editor.zsh`, and `lifecycle.zsh`), internal logic SHALL live in domain files under `internal/`, loading SHALL run through the `pkg/main.zsh` sourcing chain in dependency order, and internal functions SHALL use the `hrd::` namespace.

#### Scenario: Function placement
- **WHEN** the module loads via `plugin.zsh`
- **THEN** the worktree helper functions SHALL be available in the shell session
- **THEN** `hrdw::create`, `hrdw::list`, `hrdw::open`, `hrdw::remove` SHALL all be recognized as valid shell functions
