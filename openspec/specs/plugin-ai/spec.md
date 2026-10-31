# plugin-ai Specification

## Purpose
Integrate graphify as a knowledge graph tool for codebase analysis into the AI module, including OpenCode skill registration.

## Requirements

### Requirement: Configure graphify knowledge graph tool
The system SHALL integrate graphify as a knowledge graph tool for codebase analysis.

#### Scenario: Graphify available in AI toolkit
- **WHEN** user sources the AI module
- **THEN** graphify commands SHALL be available for codebase mapping and querying

#### Scenario: Graphify skill registered with OpenCode
- **WHEN** graphify is installed via the AI module
- **THEN** the graphify skill SHALL be registered with OpenCode for automatic graph queries

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
