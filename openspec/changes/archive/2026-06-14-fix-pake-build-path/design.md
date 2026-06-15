## Context

`apps::internal::webapp::build()` previously used `--target-path` to direct `pake`'s output to `${APPS_WEB_APPS_BUILD_DIR}`. The latest version of `pake` removed this flag — artifacts are always written to the current working directory. Currently the function runs `pake` without changing directory, so the artifact goes to the caller's cwd. The subsequent `find` in `APPS_WEB_APPS_BUILD_DIR` fails, and the artifact is effectively lost.

## Goals / Non-Goals

**Goals:**
- Make `pake` write artifacts into `${APPS_WEB_APPS_BUILD_DIR}`
- Preserve all existing function signatures (`build`, `all::build`, `install`, `all::install`, `ensure`)
- Keep the rename-to-lowercase logic working

**Non-Goals:**
- Change `APPS_WEB_APPS_BUILD_DIR` default or config
- Alter the `APPS_WEB_APPS_BUILD` `Name:url` format
- Add new functions or dependencies

## Decisions

| Decision | Rationale |
|---|---|
| `pushd`/`popd` around `pake` invocation | Minimal change, self-contained; `pake` writes to cwd, so we become the target dir. No subshell needed. |
| Keep `mkdir -p` inside `build()` | Already there, idempotent, ensures dir exists before `pushd`. |
| `all::build()` cleanup unchanged | Still cleans and recreates the build dir. The `mkdir` there is redundant with `build()`'s but harmless. Keep for clarity. |

## Risks / Trade-offs

- **Low risk**: Pure bug fix, no API changes, well-understood pattern (`pushd`/`popd` used throughout the codebase).
- **Edge case**: If `APPS_WEB_APPS_BUILD_DIR` is relative, `pushd`/`popd` handles it correctly (zsh tracks the stack).
