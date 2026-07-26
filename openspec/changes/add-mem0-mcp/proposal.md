## Why

AI agents in OpenCode lose all context between sessions. mem0 provides persistent, semantic memory — agents can recall past interactions, preferences, and decisions without re-explaining. The cloud MCP server (`https://mcp.mem0.ai/mcp`) makes this zero-infrastructure: just an API key and a config entry.

## What Changes

- Add mem0 cloud MCP server to `data/opencode/opencode.json` (remote transport, `MEM0_API_KEY` auth)
- Create `internal/mem0.zsh` with load/install functions following the module's existing pattern
- Create `pkg/mem0.zsh` with public API: `ai::mem0::install`, `ai::mem0::key::setup`
- Add `MEM0_API_KEY` env var to `config/base.zsh`
- Integrate mem0 into `ai::sync` for config propagation
- Expose 11 MCP tools: `add_memory`, `search_memories`, `get_memories`, `get_memory`, `update_memory`, `delete_memory`, `delete_all_memories`, `delete_entities`, `list_entities`, `list_events`, `get_event_status`

## Capabilities

### Modified Capabilities
- `plugin-ai`: Add mem0 MCP server configuration and shell integration to the existing AI toolkit spec

### New Capabilities
- `mem0-memory`: Persistent semantic memory layer for AI agents via mem0 cloud MCP

## Impact

- **Config files**: `data/opencode/opencode.json` (new MCP server entry)
- **Shell module**: New `internal/mem0.zsh` + `pkg/mem0.zsh` files
- **Environment**: `config/base.zsh` gains `MEM0_API_KEY` variable
- **Dependencies**: Requires `MEM0_API_KEY` (user must run `mem0 init --agent` to obtain)
- **No breaking changes**: Additive only — existing tools unaffected
