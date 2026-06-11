## Why

SCM Breeze's `scmb_expand_args` function (used to expand git status shortcut arguments like `1 3 6` into file paths) uses recursion that hits the default `FUNCNEST=700` limit, producing `scmb_expand_args:2: maximum nested function level reached; increase FUNCNEST?`. This breaks all SCM Breeze git status shortcuts until the shell is restarted.

## What Changes

- Add `export FUNCNEST=5000` to the scmbreeze module's `config/base.zsh` so it is set *before* SCM Breeze is loaded.
- This ensures the recursion limit is high enough for `scmb_expand_args` to complete normally.

## Capabilities

### New Capabilities
- `funcnest-config`: Raise `FUNCNEST` to a safe value (5000) in the scmbreeze module configuration to prevent `scmb_expand_args` recursion crashes.

### Modified Capabilities
- *(none)*

## Impact

- **File modified**: `zsh/modules/scmbreeze/config/base.zsh` — one-line addition.
- **No breaking changes**: Existing SCM Breeze behavior is preserved; recursion errors simply stop happening.
- **No dependencies affected**.
