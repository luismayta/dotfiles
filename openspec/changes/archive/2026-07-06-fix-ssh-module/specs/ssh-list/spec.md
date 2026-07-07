## ADDED Requirements

### Requirement: Reliable SSH host listing
The system SHALL provide a function `ssh::list` that lists all SSH hosts from `~/.ssh/config` using standard shell file redirection.

#### Scenario: Hosts listed from SSH config
- **WHEN** user calls `ssh::list` and `~/.ssh/config` contains `Host myserver` and `Host devbox`
- **THEN** the output SHALL contain "myserver" and "devbox", one per line

#### Scenario: Case-insensitive host matching
- **WHEN** `~/.ssh/config` contains `Host myserver`, `host devbox`, and `HOST prod`
- **THEN** all three hosts SHALL be listed regardless of the "Host" keyword case

#### Scenario: Empty config file
- **WHEN** `~/.ssh/config` is empty
- **THEN** `ssh::list` SHALL return no output

#### Scenario: No config file
- **WHEN** `~/.ssh/config` does not exist
- **THEN** `ssh::list` SHALL return an empty result without errors

### Requirement: No external pager dependency
The system SHALL read `~/.ssh/config` using direct file redirection, not via a pager program.

#### Scenario: Direct file read
- **WHEN** `ssh::list` is executed
- **THEN** it SHALL read `~/.ssh/config` using `<"${SSH_CONFIG_FILE}"` redirection or `cat`, NOT via `less`, `more`, or any interactive pager
