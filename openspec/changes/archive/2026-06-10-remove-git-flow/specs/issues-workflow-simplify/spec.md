## REMOVED Requirements

### Requirement: Git-flow workflow detection
**Reason**: The issues module previously detected git-flow by checking `git config gitflow.branch.master` or the existence of `.gitflow` / `gitflow.toml` files. Since git-flow is not used, this detection logic is dead code.
**Migration**: Remove git-flow detection from `internal/base.zsh` lines 32-37. The `$workflow` variable SHALL default to the standard (non-gitflow) path.

### Requirement: Git-flow workflow execution
**Reason**: The `issues/workflow/gitflow.zsh` file and the `gitflow)` case branch in `workflow/main.zsh` are only reachable when git-flow workflow is detected. With detection removed, this code is unreachable.
**Migration**: Delete `issues/workflow/gitflow.zsh`. Remove the `gitflow)` case block from `workflow/main.zsh`.

## ADDED Requirements

### Requirement: Issues module uses standard workflow path by default
The issues module SHALL use the standard (non-gitflow) branch base resolution without requiring any workflow detection.

#### Scenario: Workflow defaults to standard
- **WHEN** the issues module resolves the PR base branch
- **THEN** it SHALL NOT attempt to detect git-flow
- **THEN** it SHALL use the standard branch resolution logic

### Requirement: No orphaned git-flow config references
The issues module SHALL NOT read, check, or reference any git-flow configuration keys.

#### Scenario: No config reads for git-flow
- **WHEN** the issues module initializes
- **THEN** it SHALL NOT attempt to read `gitflow.branch.master` or similar git config keys
- **THEN** it SHALL NOT check for `.gitflow` or `gitflow.toml` files