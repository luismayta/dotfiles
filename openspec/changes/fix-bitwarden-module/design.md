## Context

The Bitwarden zsh module (`zsh/modules/bitwarden/`) provides shell functions for searching Bitwarden vault items and copying values to clipboard. The module follows a layered architecture: `config/` → `internal/` → `pkg/` → `keybindings.zsh`.

The core problem is that `bw::load::env` (defined in `pkg/helper.zsh`, implemented in `internal/base.zsh`) loads environment variables from `~/.bw_env` but is never called by any search function. This means required environment variables (like `BW_SESSION`) are not available when `bw list items` is invoked, causing silent failures due to `2>/dev/null` on all `bw` calls.

Additionally, users need the ability to select which specific environment variable to load from a predefined list, rather than loading the entire `~/.bw_env` file indiscriminately.

## Goals / Non-Goals

**Goals:**
- Ensure `bw::load::env` is automatically called before any Bitwarden CLI operation
- Surface authentication errors instead of silently swallowing them
- Remove unused dependencies and dead code
- Consolidate redundant helper functions
- Add interactive selection of Bitwarden environment variables via fzf

**Non-Goals:**
- Implementing automatic `bw login` or `bw unlock` flows
- Adding new search capabilities
- Changing the module's public API
- Implementing cross-platform specific logic (platform files remain placeholders)

## Decisions

### 1. Auto-load environment at function entry

**Decision:** Call `bw::load::env` at the start of `bw::search` and each `bw::search::*` function.

**Rationale:** This ensures environment variables are always available when needed without requiring users to manually call `bw::load::env` first. The function is idempotent (sources `~/.bw_env` only if it exists), so calling it multiple times is safe.

**Alternative considered:** Loading environment in `plugin.zsh` during module initialization. Rejected because: (a) `~/.bw_env` might not exist at load time, (b) the session might expire and need reloading, (c) per-operation loading is more resilient.

### 2. Surface errors with conditional redirection

**Decision:** Remove `2>/dev/null` from `bw list items` calls and instead check the exit code. If the command fails, display an error message using `message_warning` and return empty results.

**Rationale:** Silent failures make debugging impossible. Users see empty results and don't know why. By checking the exit code and displaying a warning, users get actionable feedback.

**Alternative considered:** Keep `2>/dev/null` but add a debug mode. Rejected because: (a) adds complexity, (b) users shouldn't need to enable debug mode to see basic errors.

### 3. Remove unused rsync dependency

**Decision:** Remove the `rsync` check from `internal/main.zsh`.

**Rationale:** No code in the module uses `rsync`. This is likely a copy-paste artifact from another module template. Removing it reduces unnecessary dependency checks during module load.

### 4. Consolidate helper functions

**Decision:** Remove duplicate `_get_type`, `_get_type_field`, and `_get_item_by_type` from `internal/helper.zsh`. The `bw::value::*` functions in `pkg/base.zsh` already provide this functionality via `jq`.

**Rationale:** Having two parallel implementations of the same logic is confusing and maintenance-heavy. The `bw::value::*` functions are the public API and should be the single source of truth.

### 5. Remove empty platform files

**Decision:** Delete empty placeholder files (`config/linux.zsh`, `config/osx.zsh`, `internal/linux.zsh`, `internal/osx.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh`).

**Rationale:** These files contain no logic and are never sourced with meaningful content. They add noise to the codebase. The OS dispatch in `main.zsh` files can be simplified to skip sourcing non-existent files.

### 6. Interactive vault selection

**Decision:** Add `BITWARDEN_VARS_LIST` variable and modify `bw::load::env` to use fzf for interactive selection of which vault to load.

**Rationale:** Users may have multiple Bitwarden vaults across different organizations and personal accounts (e.g., `hadenlabs/clients/client1/env`, `me/env`, `codipe.pe/env`). Rather than manually specifying vault paths, this allows users to select which vault they want to use via an interactive menu, providing quick access to different accounts.

**Implementation:**
- Define `BITWARDEN_VARS_LIST` in `config/base.zsh` with all configured vault paths
- Modify `bw::load::env` in `internal/base.zsh` to:
  1. Check if `BITWARDEN_VARS_LIST` is set
  2. If set and has multiple values, use fzf for interactive selection
  3. Load the selected vault using `bw get item`
  4. Extract password and export as `BW_SESSION`
  5. If `BITWARDEN_VARS_LIST` is not set or has one value, load that vault directly (fallback to current behavior)

**Alternative considered:** Always load all vaults. Rejected because: (a) users may have sensitive vaults they don't always want loaded, (b) some vaults might conflict with other tools, (c) interactive selection gives users explicit control.

## Risks / Trade-offs

- **Risk**: Users who have customized their module loading might be affected by removing platform files. **Mitigation**: The files are empty, so no functionality is lost. The OS dispatch still works if files don't exist.

- **Risk**: Removing `2>/dev/null` might expose error messages that users find noisy. **Mitigation**: Use `message_warning` which is non-blocking and provides useful feedback. Users who want silence can redirect stderr themselves.

- **Risk**: Consolidating helpers might break edge cases that the internal helpers handled. **Mitigation**: The `bw::value::*` functions are well-tested and cover all use cases. The internal helpers were just reimplementing the same logic.

- **Risk**: Adding fzf selection might slow down the env loading process. **Mitigation**: Fzf is already a dependency of the module and starts quickly. The selection is only shown when multiple vaults are available.

- **Risk**: The new interactive behavior might be unexpected for existing users. **Mitigation**: The fallback behavior (loading directly when only one vault is set) preserves backward compatibility. Users who want the old behavior can set `BITWARDEN_VARS_LIST` to a single value.

- **Risk**: Vault paths might change or become outdated. **Mitigation**: Users can easily update `BITWARDEN_VARS_LIST` in their shell configuration to add/remove vaults.

## Migration Plan

No migration needed. This is a backward-compatible fix. Users who were manually calling `bw::load::env` will see no change in behavior. Users who weren't calling it will now get automatic environment loading.

For the new interactive selection feature:
- If `BITWARDEN_VARS_LIST` is not set, the module falls back to loading the entire `~/.bw_env` file (current behavior)
- If `BITWARDEN_VARS_LIST` is set with one value, that vault is loaded directly
- If `BITWARDEN_VARS_LIST` is set with multiple values, fzf presents an interactive selection

## Open Questions

None. The design is straightforward and the decisions are clear.
