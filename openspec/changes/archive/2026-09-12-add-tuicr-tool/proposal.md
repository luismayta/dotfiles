## Why

The `ai` module manages AI tools with a three-layer architecture (config/internal/pkg). tuicr (https://github.com/agavra/tuicr) is a code review TUI written in Rust with vim keybindings that lets users review diffs, comment inline, and export reviews to GitHub/GitLab/Gitea/Bitbucket/Azure DevOps/Gerrit. It is not yet integrated, so it cannot be installed, loaded, or invoked through the module's standard tool lifecycle. This change integrates tuicr following the established pattern used by hunk and the other tools in the module (RD-179).

## What Changes

- Add `zsh/modules/ai/config/tuicr.zsh` exporting `ZSH_AI_TUICR_BIN_PATH` (`${HOME}/.local/bin`) and `ZSH_AI_TUICR_CONFIG_PATH` (`${HOME}/.config/tuicr`), with all variables prefixed `ZSH_AI_TUICR_`.
- Add `zsh/modules/ai/internal/tuicr.zsh` with `ai::internal::tuicr::load` (guards on `core::exists tuicr` before prepending to PATH) and `ai::internal::tuicr::install` (installs via `cargo install tuicr`, verifying cargo availability first, with `message_info`/`message_success` feedback).
- Add `zsh/modules/ai/pkg/tuicr.zsh` exposing the public API: `ai::tuicr::install`, `ai::tuicr::review` (`tuicr "${@}"`), `ai::tuicr::pr` (`tuicr pr "${@}"`), `ai::tuicr::config::sync` (copies `data/tuicr/config.toml` to `~/.config/tuicr/`), and `ai::tuicr::post_install` (post-install guidance).
- Add `zsh/modules/ai/data/tuicr/config.toml` — valid TOML with `catppuccin-mocha` theme and vim keybindings.
- Register tuicr in the module: source `config/tuicr.zsh` and add `tuicr` to `ZSH_AI_TOOLS` in `config/base.zsh`; source `internal/tuicr.zsh` and invoke `ai::internal::tuicr::load` in `internal/main.zsh`; source `pkg/tuicr.zsh` in `pkg/main.zsh`.

## Capabilities

### New Capabilities

- `tuicr-ai-tool`: Integration of tuicr as a managed tool in the `ai` module — config variables, PATH loading, cargo-based installation, public review/pr/config-sync API, data-layer config template, and module registration (mirrors `jcode-ai-tool` / `omp-ai-tool`).

### Modified Capabilities

- None — no existing spec-level behavior changes; this is a new tool following the established per-tool pattern.

## Impact

- **Code**: `zsh/modules/ai/config/tuicr.zsh`, `zsh/modules/ai/internal/tuicr.zsh`, `zsh/modules/ai/pkg/tuicr.zsh`, `zsh/modules/ai/data/tuicr/config.toml` (new files); `zsh/modules/ai/config/base.zsh`, `zsh/modules/ai/internal/main.zsh`, `zsh/modules/ai/pkg/main.zsh` (registration edits).
- **Registry**: `ZSH_AI_TOOLS` gains `tuicr`; `ai::internal::packages::install` dispatch must reach `ai::internal::tuicr::install`.
- **Dependencies**: Rust toolchain (`cargo`) required at install time; tuicr binary installed to `${HOME}/.local/bin`.
- **Config**: `~/.config/tuicr/config.toml` provisioned from the module data layer on sync.
- **Docs**: Pattern reference `docs/guides/implement-tool-in-module.md`; upstream docs at https://tuicr.dev and https://github.com/agavra/tuicr/blob/main/docs/CONFIG.md.