## ADDED Requirements

### Requirement: mem0 cloud MCP server configured in OpenCode
The system SHALL configure mem0 as a remote MCP server in OpenCode's configuration, connecting to `https://mcp.mem0.ai/mcp` with `MEM0_API_KEY` bearer authentication.

#### Scenario: MCP server entry exists in opencode.json
- **WHEN** `ai::sync` runs and propagates `data/opencode/opencode.json`
- **THEN** the `mem0` MCP server entry SHALL exist with `"type": "remote"`, `"url": "https://mcp.mem0.ai/mcp"`, and `"enabled": false`

#### Scenario: MCP server uses environment variable for auth
- **WHEN** the mem0 MCP server connects to the cloud endpoint
- **THEN** it SHALL authenticate using the `MEM0_API_KEY` environment variable via `{env:MEM0_API_KEY}` reference

### Requirement: mem0 API key management
The system SHALL provide shell functions to check, set, and validate the `MEM0_API_KEY` environment variable.

#### Scenario: Key check reports status
- **WHEN** user runs `ai::mem0::key::check`
- **THEN** system SHALL report whether `MEM0_API_KEY` is set and non-empty

#### Scenario: Key setup via mem0 CLI
- **WHEN** user runs `ai::mem0::key::setup`
- **THEN** system SHALL execute `mem0 init --agent --agent-caller opencode` to generate an API key
- **AND** prompt user to export the key in their shell profile

#### Scenario: Key validation
- **WHEN** user runs `ai::mem0::key::validate`
- **AND** `MEM0_API_KEY` is set
- **THEN** system SHALL verify the key format starts with `m0-`

### Requirement: mem0 install function
The system SHALL provide an install function that ensures the mem0 CLI is available.

#### Scenario: mem0 CLI already installed
- **WHEN** user runs `ai::mem0::install`
- **AND** `mem0` binary exists in PATH
- **THEN** system SHALL skip installation and report already installed

#### Scenario: mem0 CLI not installed
- **WHEN** user runs `ai::mem0::install`
- **AND** `mem0` binary is not in PATH
- **THEN** system SHALL install via `pip install mem0ai` or `uv tool install mem0ai`

### Requirement: mem0 tools available in OpenCode agents
OpenCode agents SHALL have access to mem0 memory tools when the MCP server is enabled.

#### Scenario: Memory operations via MCP
- **WHEN** mem0 MCP server is enabled and `MEM0_API_KEY` is set
- **THEN** agents SHALL have access to: `add_memory`, `search_memories`, `get_memories`, `get_memory`, `update_memory`, `delete_memory`, `delete_all_memories`, `delete_entities`, `list_entities`, `list_events`, `get_event_status`

### Requirement: Integration with ai::sync
The mem0 configuration SHALL be included in the master sync operation.

#### Scenario: ai::sync includes mem0
- **WHEN** user runs `ai::sync`
- **THEN** mem0 MCP configuration SHALL be propagated to `~/.config/opencode/opencode.json`
