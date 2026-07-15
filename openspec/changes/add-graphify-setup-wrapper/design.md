## Context

The AI module (`zsh/modules/ai/`) follows a 3-tier architecture: config → internal → pkg. Graphify already has full support with install, upgrade, and register_skill functions. The existing `ai::internal::graphify::register_skill` runs `graphify install --platform opencode` (without `--project`). Users need a separate callable function for project-scoped registration.

## Goals / Non-Goals

**Goals:**
- Add `ai::graphify::setup` as a public wrapper for `graphify install --platform opencode --project`
- Follow existing naming conventions (`ai::<tool>::<action>`)
- Make it idempotent (safe to call multiple times)
- Provide success/error feedback via `message_info`/`message_success`/`message_error`

**Non-Goals:**
- Modify existing `ai::graphify::install` or `ai::internal::graphify::register_skill`
- Add new config variables (uses existing `graphify` binary)
- Add aliases (function is the primary interface)

## Decisions

### Decision 1: Separate function vs. parameterizing register_skill

**Choice**: Create a new `ai::graphify::setup` function (not modify `register_skill`).

**Rationale**: `register_skill` is called during install as a post-hook. Adding `--project` logic there would change install behavior. A separate function keeps concerns isolated and follows the existing pattern where each user-facing action has its own function.

**Alternative considered**: Add a `--project` flag to `register_skill`. Rejected because it would couple install-time behavior with on-demand project setup.

### Decision 2: Internal implementation location

**Choice**: Add `ai::internal::graphify::setup` in `internal/base.zsh` alongside other graphify functions.

**Rationale**: All graphify internal functions live in `internal/base.zsh`. Keeping them together maintains consistency and discoverability.

### Decision 3: Error handling

**Choice**: Check if `graphify` binary exists before executing, report error if missing.

**Rationale**: Follows the same guard pattern used by `ai::internal::graphify::install` — fail gracefully with a clear message rather than a raw command-not-found error.

## Risks / Trade-offs

- **[Risk] Binary not installed** → Mitigated by checking `core::exists graphify` before execution
- **[Risk] Network failure during skill registration** → Graphify handles this internally; our wrapper just reports the exit code
- **[Trade-off] No force/reinstall option** → Acceptable because `graphify install --platform opencode --project` is inherently idempotent
