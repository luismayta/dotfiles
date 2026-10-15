## MODIFIED Requirements

### Requirement: Standalone CLI for worktree creation
The system SHALL provide a standalone CLI command `hrdw-create` that creates a git worktree. The CLI SHALL NOT carry an independent implementation of worktree logic or naming: it SHALL delegate to the module's shared implementation, or be removed with the replacement documented. Both invocation paths SHALL derive the worktree label and project name identically, including slug normalization, the `core` prefix, and the parent-directory prefix, so invoking `hrdw-create` or `hrdw::create` produces the same result.

#### Scenario: Create worktree with branch name
- **WHEN** user runs `hrdw-create <branch-name>`
- **THEN** system creates a git worktree with the specified branch name
- **AND** system auto-prepends `feature/` if no known prefix is provided

#### Scenario: Create worktree with existing branch
- **WHEN** user runs `hrdw-create <branch-name>` and branch already exists
- **THEN** system prompts user to open existing worktree

#### Scenario: Create worktree without arguments
- **WHEN** user runs `hrdw-create` without arguments
- **THEN** system displays usage information

#### Scenario: CLI and function derive identical results
- **WHEN** user runs `hrdw-create <branch-name>` and invokes `hrdw::create <branch-name>` from the same directory context
- **THEN** both SHALL derive the same worktree label
- **AND** both SHALL derive the same project name

### Requirement: Standalone CLI for worktree listing
The system SHALL provide a standalone CLI command `hrdw-list` that lists all worktrees. The CLI SHALL NOT carry an independent implementation: it SHALL delegate to the module's shared implementation, or be removed with the replacement documented, and both paths SHALL list the same worktrees for the same repository, deriving the project name identically including slug normalization, the `core` prefix, and the parent-directory prefix.

#### Scenario: List worktrees in current repo
- **WHEN** user runs `hrdw-list`
- **THEN** system displays all worktrees for the current repository

#### Scenario: List worktrees outside git repo
- **WHEN** user runs `hrdw-list` outside a git repository
- **THEN** system displays error message

#### Scenario: CLI and function list the same worktrees
- **WHEN** user runs `hrdw-list` and invokes `hrdw::list` from the same repository
- **THEN** both SHALL display the same set of worktrees

### Requirement: Standalone CLI for worktree deletion
The system SHALL provide a standalone CLI command `hrdw-delete` that removes a worktree. The CLI SHALL NOT carry an independent implementation of worktree logic or naming: it SHALL delegate to the module's shared implementation, or be removed with the replacement documented. Both invocation paths SHALL derive the worktree label and project name identically, including slug normalization, the `core` prefix, and the parent-directory prefix, so invoking `hrdw-delete` or `hrdw::remove` targets the same worktree.

#### Scenario: Delete worktree by workspace ID
- **WHEN** user runs `hrdw-delete <workspace-id>`
- **THEN** system removes the specified worktree

#### Scenario: Delete worktree with fzf selector
- **WHEN** user runs `hrdw-delete` without arguments
- **THEN** system displays fzf selector to choose worktree
- **AND** system prompts for confirmation before deletion

#### Scenario: Delete worktree outside git repo
- **WHEN** user runs `hrdw-delete` outside a git repository
- **THEN** system displays error message

#### Scenario: CLI and function remove the same worktree
- **WHEN** user runs `hrdw-delete <workspace-id>` and invokes `hrdw::remove <workspace-id>` from the same directory context
- **THEN** both SHALL resolve the same worktree
- **AND** both SHALL derive the same worktree label and project name

## ADDED Requirements

### Requirement: Scripts are executable and tracked in git
The system SHALL ensure all CLI scripts are executable and tracked in git.

#### Scenario: Scripts are executable
- **WHEN** scripts are created in `bin/` directory
- **THEN** scripts have executable permissions

#### Scenario: Scripts are tracked in git
- **WHEN** `.gitignore` file exists in `bin/` directory
- **THEN** `.gitignore` does not ignore the script files
