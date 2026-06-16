## Why

The `zsh/modules/docker/` module has accumulated technical debt: 3 confirmed bugs (invalid Docker filters, dangling non-concepts), 3 duplicated functions, 9 placeholder files comprising 36% of the codebase, dead code (`container::core` defined but never called), inconsistent namespaces (`container::` vs `docker::`), and redundant double execution of install/load. These issues don't block daily use but reduce maintainability and can cause silent failures.

## What Changes

- **Fix 3 bugs**: Remove invalid `dangling=true` filter on `docker ps` (only valid for images/volumes), remove non-existent `network::dangling` duplicate, align `container::delete::dangling` to actually delete (not just stop)
- **Remove 9 placeholder files**: Delete empty stub files across `config/`, `internal/`, `pkg/` directories
- **Remove dead code**: Delete `container::core` definitions that are never invoked
- **Unify namespaces**: Migrate `container::internal::container::*` → `docker::internal::*`
- **Eliminate double execution**: Remove redundant install/load call from `pkg/base.zsh` (already runs in `internal/main.zsh`)
- **Merge duplicates**: Consolidate `process::stop::all` and `container::stop::all` into one
- **Fix naming**: Rename `process::list` to use `docker ps` (not `-l` for "latest"), rename `clean::process::dangling` to `clean::process::exited`

## Capabilities

### New Capabilities

*(No new capabilities — all changes are code quality improvements and bug fixes within existing specs)*

### Modified Capabilities

*(No spec-level requirement changes — all improvements fix implementation bugs or reduce technical debt without changing the external contract)*

## Impact

- **Affected code**: 16 files across `zsh/modules/docker/` — `config/`, `internal/`, `pkg/`
- **No API breaking changes**: All public function signatures remain identical
- **Backward compatible**: Bug fixes make functions work as originally intended; removed dead code/placeholders have no runtime effect
