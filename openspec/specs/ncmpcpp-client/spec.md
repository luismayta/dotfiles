# ncmpcpp-client

## Purpose

El capability `ncmpcpp-client` integra el cliente ncurses ncmpcpp con el módulo mpd: instala el binario si no está presente, despliega su configuración en `~/.ncmpcpp/`, expone aliases de shell y una función pública `mpd::ncmpcpp` para lanzarlo, con soporte multiplataforma (macOS vía Homebrew, Linux vía apt).

## Requirements

### Requirement: ncmpcpp package installation

The mpd module SHALL install ncmpcpp when the module is loaded and ncmpcpp is not present on the system.

#### Scenario: ncmpcpp not installed

- **WHEN** the mpd module loads and `ncmpcpp` binary is not found
- **THEN** the system SHALL install ncmpcpp via the platform's package manager (brew on macOS, apt on Linux)

#### Scenario: ncmpcpp already installed

- **WHEN** the mpd module loads and `ncmpcpp` binary already exists
- **THEN** the system SHALL skip installation

### Requirement: ncmpcpp configuration deployment

The mpd module SHALL deploy ncmpcpp configuration to `~/.ncmpcpp/` on module load.

#### Scenario: Config directory does not exist

- **WHEN** `~/.ncmpcpp/` does not exist
- **THEN** the system SHALL create the directory and copy default config files (config, bindings)

#### Scenario: Config directory exists

- **WHEN** `~/.ncmpcpp/` already exists with user config
- **THEN** the system SHALL NOT overwrite existing configuration

### Requirement: ncmpcpp launch alias

The mpd module SHALL provide shell aliases for launching ncmpcpp.

#### Scenario: User uses ncmp alias

- **WHEN** user types `ncmp` in the shell
- **THEN** ncmpcpp SHALL launch

#### Scenario: User uses ncmpcpp alias

- **WHEN** user types `ncmpcpp` in the shell
- **THEN** ncmpcpp SHALL launch

### Requirement: ncmpcpp public API function

The mpd module SHALL expose a public function `mpd::ncmpcpp` to launch the client.

#### Scenario: Calling mpd::ncmpcpp

- **WHEN** user calls `mpd::ncmpcpp`
- **THEN** ncmpcpp SHALL launch in the current terminal

### Requirement: Cross-platform support

The ncmpcpp integration SHALL work on both macOS and Linux.

#### Scenario: macOS installation

- **WHEN** module loads on macOS
- **THEN** ncmpcpp SHALL be installed via Homebrew

#### Scenario: Linux installation

- **WHEN** module loads on Linux
- **THEN** ncmpcpp SHALL be installed via apt
