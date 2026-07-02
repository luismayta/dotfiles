## Context

The AI zsh module (`zsh/modules/ai/`) manages installation, PATH loading, and configuration of 8 AI CLI tools: opencode, fabric, ollama, shimmy, hf, openclaw, codegraph, and tmuxai. Each tool follows a consistent three-layer pattern:

1. **config/base.zsh** — declares installation URLs, paths, and extends `$AI_TOOLS`
2. **internal/base.zsh** — implements installer function + PATH loader
3. **pkg/helper.zsh** — exposes public wrapper function

`rtk` (from `rtk-ai/rtk`) is an AI terminal assistant installed via `curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh`. Its install script places the binary in `~/.local/bin/` by default (same as shimmy, openclaw, codegraph).

## Goals / Non-Goals

**Goals:**
- Add `rtk` to the `$AI_TOOLS` array so it installs via the batch `ai::install` command
- Implement `ai::internal::rtk::install` following the same `curl | sh` pattern as codegraph/ollama
- Implement `ai::internal::rtk::load` to add `~/.local/bin/` to PATH when the binary exists
- Add public wrapper `ai::rtk::install` in pkg/helper.zsh

**Non-Goals:**
- No rtk config management or data sync (rtk has no emulated config like opencode or fabric patterns)
- No OS-specific overrides (single install URL for all platforms)
- No breaking changes to existing tooling

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| **Install method** | `curl -fsSL URL | sh` | rtk's official install uses `sh` (not `bash`). Matches the codegraph/ollama pattern exactly. |
| **Binary path** | `~/.local/bin` (same as codegraph, shimmy, openclaw) | rtk installs to `~/.local/bin/rtk`. Reuse `AI_CODEGRAPH_BIN_PATH` is not correct semantically — declare a dedicated `AI_RTK_BIN_PATH="${HOME}/.local/bin"` for consistency. |
| **PATH loader location** | `internal/main.zsh` alongside opencode/shimmy/codegraph | Maintains single source of truth for PATH additions. |
| **AI_TOOLS position** | End of array, before closing paren | Convention used by all tools. Alphabetical order within the group isn't enforced — just append. |
| **Public wrapper** | `pkg/helper.zsh` with `ai::rtk::install` | Standard pattern matching every other tool's API. |

## Risks / Trade-offs

- **Risk:** `rtk` install script could change its URL or binary name. → **Mitigation:** Same risk applies to all curl-piped installs; URL is pinned to a specific refs/heads/master path. Pin to a release tag if instability arises.
- **Risk:** `~/.local/bin` may not exist on first install. → **Mitigation:** rtk's install.sh creates the dir; our PATH loader checks existence before adding to PATH (`[ -e "${AI_RTK_BIN_PATH}/rtk" ]`).
- **Trade-off:** Using a dedicated `AI_RTK_BIN_PATH` instead of sharing with other tools duplicates the `~/.local/bin` value across variables — but maintains the convention and makes per-tool overrides possible.
