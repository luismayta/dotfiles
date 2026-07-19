## Why

The Bitwarden zsh module (`zsh/modules/bitwarden/`) has critical functions that are defined but never invoked, causing silent failures. Specifically, `bw::load::env` loads environment variables from `~/.bw_env` (needed for Bitwarden CLI authentication), but no search function calls it before executing `bw list items`. Combined with `2>/dev/null` on all `bw` calls, auth errors are silently swallowed, making it appear as if there are no items instead of surfacing the real authentication problem.

Additionally, `bw::load::env` currently sources the entire `~/.bw_env` file without offering any selection. Users need the ability to choose which specific environment variable to load from a predefined list.

## What Changes

- **Auto-load environment**: Call `bw::load::env` at the start of `bw::search` and `bw::search::*` functions before invoking `bw list items`
- **Surface errors**: Remove or conditionalize `2>/dev/null` to expose authentication failures instead of hiding them
- **Interactive env selection**: Add `BITWARDEN_VARS_LIST` variable and modify `bw::load::env` to use fzf for variable selection
- **Remove unused dependency**: Drop the `rsync` requirement from `internal/main.zsh` (nothing in the module uses it)
- **Consolidate redundant helpers**: Remove duplicate `_get_type` / `_get_type_field` functions from `internal/helper.zsh` in favor of the `bw::value::*` functions in `pkg/base.zsh`

## Capabilities

### New Capabilities

- `bitwarden-interactive-env`: Interactive selection of Bitwarden environment variables using fzf, with a configurable list of available variables.

### Modified Capabilities

- `bitwarden-env-loading`: The `bw::load::env` function is now automatically invoked before any Bitwarden CLI operation, ensuring environment variables are available when needed.
- `bitwarden-search`: Search functions now surface authentication errors instead of silently failing.

## Impact

- **Affected files**: `pkg/helper.zsh`, `pkg/base.zsh`, `internal/main.zsh`, `internal/helper.zsh`, `internal/base.zsh`, `config/base.zsh`
- **Affected functions**: `bw::load::env`, `bw::search`, `bw::search::*`
- **Dependencies**: No new dependencies. Removed unused `rsync` dependency.
- **Breaking changes**: None — this is a backward-compatible fix. Users who were manually calling `bw::load::env` will see no change in behavior.
