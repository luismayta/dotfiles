# Design

## Context

The `ai` module uses a 3-layer architecture (`config/`, `internal/`, `pkg/`) with explicit file enumeration. OpenCode MCP servers are already declared in `data/opencode/opencode.jsonc` under `mcp.servers`. This change adds lifecycle functions to the existing `internal/opencode.zsh` and `pkg/opencode.zsh` (no new sourced files), plus a central data structure in `config/opencode.zsh`. See `proposal.md` for motivation.

## Goals / Non-Goals

**Goals:**
- Provide a single source of truth in shell for MCP metadata aligned with `opencode.jsonc`.
- Validate any local MCP by actually starting its command.
- Reinstall by clearing the runner cache and re-validating.
- Support `uvx`, `bunx`, `npx`, `docker run`, and direct binaries.
- Respect `disabled` and skip remote servers.

**Non-Goals:**
- No modification of `opencode.jsonc` or sync logic.
- No health-check for remote servers beyond skipping.
- No management of API keys or environment values (only pass-through).
- No changes to other modules.

## Decisions

### D1: Central config as parallel associative arrays
**Choice**: In `config/opencode.zsh`, define `ZSH_AI_OPENCODE_MCP_NAMES` (indexed array) plus associative arrays `ZSH_AI_OPENCODE_MCP_TYPE`, `_COMMAND`, `_ENV`, `_DISABLED` keyed by server name. Command stored as a space-joined string split on execution, environment as `KEY=VALUE` entries.
**Rationale**: Zsh has no nested associative arrays; parallel arrays are idiomatic and testable. Keeps config declarative and aligned with JSON.
**Alternative**: Parse `opencode.jsonc` at runtime with `jq` — rejected: adds dependency and fragility; static config is predictable.

### D2: Runner detection by first command token
**Choice**: Dispatch on the first element of the command array: `uvx`, `bunx`, `npx`, `docker`, or treat as direct binary.
**Rationale**: Matches opencode.jsonc entries and keeps logic simple.
**Alternative**: Infer from command path — rejected: unnecessary.

### D3: Validation via short-lived process probe
**Choice**: Launch the command with a 5-second timeout; if the process is still alive when the timeout fires, treat as success; if it exits before timeout, inspect exit status (0 = success, non-zero = failure).
**Rationale**: MCP servers are long-running stdio processes; a quick exit indicates failure.
**Alternative**: Check `--help` — rejected: not all servers support it.

### D4: Disabled handling
**Choice**: `validate`/`reinstall` skip disabled servers by default with `message_warning`, returning 1; accept `--force` to override.
**Rationale**: Prevents accidental heavy operations on disabled servers while allowing explicit checks.

### D5: Remote server handling
**Choice**: If type is `remote` or no command present, skip with `message_info` and return 0 (informational) — or non-zero? Spec says skip; keep return 0 for remote to avoid failing aggregate checks? Actually validate on a remote name should report skip and return 0 as informational. Documented.
**Rationale**: Remote servers cannot be executed locally.

### D6: Cache cleanup mapping
**Choice**: On reinstall, remove runner cache directories: uvx → `~/.cache/uv`; bunx → `~/.bun/install/cache`; npx → `~/.npm/_npx`; docker → `docker rm` containers using the image then `docker rmi` (or pull); direct binary → no cleanup with clear message.
**Rationale**: Matches each runner's cache location.

### D7: Public API delegation
**Choice**: `pkg/opencode.zsh` exposes `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` delegating to internal, following convention.
**Rationale**: Consistent with rest of module.

## Risks / Trade-offs

- **[Risk] Process probe may kill a slow-starting server** → Mitigation: 5s timeout configurable via `ZSH_AI_OPENCODE_MCP_TIMEOUT`.
- **[Risk] Environment placeholders `{env:VAR}`** → Mitigation: substitute from environment when building command; document requirement.
- **[Risk] Docker not installed** → Mitigation: check with `core::exists docker`; fail with clear message.
- **[Risk] Cache deletion is destructive** → Mitigation: only targeted runner cache dirs; confirm with message_info.
- **[Trade-off] Static config drift** → Mitigation: tasks include keeping config aligned; validation compares names.

## Migration Plan

1. Extend `config/opencode.zsh` with MCP arrays.
2. Add internal functions to `internal/opencode.zsh`.
3. Add public wrappers to `pkg/opencode.zsh`.
4. Update docs/README if needed.

Rollback: revert the three files; no external state changes.

## Open Questions

- Exact timeout default (5s) may need tuning after implementation.