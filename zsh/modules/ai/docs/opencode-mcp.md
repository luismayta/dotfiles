## OpenCode MCP Lifecycle

Manage OpenCode MCP servers defined in the central config (`config/opencode.zsh`).

### Validate

Check that an MCP server starts correctly:

    ai::opencode::mcp::validate context7

Force-validate a disabled server:

    ai::opencode::mcp::validate --force git

### Reinstall

Clean the runner cache and re-validate:

    ai::opencode::mcp::reinstall context7

Force-reinstall a disabled server:

    ai::opencode::mcp::reinstall --force git

### Notes

- Remote (URL-only) servers are skipped with an informational message (return 0).
- Disabled servers return 1 by default; use `--force` to override.
- Supported runners: `uvx`, `bunx`, `npx`, `docker run`, and direct binaries.
- Cache cleanup targets:
  - `uvx` → `~/.cache/uv`
  - `bunx` → `~/.bun/install/cache`
  - `npx` → `~/.npm/_npx`
  - `docker` → image/container cleanup + fresh pull
  - direct binary → no-op
- ⚠️ **Drift note**: The config template `zsh/modules/ai/data/opencode/opencode.jsonc` (25 servers) is out of sync with the live config `~/.config/opencode/opencode.jsonc` (28 servers). The live version includes additional servers (`aws-mcp`, `rea`, `postgres`). Synchronizing them is out of scope for this change.
