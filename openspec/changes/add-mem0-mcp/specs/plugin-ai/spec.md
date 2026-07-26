## ADDED Requirements

### Requirement: mem0 MCP server in AI toolkit
The system SHALL include mem0 as a configured MCP server within the AI module's OpenCode configuration.

#### Scenario: mem0 server entry in opencode.json
- **WHEN** the AI module syncs configuration to `~/.config/opencode/`
- **THEN** `opencode.json` SHALL contain a `mem0` MCP server entry with remote transport to `https://mcp.mem0.ai/mcp`

#### Scenario: mem0 disabled by default
- **WHEN** the mem0 MCP server is first added
- **THEN** `enabled` SHALL be `false` until user configures `MEM0_API_KEY`

### Requirement: mem0 shell functions in AI module
The AI module SHALL provide public shell functions for mem0 management.

#### Scenario: Public API available
- **WHEN** user sources the AI module
- **THEN** `ai::mem0::install`, `ai::mem0::key::check`, `ai::mem0::key::setup`, `ai::mem0::key::validate` SHALL be available

#### Scenario: Install idempotency
- **WHEN** user runs `ai::mem0::install` and mem0 is already installed
- **THEN** system SHALL return immediately without reinstallation
