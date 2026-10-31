# Proposal

## Why

OpenCode MCP servers are configured in `opencode.jsonc`, but there is no shell-level tooling to validate that an MCP actually starts, or to clean and reinstall a broken runner cache. Debugging a failing MCP currently means manually running `uvx`/`bunx`/`npx`/`docker run` and hunting cache directories. RD-268 asks for a centralized, config-driven lifecycle (`validate`, `reinstall`) exposed through the `ai` module, so any of the 25+ configured servers can be checked or repaired with one command.

## What Changes

- Add a central zsh data structure in `config/opencode.zsh` listing every MCP (name, type, command, environment, disabled flag) aligned with `opencode.jsonc`.
- Add internal functions `ai::internal::opencode::mcp::validate` and `ai::internal::opencode::mcp::reinstall` (plus runner detection and cache cleanup helpers) in `internal/opencode.zsh`.
- Add public API `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` in `pkg/opencode.zsh`.
- Support execution for `uvx`, `bunx`, `npx`, `docker run`, and direct binaries.
- Respect the `disabled` flag: disabled MCPs are skipped by default unless explicitly forced.
- Skip remote (URL-only) servers with an informational message instead of attempting to execute a command.
- Clear the relevant runner cache before reinstalling (`~/.cache/uv`, `~/.bun/install/cache`, `~/.npm/_npx`, docker image/container cleanup; no-op for direct binaries).
- Report success/failure through `message_info`/`message_success`/`message_error`/`message_warning` and return non-zero on failure.

## Capabilities

### New Capabilities
- `opencode-mcp`: Lifecycle management (validate, reinstall, runner dispatch, cache cleanup) for OpenCode MCP servers driven by a central config.

### Modified Capabilities
- `plugin-ai`: Expose MCP lifecycle functions through the AI module's public API and config layer.

## Impact

- **Config files**: `zsh/modules/ai/config/opencode.zsh` gains MCP central config; `zsh/modules/ai/internal/opencode.zsh` and `pkg/opencode.zsh` gain new functions.
- **Dependencies**: `core::exists` for runner/binary availability; `message_*` helpers from `zsh/system/core/pkg/base.zsh`.
- **No breaking changes**: Additive only — existing `ai::opencode::*` functions remain unchanged.
- **Remote servers**: Not executed; documented as out of scope for command validation.