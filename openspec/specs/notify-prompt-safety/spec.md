# notify-prompt-safety Specification

## Purpose

Keeps the interactive zsh shell responsive and intact while notify plays sounds and dispatches desktop notifications: detached, bounded prompt-time execution, install-free startup, preserved completion-notification semantics, and idempotent, disable-respecting hook registration.

## Requirements

### Requirement: Sound playback never blocks the prompt

`notify::internal::play` SHALL return control to the shell immediately — in well under one second regardless of how the audio player behaves — and SHALL always exit 0 so it can never truncate the `precmd_functions` hook chain.

#### Scenario: Player hangs
- **WHEN** the invoked player takes 30 s to exit (stubbed slow player)
- **THEN** `play` SHALL return within 1 s with status 0

#### Scenario: Player fails
- **WHEN** the player exits with a non-zero status or is killed
- **THEN** `play` SHALL still return 0 and the next hook in `precmd_functions` SHALL still run

#### Scenario: Player missing
- **WHEN** `mpg123` is not on PATH
- **THEN** `play` SHALL return 0 without spawning any process

### Requirement: Sound playback never touches the terminal

`play` SHALL invoke the player with terminal control disabled and stdin detached from the tty, backgrounded and disowned, so the player can never change terminal modes, trigger job-control stops (SIGTTOU), or be waited on by the shell.

#### Scenario: Flags and stdin
- **WHEN** `play` is invoked
- **THEN** the player SHALL receive `--no-control` and `-q` and its stdin SHALL be `/dev/null`, never a tty

#### Scenario: Detached player
- **WHEN** `play` starts the player
- **THEN** the player SHALL run in the background, disowned (absent from the shell's job table), and `play` SHALL not wait for it

#### Scenario: Terminal modes preserved
- **WHEN** `play` is called under a pty with `icanon` and `echo` enabled
- **THEN** both modes SHALL still be enabled after the call returns

### Requirement: Sound playback is hard-bounded with SIGKILL fallback

Playback SHALL run under a hard bound of `timeout -k 2 8` (8 s, then SIGTERM, then SIGKILL after a 2 s grace), because the player catches SIGTERM/SIGINT but acts on neither while blocked.

#### Scenario: SIGTERM-resistant player dies anyway
- **WHEN** the player ignores SIGTERM (`trap '' TERM`) and keeps running past the bound
- **THEN** it SHALL be terminated by SIGKILL within the 2 s grace period

#### Scenario: No long-lived orphans
- **WHEN** the launching shell or tab exits during playback
- **THEN** the player SHALL not outlive the hard bound — no orphan may survive for minutes or hours

### Requirement: Only one playback runs at a time

`play` SHALL skip the call and return 0 when an `mpg123` instance is already running, so repeated prompts never accumulate concurrent players.

#### Scenario: Instance already running
- **WHEN** an `mpg123` process is live and `play` is called
- **THEN** no second player SHALL be spawned and `play` SHALL return 0

#### Scenario: Bursts of notifications
- **WHEN** several notifications fire in quick succession
- **THEN** at most one player SHALL run concurrently

### Requirement: Notification dispatch is hard-bounded

The `noti` and `notify-send` adapter invocations SHALL be wrapped in `timeout` with a SIGKILL backup, so a slow or hung provider (network stall, D-Bus stall) cannot block the prompt.

#### Scenario: Hung provider
- **WHEN** the active adapter command hangs
- **THEN** it SHALL be terminated within the bound and the prompt SHALL continue drawing normally

### Requirement: Module startup performs no package installation

The notify runtime initialization SHALL detect missing tools (`mpg123`, and `gomplate` when the provider is `noti`) and emit `message_warning` instead of calling `core::ensure`; installing packages remains an explicit user action.

#### Scenario: Missing mpg123 at load
- **WHEN** the module loads without `mpg123` on PATH
- **THEN** a warning SHALL be emitted, no package manager SHALL be invoked, and module loading SHALL complete

#### Scenario: Missing gomplate with noti provider
- **WHEN** `ZSH_NOTIFY_PROVIDER=noti` and `gomplate` is absent
- **THEN** the module SHALL warn and continue without installing anything

### Requirement: Skip-list filters interactive commands

A preexec command matching the skip pattern (`^[^ ]*(ssh|vim|nvim|tmux|tig|man|cat|more|less)`) SHALL not be recorded, so no completion notification is emitted for it.

#### Scenario: Matching command produces no notification
- **WHEN** the executed command is `ssh host` or `vim file`
- **THEN** it SHALL be skipped and no completion notification SHALL be emitted for it

#### Scenario: Non-matching command is recorded
- **WHEN** the executed command does not match the skip pattern
- **THEN** it SHALL be recorded and evaluated against the duration threshold

### Requirement: Completion notifications keep the 10-second threshold

A notification SHALL be emitted only when the command duration strictly exceeds `_ZSH_NOTIFY_TIME_THRESHOLD` (10 s); at exactly 10 s there SHALL be no notification.

#### Scenario: Exactly at threshold
- **WHEN** a command runs for exactly 10 s
- **THEN** no notification SHALL be emitted

#### Scenario: Above threshold
- **WHEN** a command runs for more than 10 s
- **THEN** the success or error notification SHALL be dispatched through the active provider

### Requirement: Exit status is captured through the hook wrapper

The precmd hook SHALL capture `$?` of the completed command before any other command runs, so the notification dispatched through the pkg wrapper reflects the real exit status.

#### Scenario: Failing command keeps its exit code
- **WHEN** a command exits non-zero and the threshold is exceeded
- **THEN** the error notification SHALL carry that exit code

#### Scenario: Succeeding command selects success path
- **WHEN** a command exits 0 and the threshold is exceeded
- **THEN** the success notification path SHALL be taken

### Requirement: Hooks register exactly once

Sourcing `plugin.zsh` SHALL leave exactly one `notify::command::store` entry in `preexec_functions` and exactly one `notify::command::completed` entry in `precmd_functions`, regardless of how many times it is sourced.

#### Scenario: Sourced twice
- **WHEN** `plugin.zsh` is sourced twice in one shell session
- **THEN** each hook array SHALL contain exactly one notify entry

### Requirement: Disabled module registers no hooks

When `notify` appears in `ZSH_DISABLED_MODULES`, the module loader SHALL skip `plugin.zsh` entirely and register no preexec/precmd hooks.

#### Scenario: Module disabled at load
- **WHEN** `ZSH_DISABLED_MODULES=notify` and the module loop in `zsh/zshrc` runs
- **THEN** neither hook SHALL be registered and no notification machinery SHALL load

### Requirement: Prompt hooks avoid per-prompt process forks

The preexec/precmd hooks SHALL obtain timestamps without spawning external processes (using `EPOCHSECONDS` from `zsh/datetime`), so a prompt cycle forks no `date` process.

#### Scenario: No date fork per prompt
- **WHEN** the preexec and precmd hooks run for a command
- **THEN** no `date` process SHALL be spawned during the cycle
