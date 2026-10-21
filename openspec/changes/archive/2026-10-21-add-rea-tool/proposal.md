# Proposal

## Why

RD-245 asks the `ai` module to own REA (Reverse Engineer Anything), a local reverse-engineering toolkit for AI agents distributed as the npm package `rea-agents` v6.7.0. REA exposes 172 MCP tools, six guided MCP prompts, a `reverse-engineer-anything` skill, and a PATH-only `rea` CLI with no authentication, so it extends the agent stack without adding a service, key, or shell hook — but today nothing in the repository installs it, gates it on a compatible Node.js runtime, or registers its MCP server for the agent.

## What Changes

- Add `zsh/modules/ai/config/rea.zsh` defining the `ZSH_AI_REA_*` settings: package name/version and pinned package spec (`rea-agents@6.7.0`), install method, install URL, and the `~/.local/bin` binary directory used for PATH loading.
- Add `zsh/modules/ai/internal/rea.zsh` with `ai::internal::rea::load` (existence guard + PATH prepend of `${ZSH_AI_REA_BIN_PATH}`), a Node.js engine gate (accepts `^22.19.0`, `^24.11.0`, `>=26.0.0`; rejects 23.x and 25.x), an idempotent `core::exists rea` guard, install-method selection (npm, bun, curl), `ai::internal::rea::setup` / `doctor` / `update` / `uninstall` subcommand delegates, and `ai::internal::rea::post_install` guidance that documents the agent-side MCP tools and prompts.
- Add `zsh/modules/ai/pkg/rea.zsh` with the public wrappers `ai::rea::install`, `ai::rea::doctor`, `ai::rea::setup`, and `ai::rea::post_install`.
- Register the tool at the module's four mandatory registration points: config source + `ZSH_AI_TOOLS` entry, internal source + `ai::internal::rea::load`, pkg source, and an explicit `rea)` branch in the `internal/tools.zsh` install `case` before the `*)` fallback.
- Add `ai::rea::setup` to the `ai::setup` aggregate in `pkg/base.zsh`, because the tool exposes a setup verb.
- Template the agent-side MCP registration as a version-pinned `rea` entry in the OpenCode config template (`data/opencode/opencode.jsonc` → `mcp.rea` with `npx -y rea-agents@6.7.0 mcp`), so existing `ai::opencode::sync` propagates it.
- Delegate skill installation/refresh to `rea setup` (documented decision, no custom skill sync in the zsh module) and leave `README.md` / `README.yaml` untouched.

## Capabilities

### New Capabilities

- `ai-rea`: REA lifecycle in the `ai` module — dedicated `ZSH_AI_REA_*` configuration and registry entry, PATH load guard, Node.js engine gate, idempotent multi-method install, explicit install dispatch, public wrappers, skill delegation to `rea setup`, and agent-side MCP registration/documentation.

### Modified Capabilities

None. The tool uses only the existing lifecycle verbs (`install`, `setup`, `update`, `upgrade`) already permitted by `tool-lifecycle-standardization`; `doctor` and `uninstall` are thin subcommand wrappers, not new lifecycle verbs, so no existing requirement text changes.

## Impact

- **Code**: `zsh/modules/ai/config/rea.zsh`, `zsh/modules/ai/internal/rea.zsh`, `zsh/modules/ai/pkg/rea.zsh` (new); `zsh/modules/ai/config/base.zsh`, `zsh/modules/ai/internal/main.zsh`, `zsh/modules/ai/pkg/main.zsh`, `zsh/modules/ai/internal/tools.zsh`, `zsh/modules/ai/pkg/base.zsh` (registration); `zsh/modules/ai/data/opencode/opencode.jsonc` (MCP template).
- **Runtime dependencies**: Node.js `^22.19.0 || ^24.11.0 || >=26.0.0` plus npm (or bun for the bun method, curl for the curl method). No API key, no service, no Docker.
- **On-disk footprint**: `rea` binary in `${ZSH_AI_REA_BIN_PATH}` (`~/.local/bin` on Linux curl installs), REA state in `~/.rea`, skill in `~/.agents/skills/reverse-engineer-anything` (installed by `rea setup`), Hopper cache under `${XDG_CACHE_HOME:-$HOME/.cache}/rea`.
- **Not affected**: `README.md` / `README.yaml` (regenerated separately, no per-tool slot needed), `data/rea/` (no templates), and all non-`ai` modules.
