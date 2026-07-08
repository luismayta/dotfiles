## ADDED Requirements

### Requirement: Create worktree from current directory
The system SHALL provide a function `hrdw::create <name>` that creates a git worktree from the current directory using `herdr worktree create --cwd . --branch <name>` and opens it as a herdr workspace. If a prefix (`feature/`, `fix/`, `bugfix/`, `hotfix/`, `chore/`) is missing, the system SHALL auto-prepend `feature/`.

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

### Requirement: List worktrees with status
The system SHALL provide a function `hrdw::list` that lists all herdr worktrees for the current repository with their status (active, stopped, etc.) by calling `herdr worktree list --cwd . --json` and formatting the output as a table.

#### Scenario: List worktrees
- **WHEN** user invokes `hrdw::list` from a git repository
- **THEN** the system displays all worktrees associated with the current repository with their status in a formatted table

### Requirement: Open worktree via fzf
The system SHALL provide a function `hrdw::open` that lists all worktrees and lets the user select one via fzf, then opens the selected worktree using `herdr worktree open`.

#### Scenario: Open worktree via fzf
- **WHEN** user invokes `hrdw::open`
- **THEN** the system SHALL display an fzf selector with all worktrees
- **THEN** after selection, the system SHALL call `herdr worktree open --path <selected-path> --focus` to focus the worktree workspace

#### Scenario: Open worktree by branch name (direct)
- **WHEN** user invokes `hrdw::open RD-21`
- **THEN** the system SHALL auto-prefix to `feature/RD-21` (same prefix logic as create)
- **THEN** the system SHALL resolve the branch to its worktree path
- **THEN** the system SHALL call `herdr worktree open --path <resolved-path> --focus`

### Requirement: Remove worktree
The system SHALL provide a function `hrdw::remove <workspace-id>` that removes a worktree via `herdr worktree remove --workspace <id>`.

#### Scenario: Remove worktree by workspace ID
- **WHEN** user invokes `hrdw::remove <workspace-id>` from a git repository
- **THEN** the system SHALL call `herdr worktree remove --workspace <workspace-id>`
- **THEN** the worktree SHALL be removed from herdr

#### Scenario: Remove worktree with dirty checkout
- **WHEN** user invokes `hrdw::remove <workspace-id>` and git has uncommitted changes
- **THEN** the system SHALL display the git error and suggest `--force`
- **THEN** if user confirms, the system SHALL run with `--force`
- **THEN** the worktree SHALL be removed

#### Scenario: Remove via fzf
- **WHEN** user invokes `hrdw::remove` without arguments
- **THEN** the system SHALL display an fzf selector with all worktrees (same as `hrdw::open`)
- **THEN** after selection, the system SHALL confirm before removal
- **THEN** on confirm, the system SHALL call `herdr worktree remove --workspace <id>`

### Requirement: Error handling for non-git directories
The system SHALL detect when the current directory is not inside a git repository and display a clear error message instead of running herdr commands.

#### Scenario: Non-git directory
- **WHEN** user invokes any `hrdw::*` function from a directory that is not a git repository
- **THEN** the system SHALL print an error: `"Not a git repository: <current-directory>"`
- **THEN** the system SHALL return a non-zero exit code

### Requirement: Error handling for existing worktrees
The system SHALL detect when a worktree for the requested branch already exists and show an informative message with the existing worktree path.

#### Scenario: Worktree already exists
- **WHEN** user tries `hrdw::create RD-21` and branch `feature/RD-21` already has a worktree checkout
- **THEN** the system SHALL detect the conflict via `herdr worktree list --json`
- **THEN** the system SHALL display: `"Worktree already exists at: <path>"`
- **THEN** the system SHALL ask: `"Open it? (Y/n)"`
- **THEN** if yes, the system SHALL open the existing worktree

### Requirement: Error handling for dirty checkouts
The system SHALL propagate `--force` requirement from `herdr worktree remove` when git refuses a dirty checkout.

#### Scenario: Force remove dirty worktree
- **WHEN** user tries `hrdw::remove <id>` with uncommitted changes
- **THEN** the system SHALL display the git error and remind the user to use `--force` if appropriate

### Requirement: Module integration
The system SHALL follow existing herdr module conventions: public API functions in `pkg/helper.zsh`, internal logic in `internal/base.zsh`, loading through the existing `pkg/main.zsh` sourcing chain, and using the `hrd::` namespace for internal functions.

#### Scenario: Function placement
- **WHEN** the module loads via `plugin.zsh`
- **THEN** the worktree helper functions SHALL be available in the shell session
- **THEN** `hrdw::create`, `hrdw::list`, `hrdw::open`, `hrdw::remove` SHALL all be recognized as valid shell functions

### Requirement: Short prefix
The system SHALL expose the worktree helper functions under the `hrdw::` prefix following the existing pattern of `hrd::project::*` and `hrd::plugin::*`. The existing alias conflict (`alias hrd=herdr` in `pkg/alias.zsh` shadowing the `hrd()` function) SHALL be resolved so that shell functions take precedence over aliases.

#### Scenario: hrdw::create is available
- **WHEN** the herdr module is loaded
- **THEN** `hrdw::create` SHALL be a valid shell function
- **THEN** `which hrdw::create` SHALL show it is a shell function

#### Scenario: hrd alias does not shadow hrd function
- **WHEN** the herdr module is loaded
- **THEN** `hrd` SHALL resolve to the shell function, not the alias
- **THEN** calling `hrd` SHALL still delegate to the `herdr` binary appropriately
