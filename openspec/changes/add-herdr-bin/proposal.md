## Why

The herdr module currently provides worktree management functions (`hrdw::create`, `hrdw::list`, `hrdw::remove`) as shell functions in `pkg/helper.zsh`. However, these functions are only available when the herdr module is loaded in a zsh session. To provide standalone CLI access to these commands (similar to how the git module provides `git-sync` and other commands in its `bin/` folder), we need to create executable scripts in a `bin/` directory.

This change will:
1. Create a `bin/` folder in the herdr module with executable scripts
2. Add a `.gitignore` to ensure the scripts are tracked in git
3. Provide standalone CLI access to worktree management commands

## What Changes

- Create `zsh/modules/herdr/bin/` directory
- Add executable scripts for `hrdw::create`, `hrdw::list`, and `hrdw::delete` (alias for `hrdw::remove`)
- Add `.gitignore` in `bin/` to ensure scripts are tracked
- Each script will be a standalone bash/zsh script that can be executed directly

## Capabilities

### New Capabilities
- `herdr-cli`: Standalone CLI commands for herdr worktree management (hrdw::create, hrdw::list, hrdw::delete)

### Modified Capabilities
- None

## Impact

- New `bin/` directory in `zsh/modules/herdr/`
- Three new executable scripts
- `.gitignore` file in `bin/` directory
- No changes to existing functionality