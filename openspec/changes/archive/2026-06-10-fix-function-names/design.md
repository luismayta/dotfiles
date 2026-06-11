## Context

Static analysis of 409 `.sh`/`.zsh` files found 3 function call mismatches where the called name does not match any existing definition. These cause runtime "command not found" errors in the starship install flow, kubectl go package install flow, and kubectl internal package install flow. Additionally, 3 namespace functions (`core::load`, `core::multiplatform::install`, `core::snapshot`) are defined but never called.

The fixes are purely mechanical — rename the call site to match the actual function name. No logic changes, no API changes, no new dependencies.

## Goals / Non-Goals

**Goals:**
- Fix the 3 function call name mismatches so the affected modules work without errors
- Add an automated validation check to prevent future mismatches

**Non-Goals:**
- Refactoring or renaming the existing function definitions (only fix the call sites)
- Removing dead code (out of scope — separate change if desired)
- Changing function signatures or behavior

## Decisions

### Decision 1: Fix call sites, not definitions
The analysis found calls that don't match any definition. In all 3 cases the definition name is the correct one (it's used elsewhere consistently), so we fix the call site.

- `Goenv::` → `goenv::` — obvious typo (capital G)
- `starship::internal::starship::install` → `starship::internal::install` — extra namespace segment
- `goenv::internal::package::get` → this function simply doesn't exist. The surrounding pattern in `kubectl.zsh` shows it should call `goenv::internal::package::install` like all other similar blocks. Changing to `::install`.

### Decision 2: Single task spec validation
Add a `function-name-validation` spec that codifies the expectation that all function call names resolve to a definition. This is a simple grep-based or ast_grep-based check that can run in CI.

## Risks / Trade-offs

- **Low risk**: All 3 fixes are in auxiliary install/package paths that only run when the tool is being set up. Errors in these paths currently block module initialization silently.
- **No rollback needed**: Each fix is a single-string change. Revert is trivial.