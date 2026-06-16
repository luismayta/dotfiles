## Context

The `zsh/modules/docker/` module manages Docker and alternative container runtimes (orbstack, colima, lima, podman) with a multi-layer architecture: `config/` (runtime selection), `internal/` (implementation), `pkg/` (public API). An audit revealed 19 issues: 3 bugs, 3 duplications, 9 placeholder files (36% of codebase), dead code, namespace inconsistency, and redundant execution.

## Goals / Non-Goals

**Goals:**
- Fix 3 bugs: invalid `dangling=true` filter on `docker ps`, duplicate `network::dangling`, `container::delete::dangling` stopping instead of deleting
- Delete 9 placeholder files (no-op stubs with no content)
- Remove dead `container::core` function definitions (defined but never called)
- Migrate `container::internal::container::*` namespace to `docker::internal::*`
- Eliminate redundant double install/load execution
- Merge duplicate `process::stop::all` / `container::stop::all` into one

**Non-Goals:**
- No API changes — all public function signatures remain identical
- No new container runtime support
- No restructuring of the 3-layer architecture
- No changes to Docker CLI wrappers (awscli, nyancat, etc.)

## Decisions

1. **Delete (not migrate) placeholders** — 9 files are empty stubs with only comments. Deleting them is cleaner than populating them with hypothetical future content. If needed later, the module pattern is well-documented.

2. **Remove (not fix) `container::core`** — The function is defined in 4 config files but never invoked anywhere in the codebase. It was likely intended as a hook that was never wired up. Removing the dead definitions eliminates confusion without affecting behavior.

3. **Rename namespace `container::` → `docker::`** — The internal provider functions (`container::internal::container::install/load`) use the `container::` prefix while everything else uses `docker::`. Migrating to `docker::internal::container::install/load` aligns with the module-wide convention and eliminates the namespace split.

4. **Keep one install/load path** — Remove the duplicate call in `pkg/base.zsh` lines 86-87 since `internal/main.zsh` already handles it. Both are idempotent but removing the duplicate reduces confusion and startup time.

5. **Container management consolidation** — Merge `docker::internal::process::stop::all` and `docker::internal::container::stop::all` into a single `docker::internal::container::stop::all`, keeping the container-prefixed variant as canonical since it's more specific.

6. **Naming corrections** — Rename `process::list` (currently uses `docker ps -l` meaning "latest") → correct to `docker ps` without `-l`. Rename `clean::process::dangling` to `clean::process::exited` since "dangling" is not a valid container concept.

## Risks / Trade-offs

- **[Risk]** Removing 9 placeholder files could break references in tooling or documentation → **Mitigation**: No code references these files; they are empty stubs with no dependents.
- **[Risk]** Renaming `container::internal::container::*` could break external code that calls these directly → **Mitigation**: These are internal functions (no public API guarantee); the public wrappers in `pkg/` remain unchanged.
- **[Risk]** Removing duplicate install/load in `pkg/base.zsh` could break if `internal/main.zsh` fails silently → **Mitigation**: `internal/main.zsh` runs before `pkg/base.zsh` in the load order (`plugin.zsh` sources internal before pkg), so install/load is already complete by the time pkg runs.
