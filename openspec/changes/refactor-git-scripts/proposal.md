## Why

The `zsh/modules/git/bin/` directory contains 25 curated git helper scripts that have accumulated inconsistencies over time: mixed shebangs, redundant scripts, an obsolete Ruby dependency (`git-wtf`), no tests, and no documentation. This technical debt reduces maintainability and creates friction when onboarding new contributors or debugging issues.

## What Changes

- **BREAKING**: Remove `git-wtf` (364-line Ruby script) — replaced by `git-status-enhanced` (bash equivalent)
- Unify all shebangs to `#!/usr/bin/env bash` for portability
- Consolidate redundant `git-root` and `git-root-directory` into single `git-root`
- Replace deprecated `git filter-branch` usage in `git-change-author` with `git filter-repo`
- Add comprehensive test coverage for critical scripts
- Create module README documenting the full toolkit

## Capabilities

### New Capabilities
- `git-status-enhanced`: Bash-native replacement for `git-wtf` providing branch state visualization
- `git-scripts-testing`: Test framework and test suite for git helper scripts
- `git-scripts-documentation`: Module README with usage examples and contribution guidelines

### Modified Capabilities
<!-- No existing specs to modify -->

## Impact

- **Affected code**: All 25 scripts in `zsh/modules/git/bin/`
- **Dependencies removed**: Ruby (for `git-wtf`)
- **Dependencies added**: None (test framework uses bash + shunit2 or bats)
- **Breaking changes**: `git wtf` command removed (users must adapt to new command or alias)
- **Affected systems**: Developer workflow only (dotfiles repository)