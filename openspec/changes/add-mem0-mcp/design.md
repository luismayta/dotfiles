## Context

The `zsh/modules/ai/` module manages 12+ AI tools with a consistent 3-layer architecture: `config/` (env vars), `internal/` (private functions), `pkg/` (public API). MCP servers are configured in `data/opencode/opencode.json` under the `"mcp"` key — 28 servers are defined, 14 enabled.

mem0 provides persistent semantic memory for AI agents via a cloud MCP server at `https://mcp.mem0.ai/mcp`. Transport is Streamable HTTP with `MEM0_API_KEY` bearer auth. No local infrastructure required.

**Current state**: No memory/persistence layer exists in the AI toolkit. Agents lose all context between sessions.

**Stakeholders**: Luchex (primary user), OpenCode agents (consumers of mem0 tools).

## Goals / Non-Goals

**Goals:**
- Add mem0 cloud MCP server to OpenCode configuration
- Create shell functions following the module's existing pattern (idempotent install, config sync)
- Provide `ai::mem0::key::setup` for first-time API key generation via `mem0 init --agent`
- Integrate into `ai::sync` for config propagation
- Zero breaking changes to existing tools

**Non-Goals:**
- Self-hosted OpenMemory server (being sunset upstream)
- Custom memory pipelines or preprocessing
- Multi-user/team memory isolation (cloud handles this)
- Local LLM integration for mem0 (cloud-only for now)

## Decisions

### D1: Cloud MCP over self-hosted
**Choice**: Use `https://mcp.mem0.ai/mcp` (remote transport)
**Rationale**: Zero infrastructure, mem0 manages scaling/auth. Self-hosted OpenMemory is being deprecated. Matches existing pattern (Jira and People API already use remote MCP).
**Alternative considered**: Self-hosted via `openmemory/` — rejected due to sunset status and operational overhead.

### D2: Remote MCP type in opencode.json
**Choice**: `"type": "remote"` with `"url"` field
**Rationale**: Consistent with existing remote servers (jira, people). No local process to manage.
**Alternative**: `"type": "local"` with `npx` command — unnecessary for HTTP endpoint.

### D3: API key via env var, not hardcoded
**Choice**: `MEM0_API_KEY` in environment, referenced as `{env:MEM0_API_KEY}` in config
**Rationale**: Follows pattern of all other API keys (GOOGLE_API_KEY, OPENAI_API_KEY, etc.). Allows per-machine variation without config changes.

### D4: Separate internal/pkg files vs. adding to existing tools.zsh
**Choice**: Create dedicated `internal/mem0.zsh` and `pkg/mem0.zsh`
**Rationale**: mem0 has its own install flow (`mem0 init --agent`) and key management — too complex for tools.zsh. Follows precedent of opencode.zsh, fabric.zsh, ollama.zsh having dedicated files.

### D5: Disabled by default
**Choice**: `"enabled": false` in opencode.json
**Rationale**: Requires `MEM0_API_KEY` to function. User must run `ai::mem0::key::setup` first. Enabling without key would cause connection errors.

## Risks / Trade-offs

- **[Risk] API key not set** → MCP server connection fails silently. Mitigation: `ai::mem0::key::setup` validates key; opencode.json uses `{env:MEM0_API_KEY}` which resolves to empty string if unset.
- **[Risk] mem0 cloud outage** → Memory tools unavailable. Mitigation: Non-critical — agents work without memory, just lose persistence. No dependency from other tools.
- **[Risk] Free tier limits** → 50 queries/day on free plan. Mitigation: Document in setup instructions. Users can upgrade mem0 plan.
- **[Trade-off] Cloud dependency** → Data leaves local machine. Acceptable for memory use case (conversations, preferences). User controls what gets stored via `add_memory`.
