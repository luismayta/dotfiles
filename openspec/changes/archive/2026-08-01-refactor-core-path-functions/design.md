## Context

The `zsh/core/` module contains utility functions for the dotfiles system. Currently, function naming is inconsistent: some follow the `core::*::*` pattern (e.g., `core::internal::core::install`), while others use shorter names without the `core::` prefix (e.g., `path::prepend`, `reload`, `editrc`). This creates confusion about which functions are part of the core module's public API versus internal implementation.

The codebase already has a clear naming convention established by the majority of functions in the core module. This refactoring brings the remaining functions into alignment with that convention.

## Goals / Non-Goals

**Goals:**
- Establish consistent `core::*::*` naming for all functions in `zsh/core/`
- Update all callers to use the new function names
- Consolidate duplicate `reload` implementations (Linux vs macOS)
- Maintain backward compatibility during transition (if needed)

**Non-Goals:**
- Refactor function signatures or behavior
- Change the module loading architecture
- Address naming in other modules (e.g., `git::`, `backup::`)
- Modify public utility functions (e.g., `fkill`, `fa`, `fo`) which intentionally use short names for CLI ergonomics

## Decisions

### 1. Naming Convention: `core::*::*` Pattern

**Decision**: Adopt the `core::<namespace>::<function>` pattern for all core functions.

**Rationale**: This matches the existing majority pattern in the module and provides clear namespacing. The pattern is:
- `core::path::prepend` (namespace: path, function: prepend)
- `core::editrc` (function: editrc - flat for simple utilities)
- `core::internal::backup` (internal implementation detail)

**Alternatives considered**:
- Keep short names: Rejected because it creates ambiguity with functions from other modules
- Use `core_<function>`: Rejected because `::` separator is already established and more readable

### 2. Consolidate Duplicate `reload` Implementations

**Decision**: Keep the platform-specific behavior but consolidate into a single function with platform detection.

**Rationale**: The `internal/reload.zsh` version uses `exec "${SHELL}"` while `internal/osx.zsh` uses `exec "${SHELL}" -l`. The `-l` flag is important for macOS to properly reload login shell environment. Consolidating avoids confusion and ensures correct behavior on both platforms.

**Implementation**: Modify `core::reload` to detect `$OSTYPE` and use `-l` flag on macOS.

### 3. Legacy Function Handling

**Decision**: Rename legacy functions (`backup`, `editrc`, etc.) to follow the new convention.

**Rationale**: These functions are part of the core module and should follow its naming convention. The rename makes the API consistent and easier to discover.

**Alternatives considered**:
- Deprecate and remove: Rejected because these functions are actively used
- Keep as aliases: Rejected because it maintains inconsistency

### 4. Caller Update Strategy

**Decision**: Update all callers in a single atomic change to avoid broken intermediate states.

**Rationale**: Since this is a breaking change, having a half-updated codebase would cause errors. Updating everything together ensures the codebase remains functional after the change.

### 5. Create jasper:: Wrapper Commands

**Decision**: Create new `jasper::*` wrapper commands in `bin/` that call the renamed `core::*` functions.

**Rationale**: This provides a clean public API with the `jasper::` prefix while keeping the implementation in the `core::` namespace. The wrappers are thin and just delegate to the core functions.

**Implementation**: Each wrapper script will simply call the corresponding `core::*` function. For example, `bin/jasper::reload` will contain `core::reload "$@"`.

## Risks / Trade-offs

**Risk**: Breaking changes may affect external scripts or user aliases
→ **Mitigation**: Search for all callers before renaming. Document the changes in a changelog or migration guide if needed.

**Risk**: Consolidating `reload` may change behavior on some platforms
→ **Mitigation**: Test on both Linux and macOS to ensure the consolidated function works correctly.

**Risk**: Forgetting to update some callers
→ **Mitigation**: Use grep/ripgrep to find all references to old function names before completing the change.

## Migration Plan

1. **Phase 1**: Rename functions in their definition files
2. **Phase 2**: Find all callers using grep/ripgrep
3. **Phase 3**: Update all callers to use new names
4. **Phase 4**: Test on both Linux and macOS
5. **Phase 5**: Verify no broken references remain

**Rollback**: Since this is a single commit change, revert the commit if issues arise.

## Open Questions

- Are there any external scripts or user configurations that call these functions?
- Should we provide backward-compatible aliases during a transition period?
- Do any other modules have similar naming inconsistencies that should be addressed?
