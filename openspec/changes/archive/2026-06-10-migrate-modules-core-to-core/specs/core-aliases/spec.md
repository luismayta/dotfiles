## ADDED Requirements

### Requirement: eza-based directory listing aliases

The system SHALL define `ls`, `ll`, and `lsa` aliases using the `eza` tool for colored, icon-rich directory listings with git status integration. If `eza` is not installed, the system SHALL auto-install it via cargo.

#### Scenario: ls is aliased to eza

- **WHEN** the shell starts and `eza` is installed
- **THEN** `ls` SHALL execute `eza --icons=auto`

#### Scenario: ll shows detailed git-aware listing

- **WHEN** `ll` is run in a git repository
- **THEN** the output SHALL include file permissions, owner, group, size, git status, and icons

#### Scenario: lsa includes hidden files

- **WHEN** `lsa` is run
- **THEN** the output SHALL include hidden files (dotfiles) with long format and icons

### Requirement: System utility aliases

The system SHALL define common system utility aliases for convenience.

#### Scenario: df shows human-readable disk usage

- **WHEN** `df` is run
- **THEN** the output SHALL be `df -h`

#### Scenario: free shows memory in megabytes

- **WHEN** `free` is run
- **THEN** the output SHALL be `free -m`

#### Scenario: gurl runs curl with compression

- **WHEN** `gurl` is run
- **THEN** curl SHALL be invoked with `--compressed`

#### Scenario: week shows current week number

- **WHEN** `week` is run
- **THEN** the output SHALL be `date +%V`

#### Scenario: wget sets a common user-agent

- **WHEN** `wget` is run
- **THEN** wget SHALL be invoked with `--user-agent="Mozilla/4.0 (Windows; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"`