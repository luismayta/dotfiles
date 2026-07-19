## Why

The current `bitwarden::internal::load::env` function is overcomplicating vault environment loading. It manually handles `.bw_env` file sourcing, performs `bw get item` calls, and extracts passwords with `jq` — all logic that `env-secrets` already handles. This creates maintenance burden and inconsistent behavior across different vault configurations.

## What Changes

- **Simplify `bitwarden::internal::load::env`**: Replace the complex manual extraction logic with a clean fzf selection + `env-secrets` delegation
- **Remove `.bw_env` file dependency**: No longer check or source `.bw_env` files
- **Remove manual `bw get item` + `jq` extraction**: Delegate to `env-secrets bw {selected}` instead
- **Preserve existing behavior**: Keep fzf selection from `BITWARDEN_VARS_LIST`, keep "do nothing if cancelled" behavior

## Capabilities

### New Capabilities

- `bitwardenvaultload`: Simplified vault environment loading via env-secrets delegation

### Modified Capabilities

<!-- None - this is a simplification of internal implementation -->

## Impact

- **Files modified**: `zsh/modules/bitwarden/internal/base.zsh`
- **Functions affected**: `bitwarden::internal::load::env` (simplified)
- **Dependencies**: Requires `env-secrets` CLI tool (already installed via goenv)
- **Breaking changes**: None — public API (`bw::load::env`) remains identical
- **Callers unaffected**: All `bw::search::*` functions continue to work via the wrapper
