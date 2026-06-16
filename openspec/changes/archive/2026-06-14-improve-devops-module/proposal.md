## Why

The `zsh/modules/devops/` module has accumulated technical debt since its initial migration: three upgrade functions are unimplemented stubs with a typo ("method not implement"), the k9s config sync is macOS-only, helm is unnecessarily coupled inside kubectl's factory, and several patterns (bare `cd -`, hardcoded paths) are fragile. These issues don't block daily use, but they undermine reliability when upgrading tools or running on Linux.

## What Changes

- **Implement upgrade stubs**: Replace `devops::upgrade`, `devops::k9s::upgrade`, and `devops::helm::upgrade` no-op stubs with real implementations (delegate to `core::upgrade` or tool-native upgrade)
- **Fix typo**: Correct "method not implement" → "method not implemented" across 3 files
- **Add Linux k9s config sync**: Make `DEVOPS_K9S_CONF_PATH` platform-aware (macOS → `~/Library/Application Support/k9s`, Linux → `~/.config/k9s`)
- **Desacoplar helm de kubectl factory**: Remove `core::ensure helm` from `kubectl::internal::main::factory`; helm is already ensured by its own factory
- **Safer tfenv upgrade**: Replace `cd "${path_tfenv}" && git pull && cd -` with `git -C` to avoid stdout pollution and path-splitting issues
- **Remove redundant no-op post_install hooks**: Drop `devops::helm::post_install` (pure log line) in favor of the module-level handler

## Capabilities

### New Capabilities

- `k9s-cross-platform`: Cross-platform k9s config sync that detects the OS and syncs to the correct k9s config directory (macOS and Linux)

### Modified Capabilities

*(No spec-level requirement changes — all improvements are implementation quality within existing specs)*

## Impact

- **Affected code**: 10 files across `zsh/modules/devops/` — `config/`, `internal/`, `pkg/`
- **No API breaking changes**: All public function signatures remain identical
- **Backward compatible**: Existing users see no behavioral difference; Linux users gain working k9s sync
