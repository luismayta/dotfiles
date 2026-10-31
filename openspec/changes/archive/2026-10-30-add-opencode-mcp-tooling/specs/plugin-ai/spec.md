## ADDED Requirements

### Requirement: OpenCode MCP lifecycle API in AI module
The AI module SHALL expose public functions `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` for OpenCode MCP servers.

#### Scenario: Public functions available
- **WHEN** user sources the AI module
- **THEN** `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` SHALL be available

#### Scenario: Delegation to internal
- **WHEN** a public MCP function is invoked
- **THEN** it SHALL delegate to the corresponding `ai::internal::opencode::mcp::*` implementation

### Requirement: Central MCP config aligned with opencode.jsonc
The AI module SHALL provide a central MCP configuration aligned with `opencode.jsonc` for use by the lifecycle functions.

#### Scenario: Config available after load
- **WHEN** the AI module config layer loads
- **THEN** the central MCP configuration SHALL be populated from `opencode.jsonc`