## ADDED Requirements

### Requirement: noti is installed and available

The system SHALL verify that `noti` is installed before attempting to use it as a notification backend.

#### Scenario: noti is installed
- **WHEN** the notify module loads
- **THEN** the system SHALL check `core::exists noti` and proceed if found

#### Scenario: noti is not installed
- **WHEN** the notify module loads and `noti` is not found
- **THEN** the system SHALL fall back to `notify-send` (Linux) or `osascript` (macOS) and log a warning message

### Requirement: Telegram configuration is loaded from environment variables

The system SHALL read Telegram credentials from environment variables and write them to the noti config file.

#### Scenario: Environment variables are set
- **WHEN** `ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN` and `ZSH_NOTIFY_NOTI_TELEGRAM_CHATID` are exported
- **THEN** the system SHALL generate `~/.config/noti/noti.yaml` with the Telegram service configured

#### Scenario: Environment variables are missing
- **WHEN** required Telegram environment variables are not set
- **THEN** the system SHALL log an error message and skip Telegram notifications

### Requirement: Notifications are sent via noti on command completion

The system SHALL use `noti` to send notifications when a long-running command completes.

#### Scenario: Command succeeds after threshold
- **WHEN** a command runs for more than `_ZSH_NOTIFY_TIME_THRESHOLD` seconds and exits with code 0
- **THEN** the system SHALL call `noti -t "<command>" -m "The command succeeded after <N> seconds"`

#### Scenario: Command fails after threshold
- **WHEN** a command runs for more than `_ZSH_NOTIFY_TIME_THRESHOLD` seconds and exits with non-zero code
- **THEN** the system SHALL call `noti -t "<command>" -m "The command failed after <N> seconds with code: <exit_code>"`

### Requirement: Sound notification is preserved

The system SHALL continue playing notification sounds via `mpg123` after sending the noti notification.

#### Scenario: Sound plays after notification
- **WHEN** a notification is sent via noti
- **THEN** the system SHALL call `mpg123` with the appropriate sound file (success or error)

### Requirement: Cross-platform compatibility is maintained

The system SHALL work on both Linux and macOS using the same noti binary.

#### Scenario: Linux execution
- **WHEN** the module runs on Linux
- **THEN** the system SHALL use noti with the same configuration as macOS

#### Scenario: macOS execution
- **WHEN** the module runs on macOS
- **THEN** the system SHALL use noti with the same configuration as Linux

### Requirement: Function naming follows module conventions

All functions SHALL follow the naming pattern `notify::noti::<verb>` for public functions and `notify::noti::internal::<verb>` for internal functions.

#### Scenario: Public function naming
- **WHEN** a new public function is created
- **THEN** it SHALL be named `notify::noti::<verb>` (e.g., `notify::noti::send`)

#### Scenario: Internal function naming
- **WHEN** a new internal function is created
- **THEN** it SHALL be named `notify::noti::internal::<verb>` (e.g., `notify::noti::internal::send`)

### Requirement: Configuration variables follow naming convention

All configuration variables SHALL use the prefix `ZSH_NOTIFY_NOTI_`.

#### Scenario: Variable naming
- **WHEN** a new configuration variable is defined
- **THEN** it SHALL be named `ZSH_NOTIFY_NOTI_<SUFFIX>` (e.g., `ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN`)
