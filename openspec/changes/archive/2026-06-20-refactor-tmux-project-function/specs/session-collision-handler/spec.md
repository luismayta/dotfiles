## ADDED Requirements

### Requirement: Detect existing tmux session

The system SHALL check if a tmux session with the given name already exists using `tmux has-session -t <name>`. If the session exists, it SHALL prompt the user to attach and attach if confirmed.

- If the session does NOT exist, the function SHALL return exit code 1 (caller should proceed)
- If the session exists and user confirms, the function SHALL attach and return exit code 0 (caller should stop)
- If the session exists and user declines, the function SHALL return exit code 0 (caller should stop)

#### Scenario: No existing session
- **WHEN** `tmux has-session -t "myapp"` returns non-zero
- **THEN** the function SHALL return exit code 1

#### Scenario: Session exists and user attaches
- **WHEN** `tmux has-session -t "myapp"` returns zero
- **AND** user responds `Y` to the prompt
- **THEN** the function SHALL run `tmux attach-session -t "myapp"` and return exit code 0

#### Scenario: Session exists and user declines
- **WHEN** `tmux has-session -t "myapp"` returns zero
- **AND** user responds `n` to the prompt
- **THEN** the function SHALL return exit code 0 without attaching
