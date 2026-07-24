## ADDED Requirements

### Requirement: Branch state display
The script SHALL display the current branch name and its tracking status (ahead/behind counts relative to upstream).

#### Scenario: Branch ahead of upstream
- **WHEN** user runs `git-status-enhanced` on a branch with 3 unpushed commits
- **THEN** output shows current branch name with "3 ahead" indicator

#### Scenario: Branch behind upstream
- **WHEN** user runs `git-status-enhanced` on a branch with 2 unpulled commits
- **THEN** output shows current branch name with "2 behind" indicator

#### Scenario: Branch synchronized
- **WHEN** user runs `git-status-enhanced` on a fully synchronized branch
- **THEN** output shows current branch name with "synced" indicator

### Requirement: Remote branch comparison
The script SHALL show the relationship between local and remote branches (deleted, diverged, new).

#### Scenario: Local branch deleted on remote
- **WHEN** user runs `git-status-enhanced` with local branch that no longer exists on remote
- **THEN** output flags the branch as "deleted on remote"

#### Scenario: Remote branch deleted locally
- **WHEN** user runs `git-status-enhanced` with remote branch that has no local counterpart
- **THEN** output shows "stale remote branch" warning

### Requirement: Multiple branch overview
The script SHALL support `--all` flag to show status of all local branches.

#### Scenario: All branches view
- **WHEN** user runs `git-status-enhanced --all`
- **THEN** output lists all local branches with their respective ahead/behind counts

### Requirement: Compact output mode
The script SHALL support `--short` flag for minimal output suitable for scripting.

#### Scenario: Short output
- **WHEN** user runs `git-status-enhanced --short`
- **THEN** output contains only branch name and sync status (no colors, no extra info)

### Requirement: Integration branch detection
The script SHALL identify the main integration branch (main/master) and show branch relationships.

#### Scenario: Feature branch relationship
- **WHEN** user is on a feature branch
- **THEN** output shows merge-base distance to main/master