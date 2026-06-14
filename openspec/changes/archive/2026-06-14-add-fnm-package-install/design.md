## Context

The `fnm` module manages Node.js tooling (fnm itself, bun, Node versions) and a set of global bun packages defined in `FNM_PACKAGES` (npm, pnpm, typescript, vercel, etc.). Currently the only install path is `fnm::internal::packages::install`, which iterates over the full `FNM_PACKAGES` array and installs everything. There is no way to install a single package on demand — for example, installing a package not in the default set, or retrying a single failed install.

The module follows a consistent two-layer pattern:
- **Internal** (`internal/base.zsh`): Implements the actual logic with `fnm::internal::<name>` naming
- **Public** (`pkg/base.zsh`): Thin delegation functions `fnm::<name>` that call the internal variant

## Goals / Non-Goals

**Goals:**
- Add `fnm::internal::package::install` accepting a single package name argument
- Add `fnm::package::install` public delegating function
- Validate that a package name was provided
- Use `bun install -g <package>` (consistent with existing batch logic)
- Follow existing error-handling pattern (`message_error` / `return 1`)

**Non-Goals:**
- Not modifying `fnm::internal::packages::install` (batch install remains unchanged)
- Not modifying `FNM_PACKAGES` config or adding new config variables
- Not adding support for flags/options (`--save-dev`, `--production`, etc.)

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Naming convention | `fnm::internal::package::install` (singular) | Plural `packages::install` is the batch variant; singular `package::install` signals single-argument operation |
| Argument passing | Positional `$1` | Consistent with how `fnm::internal::version::all::install` uses `$version` in its loop; no need for flag parsing |
| Error handling | `[[ -z "${1:-}" ]] && return 1` | Matches `fnm::internal::fnm::upgrade` style; clear message via `message_error` |
| Installation command | `bun install -g "${package}"` | Exact same tool used by `packages::install`; `fnm::internal::bun::install` already runs before this code path |
| ShellCheck | Add `# shellcheck disable=SC2154` if needed | Pattern established in existing functions referencing FNM_* variables |

## Risks / Trade-offs

- **Risk: bun not available** → Mitigation: `pkg/base.zsh` already calls `fnm::internal::bun::install` before any package operations, so bun is guaranteed present when the public function is called
- **Risk: ShellCheck SC2154** → Mitigation: existing pattern in the file is `# shellcheck disable=SC2154`; if the new function references no new external vars, no change needed
- **Risk: Argument too long / special chars** → Mitigation: bun handles its own argument validation; we pass the argument as-is with standard quoting
