# Tasks

## 1. Central MCP configuration

- [x] 1.1 Add `ZSH_AI_OPENCODE_MCP_TIMEOUT` and parallel associative arrays (`ZSH_AI_OPENCODE_MCP_NAMES`, `_TYPE`, `_COMMAND`, `_ENV`, `_DISABLED`) to `config/opencode.zsh`, aligned with `opencode.jsonc`, and verify `zsh -n` parses the file.
- [x] 1.2 Populate entries for all local MCPs (uvx/bunx/npx/docker/direct) with disabled flags preserved, and verify the name list matches `opencode.jsonc` server keys.
- [x] 1.3 Add remote (URL-only) entries with type `remote` and no command, and verify they are represented in the central config.

## 2. Internal validation

- [x] 2.1 Implement `ai::internal::opencode::mcp::_lookup` helper to fetch a server's metadata by name and return 1 with `message_error` for unknown names, verified by calling with a known and an unknown name.
- [x] 2.2 Implement `ai::internal::opencode::mcp::validate` with argument validation, disabled-flag handling (`--force`), remote skip, runner dispatch, process probe, and `message_*` reporting; verify a working MCP returns 0 and a failing one returns 1.
- [x] 2.3 Implement runner execution for `uvx`, `bunx`, `npx`, `docker run`, and direct binaries, substituting `{env:VAR}` placeholders, and verify each runner path is exercised.

## 3. Internal reinstall and cache cleanup

- [x] 3.1 Implement `ai::internal::opencode::mcp::_clean_cache` mapping runners to `~/.cache/uv`, `~/.bun/install/cache`, `~/.npm/_npx`, docker cleanup, or no-op for direct binaries; verify targeted directories are removed.
- [x] 3.2 Implement `ai::internal::opencode::mcp::reinstall` (clean cache, re-run command, re-validate) with clear messaging and non-zero returns on failure; verify a reinstall ends in successful validation.
- [x] 3.3 Add `--force` support to reinstall for disabled servers and verify disabled server reinstall requires the flag.

## 4. Public API

- [x] 4.1 Add `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` wrappers in `pkg/opencode.zsh` delegating to internal functions, and verify they are available after sourcing the module.
- [x] 4.2 Document usage in module README/help text and verify examples run as written.

## 5. Integration verification

- [x] 5.1 Source the module and confirm `ai::opencode::mcp::validate` and `ai::opencode::mcp::reinstall` resolve without errors.
- [x] 5.2 Run `zsh -n` on `config/opencode.zsh`, `internal/opencode.zsh`, and `pkg/opencode.zsh` and confirm no syntax errors.
- [x] 5.3 Validate the change with `openspec validate --change "add-opencode-mcp-tooling"` and confirm it passes.

## Workflow follow-up

- Archive the change after review requirements are satisfied.
- Verify the archived result.