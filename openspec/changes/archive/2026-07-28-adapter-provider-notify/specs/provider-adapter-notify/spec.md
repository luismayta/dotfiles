## ADDED Requirements

### Requirement: User selects notification provider via ZSH_NOTIFY_PROVIDER

The system SHALL allow the user to select the active notification provider via the `ZSH_NOTIFY_PROVIDER` environment variable.

#### Scenario: Provider is explicitly set
- **WHEN** `ZSH_NOTIFY_PROVIDER` is set to `noti`
- **THEN** the system SHALL use noti for all notifications

#### Scenario: Provider is auto
- **WHEN** `ZSH_NOTIFY_PROVIDER` is set to `auto` or unset
- **THEN** the system SHALL auto-detect the provider: try noti first, fallback to notify-send

#### Scenario: Provider is notify-send
- **WHEN** `ZSH_NOTIFY_PROVIDER` is set to `notify-send`
- **THEN** the system SHALL use notify-send for all notifications

### Requirement: Each provider implements adapter contract

Every provider SHALL implement the adapter contract as separate files under `config/adapter/` and `internal/adapter/`.

#### Scenario: Adapter file structure
- **WHEN** a new provider is added
- **THEN** it SHALL have `config/adapter/<provider>.zsh` for env vars and `internal/adapter/<provider>.zsh` for implementation

#### Scenario: Adapter functions exist
- **WHEN** a provider adapter is loaded
- **THEN** it SHALL define `notify::adapter::send`, `notify::adapter::install`, `notify::adapter::render`, and `notify::adapter::sync`

### Requirement: Provider dispatch via source order override

The system SHALL dispatch the active provider using source order override (like Docker module): OS-level functions are loaded first, then adapter-level functions override them.

#### Scenario: Source order is deterministic
- **WHEN** the module loads
- **THEN** `config/main.zsh` SHALL source `config/adapter/<provider>.zsh` after `config/base.zsh`

#### Scenario: Internal dispatch matches config
- **WHEN** the module loads
- **THEN** `internal/main.zsh` SHALL source `internal/adapter/<provider>.zsh` after internal base

### Requirement: OS popup functions delegate to provider

The `notify::internal::popup` functions in OS-specific files SHALL delegate to `notify::adapter::send` instead of calling provider functions directly.

#### Scenario: Linux popup delegates
- **WHEN** a notification is triggered on Linux
- **THEN** `notify::internal::popup` SHALL call `notify::adapter::send` with the appropriate arguments

#### Scenario: macOS popup delegates
- **WHEN** a notification is triggered on macOS
- **THEN** `notify::internal::popup` SHALL call `notify::adapter::send` with the appropriate arguments

### Requirement: Public API wrappers remain backward-compatible

The existing public functions (`notify::noti::send`, `notify::notify-send::send`, etc.) SHALL continue to work and delegate to their internal implementations.

#### Scenario: Backward compatibility
- **WHEN** a user calls `notify::noti::send`
- **THEN** it SHALL still work and delegate to `notify::noti::internal::send`
