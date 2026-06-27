## ADDED Requirements

### Requirement: Common library with shared functions
The system SHALL provide a shared library at `lib/` with functions reusable across all scripts in the project.

`lib/common.sh` SHALL contain:
- `detect::os()` — returns `Darwin` or `Linux` via `uname`
- `program_exists()` — checks if an executable is available via `type -p`, exits with error if not found
- `change_shell()` — sets the login shell to a given path, only if different from current `$SHELL`

`lib/messages.sh` SHALL contain:
- `msg::info()` — prints a blue `[INFO]` message to stderr
- `msg::success()` — prints a green `[✔]` message to stderr
- `msg::error()` — prints a red `[✘]` message to stderr
- `msg::warn()` — prints a yellow `[!]` message to stderr

All `msg::*` functions SHALL only print — they SHALL NOT call `exit`.

`lib/colors.sh` SHALL contain ANSI color constants prefixed with `C_` (e.g., `C_RESET`, `C_BLUE`, `C_GREEN`, `C_RED`, `C_YELLOW`).

All scripts in the project SHALL source from `lib/` instead of defining their own messaging or OS detection.

#### Scenario: install.sh sources lib and removes duplicate definitions
- **WHEN** `install.sh` starts
- **THEN** it SHALL source `lib/common.sh`, `lib/messages.sh`, `lib/colors.sh`
- **AND** it SHALL NOT define `detect::os`, `program_exists`, `message::info`, `message::success`, or `message::error` locally

#### Scenario: provision scripts source lib instead of messages.sh
- **WHEN** `provision/script/bootstrap.sh` initializes
- **THEN** it SHALL source `lib/messages.sh` and `lib/common.sh`
- **AND** `provision/script/messages.sh` SHALL be removed

#### Scenario: msg::* does not exit on error
- **WHEN** `msg::error` is called
- **THEN** it SHALL print the message to stderr and return 0
- **AND** the caller SHALL decide whether to continue or exit

#### Scenario: change_shell is idempotent
- **WHEN** `change_shell "/bin/zsh"` is called and `$SHELL` is already `/bin/zsh`
- **THEN** it SHALL return 0 without executing `chsh`
