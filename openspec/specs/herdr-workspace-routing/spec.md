# herdr-workspace-routing Specification

## Purpose

Route herdr sessions per terminal emulator by consuming the `HERDR_WORKSPACE` environment variable through the `hrd::start` entry point, so each emulator (Ghostty, WezTerm, Alacritty) gets its own persistent herdr session with graceful fallback and explicit failure reporting.

## Requirements

### Requirement: Emulator-scoped herdr session routing

The system SHALL expose a public entry point, `hrd::start`, that launches herdr scoped to the session named by the `HERDR_WORKSPACE` environment variable, so each terminal emulator gets its own persistent session with state under `~/.config/herdr/sessions/<name>/`.

#### Scenario: Ghostty session routing
- **WHEN** the user launches via the entry point in Ghostty, where the variable is `ghostty`
- **THEN** herdr starts scoped to session `ghostty` and its state lives under `~/.config/herdr/sessions/ghostty/`

#### Scenario: WezTerm session routing
- **WHEN** the entry point is launched in WezTerm, where the variable is `wezterm`
- **THEN** herdr starts scoped to session `wezterm`

#### Scenario: Alacritty session routing
- **WHEN** the entry point is launched in Alacritty, where the variable is `alacritty`
- **THEN** herdr starts scoped to session `alacritty`

### Requirement: Session selection uses the long-form flag only

The target session SHALL be passed to herdr using the long-form `--session <name>` flag; no code path SHALL use a short-form alias. herdr's parser silently discards unknown flags: `herdr -s ghostty` exits 0 with no error and is ignored, so the shell connects to the `default` session with no diagnostic. Only `--session` applies; there is no `--socket` or `--instance`, `--server` is a verb, and the only short flags are `-h`, `-V`, `-v`, `-y`.

#### Scenario: Routed invocation uses --session
- **WHEN** the entry point routes to a session
- **THEN** it invokes herdr with `--session <name>` and herdr state moves to `~/.config/herdr/sessions/<name>/`

#### Scenario: Short flag never used
- **WHEN** a session is selected on any code path
- **THEN** the short flag `-s` is never used

#### Scenario: Unknown flags are silently discarded
- **WHEN** herdr receives an unrecognized flag
- **THEN** it exits successfully without error, demonstrating why silent `-s` usage would be undetectable

### Requirement: Graceful fallback when the variable is absent

When `HERDR_WORKSPACE` is unset or empty, the entry point SHALL launch herdr without any session flag, SHALL inform the user, and SHALL NOT fail.

#### Scenario: Variable unset
- **WHEN** `HERDR_WORKSPACE` is unset
- **THEN** herdr is invoked without `--session`, the user is informed, and the invocation does not fail

#### Scenario: Variable set to empty string
- **WHEN** `HERDR_WORKSPACE` is set to an empty string
- **THEN** the same no-routing path is taken, with herdr invoked without `--session`, the user informed, and no failure

### Requirement: Missing herdr binary is reported and does not proceed

When the `herdr` binary is not present in PATH, the entry point SHALL report the error to the user and return a non-zero exit status without invoking any herdr command.

#### Scenario: herdr absent from PATH
- **WHEN** `herdr` is not available in PATH
- **THEN** the user is shown an error, the exit status is non-zero, and no herdr command is invoked

#### Scenario: herdr present in PATH
- **WHEN** `herdr` is available in PATH
- **THEN** the absence check passes and normal routing or fallback proceeds
