## Context

`luismayta/zsh-scmbreeze` is an external zsh plugin providing scm_breeze integration for enhanced git status display, file indexing shortcuts, and repository navigation. Functions are under the `scmbreeze::` namespace. It wraps the popular scm_breeze tool with additional convenience functions.

## Goals / Non-Goals

**Goals:**
- Port all `scmbreeze::*` functions into `zsh/modules/scmbreeze/`
- Support darwin and linux OS dispatch
- Remove `luismayta/zsh-scmbreeze` from `zsh/zsh_plugins.txt`
- Maintain exact function names and behavior

**Non-Goals:**
- No changes to scm_breeze behavior or configuration
- No changes to zshenv or zshrc loader
- No bundling of scm_breeze itself — users install it separately

## Decisions

1. **Module root var**: `ZSH_SCMBREEZE_PATH` — follows the established pattern.
2. **Structure**: ~15 files. Integration layer that wraps scm_breeze installation and provides convenience functions.
3. **OS dispatch**: Minimal — scm_breeze works identically on darwin and linux.

## Risks / Trade-offs

- scm_breeze must be installed separately — module handles path setup and integration only.
- Version mismatch between installed scm_breeze and module expectations.
