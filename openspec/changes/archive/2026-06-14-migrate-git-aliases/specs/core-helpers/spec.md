## REMOVED Requirements

### Requirement: FZF integration helpers (git-specific)

**Reason:** The `fcs()` and `fgb()` functions are git-specific and have been moved to the git module (`zsh/modules/git/pkg/fzf.zsh`).

**Migration:** These functions are still available at the shell prompt as `fcs` and `fgb`. No user-facing change. The implementation now lives in `zsh/modules/git/pkg/fzf.zsh` instead of `zsh/core/pkg/helper/core.zsh`.

#### Scenario: fcs selects and copies git commit hash

- **WHEN** `fcs` is called in a git repository
- **THEN** the system SHALL show `git log --oneline --reverse` via fzf and copy the selected commit hash to clipboard

#### Scenario: fgb switches git branches

- **WHEN** `fgb` is called in a git repository
- **THEN** the system SHALL show the 30 most recent branches via `git for-each-ref` and fzf-tmux and `git checkout` the selection
