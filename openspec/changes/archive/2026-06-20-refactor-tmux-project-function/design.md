## Context

The `tx::project` function in `zsh/modules/tmux/pkg/helper.zsh` is a monolith of 85 lines with 9 distinct responsibilities. The module already follows a convention of splitting concerns: `pkg/` for public API functions, `internal/` for private utilities. Several functions in `pkg/helper.zsh` (like `tx::project`, `ftm`, `ftmk`) are mixed together, and `tx::project` itself interleaves template discovery, user interaction, name processing, and process orchestration.

This refactoring decomposes `tx::project` into focused internal functions without changing any public behavior.

## Goals / Non-Goals

**Goals:**
- Extract 4 internal functions under `zsh/modules/tmux/internal/` with clean interfaces
- Rewrite `tx::project` as a ~30-line orchestrator
- Maintain 100% backward compatibility — same public API, same behavior
- Follow the module's existing `internal/` convention

**Non-Goals:**
- No behavioral changes to `tx::project`, `ftm`, or `ftmk`
- No changes to tmuxinator, fzf, or bat integration patterns
- No test framework setup (though extracted functions will be testable)

## Decisions

1. **Internal naming convention**: `tx::internal::<name>` — matches the existing `tx::` prefix pattern and clearly separates public vs internal scope
2. **Communication via stdout**: Each internal function writes its result to stdout; the caller captures with `$(...)`. This is idiomatic zsh and makes functions composable
3. **Return codes for flow control**: `attach_if_exists` returns 0 (handled) or 1 (not found) so the orchestrator can use `&& return 0` — clean, no global state
4. **One file per function group**: Each `.zsh` file in `internal/` contains one logical function, keeping files small and focused. The exception is `select-template` which composes `list_templates` + `preview_command` but lives in its own file
5. **Source order independence**: Internal functions have no cross-dependencies at the zsh source level — they depend only on `core::exists` and standard tools. `plugin.zsh` can source them in any order

## Risks / Trade-offs

- **[Regression]** Extracting code that uses global variables (`TMUXINATOR_TEMPLATE_PATH`, `TMUXINATOR_DEFAULT_TEMPLATE`) → mitigated by keeping the same variable names; no behavioral change
- **[Source order]** Forgetting to source new files in `plugin.zsh` → mitigated by adding source lines as the final task
- **[Pipe overhead]** Using `$(...)` for communication adds a subshell fork → acceptable for interactive functions called once per session; no hot-path concern
