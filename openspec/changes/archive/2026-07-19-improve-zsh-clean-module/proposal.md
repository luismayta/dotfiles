## Why

The `zsh/modules/clean/` module has significant gaps in functionality, safety, and code organization. Currently, it lacks proper platform-specific implementations (Linux functions are stubs), has duplicated code between `cleanup` and `cleanup::unnecessary`, missing safety features (no dry-run or confirmation), and doesn't leverage reusable utilities from `zsh/core/`. This improvement will modernize the module to be safer, more comprehensive, and better integrated with the core dotfiles architecture.

## What Changes

- **Consolidate duplicate cleanup functions** - Merge `cleanup::unnecessary` into `cleanup` to eliminate redundant file pattern matching
- **Complete Linux platform support** - Implement actual trash and log cleanup for Linux systems instead of warning stubs
- **Add safety features** - Introduce `--dry-run` flag, confirmation prompts, and detailed logging of deletions
- **Leverage core utilities** - Replace inline message functions with `message_info`, `message_success`, `message_warning`, `message_error` from `zsh/core/`
- **Make paths configurable** - Allow users to define custom cache/log paths via environment variables
- **Extend tool coverage** - Add cleanup for modern development tools: rust/cargo, go modules, bun, pnpm, ccache, Docker volumes
- **Integrate platform functions** - Call all OS-specific functions (adobe_cache, ios_backup, xcode) from `cleanup::all`
- **Fix error messages** - Correct typo in `CLEAN_MESSAGE_NOT_IMPLEMENTED` and improve user feedback

## Capabilities

### New Capabilities

- `cleanup-safety`: Dry-run mode, confirmation prompts, and deletion logging for safe cleanup operations
- `cleanup-configurability`: Environment variable-based configuration for custom paths and behavior
- `cleanup-modern-tools`: Support for cleaning caches from rust/cargo, go, bun, pnpm, ccache, and Docker volumes

### Modified Capabilities

- `cleanup-core`: Refactor to use core messaging utilities and consolidate duplicate functions
- `cleanup-platform`: Complete Linux implementations and integrate all platform-specific functions

## Impact

- **Affected Code**: `zsh/modules/clean/pkg/base.zsh`, `zsh/modules/clean/pkg/linux.zsh`, `zsh/modules/clean/pkg/osx.zsh`, `zsh/modules/clean/config/base.zsh`
- **Dependencies**: Relies on `zsh/core/` for messaging functions (`message_info`, `message_success`, etc.)
- **Breaking Changes**: None - all existing function signatures preserved, new features are opt-in via flags/environment variables
- **Testing**: Manual testing on Linux and macOS to verify cleanup operations work correctly with new safety features
