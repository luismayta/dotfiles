# k9s-cross-platform Specification

## Purpose
Define cross-platform k9s config path resolution so that `devops::k9s::sync` works correctly on both macOS and Linux.

## Requirements

### Requirement: Platform-aware k9s config directory

The devops module SHALL resolve the k9s config directory based on the operating system:
- On macOS: `~/Library/Application Support/k9s`
- On Linux: `${XDG_CONFIG_HOME:-$HOME/.config}/k9s`

#### Scenario: macOS k9s config path

- **WHEN** the system is macOS
- **THEN** DEVOPS_K9S_CONF_PATH SHALL resolve to `~/Library/Application Support/k9s`

#### Scenario: Linux k9s config path (XDG)

- **WHEN** the system is Linux
- **THEN** DEVOPS_K9S_CONF_PATH SHALL resolve to `${XDG_CONFIG_HOME:-$HOME/.config}/k9s`

### Requirement: k9s sync works cross-platform

The `devops::k9s::sync` command SHALL rsync bundled k9s configuration files to the platform-correct k9s config directory.

#### Scenario: sync on macOS

- **WHEN** `devops::k9s::sync` runs on macOS
- **THEN** `data/k9s/` SHALL be rsynced to `~/Library/Application Support/k9s`

#### Scenario: sync on Linux

- **WHEN** `devops::k9s::sync` runs on Linux
- **THEN** `data/k9s/` SHALL be rsynced to `${XDG_CONFIG_HOME:-$HOME/.config}/k9s`
