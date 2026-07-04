## Why

RTK (Rust Token Killer) is installed in the ai module but lacks a managed configuration. Currently there's no way to persist tool exclusions (e.g., excluding `git rebase`, `curl`, or `docker exec` from RTK's automatic rewrite). Other tools in the module (opencode, pi) have a pattern: source config files in `data/<tool>/` synced via rsync to their runtime location. RTK needs the same treatment so exclusions are version-controlled and deployable.

## What Changes

- Add `AI_RTK_CONFIG_PATH` and `AI_RTK_CONFIG_SOURCE_PATH` variables to `config/base.zsh`
- Create `data/rtk/config.toml` with default RTK configuration including tool exclusions
- Add `ai::internal::rtk::config::sync` function to `internal/base.zsh` following the rsync pattern (matching opencode/pi sync)
- Wire the sync function into a user-facing command or helper, discoverable alongside existing sync commands

## Capabilities

### New Capabilities
- `rtk-config-sync`: Manage and deploy RTK configuration via rsync from the ai module's `data/rtk/` directory to `~/.config/rtk/`, with support for tool exclusions via `[hooks] exclude_commands`

### Modified Capabilities

*None — no existing specs are being modified.*

## Impact

- **Config**: Two new variables in `config/base.zsh`
- **Data**: New `data/rtk/config.toml` file (~15 lines)
- **Internal**: New `ai::internal::rtk::config::sync` function in `internal/base.zsh`
- **No breaking changes** — existing RTK load/install paths remain untouched
