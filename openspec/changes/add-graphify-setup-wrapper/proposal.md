## Why

The existing `ai::graphify::install` function registers graphify with OpenCode via `graphify install --platform opencode`, but there is no wrapper for the `--project` flag variant. Users need a callable function `ai::graphify::setup` that executes `graphify install --platform opencode --project` to register graphify skills scoped to the current project. This is needed for on-demand project-level setup without reinstalling graphify itself.

## What Changes

- Add `ai::graphify::setup` public function in `pkg/helper.zsh`
- Add `ai::internal::graphify::setup` internal implementation in `internal/base.zsh`
- The function wraps `graphify install --platform opencode --project` and reports success/failure

## Capabilities

### New Capabilities

- `graphify-setup`: Wrapper function that registers graphify skills for the current project via `graphify install --platform opencode --project`. Callable anytime, idempotent.

### Modified Capabilities

- `graphify-tool`: Add requirement for project-scoped setup function alongside existing install/upgrade/register_skill.

## Impact

- **Files modified**: `zsh/modules/ai/internal/base.zsh`, `zsh/modules/ai/pkg/helper.zsh`
- **New functions**: `ai::graphify::setup`, `ai::internal::graphify::setup`
- **No breaking changes**: Existing functions remain unchanged
- **No new dependencies**: Uses existing `graphify` binary
