# Spec Delta

## Purpose

Provide lifecycle management for OpenCode MCP servers: a central configuration plus validate and reinstall operations that launch each server's command, report its health, and repair runner caches, exposed through the ai module.

## ADDED Requirements

### Requirement: Central MCP configuration
The system SHALL maintain a central configuration in `config/opencode.zsh` listing every OpenCode MCP server with its name, type, command, environment, and disabled flag, aligned with `opencode.jsonc`.

#### Scenario: Config lists a server
- **WHEN** the AI module config layer loads
- **THEN** the central MCP configuration SHALL contain an entry for each MCP defined in `opencode.jsonc`

#### Scenario: Disabled flag preserved
- **WHEN** an MCP is marked disabled in `opencode.jsonc`
- **THEN** its central config entry SHALL record `disabled: true`

### Requirement: Validate an MCP by launching its command
The system SHALL provide `ai::opencode::mcp::validate <name>` that launches the server's configured command and reports whether it starts successfully.

#### Scenario: Working MCP
- **WHEN** user runs `ai::opencode::mcp::validate <name>` for an enabled local MCP whose command starts
- **THEN** the system SHALL report success and return 0

#### Scenario: Failing MCP
- **WHEN** the configured command exits non-zero or fails to start
- **THEN** the system SHALL report an error through `message_error` and return 1

### Requirement: Reinstall an MCP
The system SHALL provide `ai::opencode::mcp::reinstall <name>` that clears the runner cache, reinstalls, and re-validates the server.

#### Scenario: Reinstall succeeds
- **WHEN** user runs `ai::opencode::mcp::reinstall <name>`
- **THEN** the system SHALL clear the detected runner cache, reinstall, run validate, and return 0 on success

#### Scenario: Reinstall fails
- **WHEN** cache cleanup or validation fails
- **THEN** the system SHALL report an error and return 1

### Requirement: Runner execution support
The system SHALL execute MCP commands for runners `uvx`, `bunx`, `npx`, `docker run`, and direct binaries.

#### Scenario: uvx runner
- **WHEN** an MCP command's first element is `uvx`
- **THEN** the system SHALL execute it through `uvx` and clean `~/.cache/uv` on reinstall

#### Scenario: bunx runner
- **WHEN** an MCP command's first element is `bunx`
- **THEN** the system SHALL execute it through `bunx` and clean `~/.bun/install/cache` on reinstall

#### Scenario: npx runner
- **WHEN** an MCP command's first element is `npx`
- **THEN** the system SHALL execute it through `npx` and clean `~/.npm/_npx` on reinstall

#### Scenario: docker runner
- **WHEN** an MCP command's first element is `docker`
- **THEN** the system SHALL execute it through `docker run` and clean containers/images on reinstall

#### Scenario: Direct binary
- **WHEN** an MCP command's first element is an absolute path or resolvable binary
- **THEN** the system SHALL execute it directly and report no cache cleanup on reinstall

### Requirement: Disabled MCPs skipped by default
The system SHALL skip validation of MCPs whose `disabled` flag is true unless the user explicitly forces it.

#### Scenario: Disabled server default
- **WHEN** user runs validate on a disabled MCP without a force flag
- **THEN** the system SHALL skip execution, emit an informational/warning message, and return non-zero

#### Scenario: Forced validation
- **WHEN** user passes a force flag for a disabled MCP
- **THEN** the system SHALL validate it despite the disabled flag

### Requirement: Remote servers not executed
The system SHALL not attempt to execute remote (URL-only) MCPs and SHALL report them as skipped.

#### Scenario: Remote server
- **WHEN** an MCP has type `remote` with only a URL
- **THEN** validate SHALL skip execution and report an informational message

### Requirement: Clear messaging and return codes
The system SHALL report outcomes through `message_info`, `message_success`, `message_warning`, and `message_error`, and SHALL return non-zero on any failure.

#### Scenario: Missing argument
- **WHEN** validate or reinstall is called without a name
- **THEN** the system SHALL print usage via `message_error` and return 1

#### Scenario: Unknown MCP
- **WHEN** the requested name is not in the central config
- **THEN** the system SHALL report an error and return 1