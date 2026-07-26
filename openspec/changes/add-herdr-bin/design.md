## Context

The herdr module is a zsh module that provides worktree management functionality. Currently, the worktree management functions (`hrdw::create`, `hrdw::list`, `hrdw::remove`) are defined as shell functions in `pkg/helper.zsh`. These functions are only available when the herdr module is loaded in a zsh session.

The git module provides a similar pattern with standalone executable scripts in its `bin/` directory (e.g., `git-sync`, `git-publish`). These scripts are standalone bash scripts that can be executed directly from the command line.

This change will create a similar `bin/` directory in the herdr module with standalone executable scripts for the worktree management commands.

## Goals / Non-Goals

**Goals:**
- Create a `bin/` directory in `zsh/modules/herdr/`
- Add executable scripts for `hrdw::create`, `hrdw::list`, and `hrdw::delete` (alias for `hrdw::remove`)
- Ensure the scripts are tracked in git (add `.gitignore` to not ignore content)
- Provide standalone CLI access to worktree management commands

**Non-Goals:**
- Modify existing shell functions in `pkg/helper.zsh`
- Change the herdr module's loading mechanism
- Add new worktree management functionality
- Create scripts for other herdr commands (e.g., `herdr::install`, `herdr::sync`)

## Decisions

### 1. Script Language: Bash vs Zsh

**Decision:** Use bash scripts (like the git module)

**Rationale:**
- The git module uses bash scripts, providing consistency
- Bash is more portable across different systems
- The scripts will be standalone and should not depend on zsh-specific features
- The existing herdr functions can be called from bash scripts if needed

**Alternatives considered:**
- Zsh scripts: Would be consistent with the herdr module's language, but less portable

### 2. Script Structure

**Decision:** Follow the same structure as git module scripts

**Rationale:**
- Each script will be a standalone executable file
- Scripts will define a function and call it at the end
- Scripts will include proper shebang (`#!/usr/bin/env bash`)
- Scripts will include comments and documentation

**Alternatives considered:**
- Simple wrapper scripts: Would be simpler but less maintainable

### 3. Command Mapping

**Decision:** Map existing herdr functions to standalone scripts

**Rationale:**
- `hrdw::create` → `hrdw-create` (script name)
- `hrdw::list` → `hrdw-list` (script name)
- `hrdw::remove` → `hrdw-delete` (script name, using "delete" as requested)

**Alternatives considered:**
- Use `hrdw::` namespace in script names: Would be confusing for standalone scripts

### 4. .gitignore Strategy

**Decision:** Add a `.gitignore` file in `bin/` that does not ignore the scripts

**Rationale:**
- Ensures the scripts are tracked in git
- Prevents accidental ignoring of the scripts
- Follows the pattern of other modules

**Alternatives considered:**
- No `.gitignore`: Would rely on git's default behavior

## Risks / Trade-offs

**Risk:** Scripts may not have access to all herdr functions
- **Mitigation:** Scripts can source the herdr module if needed, or implement functionality directly

**Risk:** Scripts may not work correctly in all environments
- **Mitigation:** Test scripts on different systems and provide fallback mechanisms

**Risk:** Maintenance overhead for additional scripts
- **Mitigation:** Keep scripts simple and focused, document clearly

## Migration Plan

This is a new addition, so no migration is needed. The scripts will be added alongside existing functionality.

## Open Questions

1. Should the scripts source the herdr module or implement functionality directly?
2. What should be the default behavior when a script is run without arguments?
3. Should the scripts provide help/usage information?