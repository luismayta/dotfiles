## ADDED Requirements

### Requirement: Daemon lifecycle management
The system SHALL provide complete lifecycle management for the hunk daemon process, including start, stop, status, and restart operations.

#### Scenario: Start daemon
- **WHEN** user calls `ai::hunk::daemon::start`
- **THEN** hunk daemon SHALL start in background AND the PID SHALL be persisted to `/tmp/hunk-daemon.pid`

#### Scenario: Stop daemon
- **WHEN** user calls `ai::hunk::daemon::stop`
- **THEN** the hunk daemon process SHALL be terminated gracefully AND the PID file SHALL be cleaned up

#### Scenario: Stop daemon when not running
- **WHEN** user calls `ai::hunk::daemon::stop` AND no daemon is running
- **THEN** the function SHALL print a warning message AND return successfully

#### Scenario: Check daemon status (running)
- **WHEN** user calls `ai::hunk::daemon::status` AND daemon is running
- **THEN** it SHALL print "hunk daemon is running (PID <pid>)" AND return 0

#### Scenario: Check daemon status (not running)
- **WHEN** user calls `ai::hunk::daemon::status` AND no daemon is running
- **THEN** it SHALL print "hunk daemon is not running" AND return 1

#### Scenario: Restart daemon
- **WHEN** user calls `ai::hunk::daemon::restart`
- **THEN** the existing daemon SHALL be stopped AND a new daemon SHALL be started

### Requirement: Session listing
The system SHALL provide a function to list active hunk daemon sessions.

#### Scenario: List active sessions
- **WHEN** user calls `ai::hunk::session::list`
- **THEN** it SHALL execute `hunk session list` and display active sessions

#### Scenario: List sessions when daemon is not running
- **WHEN** user calls `ai::hunk::session::list` AND no daemon is running
- **THEN** it SHALL print a message indicating the daemon is not running
