## Context

The bitwarden ZSH module currently has a complex `bitwarden::internal::load::env` function that:
1. Checks for `~/.bw_env` file and sources it if `BITWARDEN_VARS_LIST` is empty/single
2. Uses fzf to select from `BITWARDEN_VARS_LIST` when multiple entries exist
3. Manually calls `bw get item "$selected"` and extracts passwords with `jq`
4. Sets `BW_SESSION` export

The `env-secrets` CLI tool (already installed via goenv) handles all the vault item fetching and environment variable extraction. The current function duplicates this logic unnecessarily.

## Goals / Non-Goals

**Goals:**
- Simplify `bitwarden::internal::load::env` to use `env-secrets` delegation
- Maintain the fzf selection UX from `BITWARDEN_VARS_LIST`
- Preserve "do nothing if cancelled" behavior
- Remove `.bw_env` file dependency

**Non-Goals:**
- Changing the public API (`bw::load::env` wrapper)
- Modifying `BITWARDEN_VARS_LIST` configuration
- Changing the fzf selection interface or keybindings
- Updating `bw::search::*` functions (they call the wrapper)

## Decisions

### Decision 1: Delegate to `env-secrets` instead of manual `bw get item`

**Choice**: Use `eval "$(env-secrets bw ${selected})"` 

**Rationale**: 
- `env-secrets` is already installed and handles all the complexity of vault item fetching, password extraction, and environment variable parsing
- Removes ~30 lines of manual extraction logic
- Single source of truth for vault interaction

**Alternatives considered**:
- Keep manual extraction: Rejected — duplicates `env-secrets` functionality
- Create a new wrapper function: Rejected — unnecessary abstraction layer

### Decision 2: Remove `.bw_env` file handling

**Choice**: Remove the `.bw_env` file check entirely

**Rationale**:
- The `.bw_env` file is a legacy mechanism that predates `env-secrets`
- All vault items are now configured in `BITWARDEN_VARS_LIST`
- Simplifies the function to a single code path

**Alternatives considered**:
- Keep as fallback: Rejected — adds complexity for unused edge case

### Decision 3: Preserve fzf selection behavior

**Choice**: Keep the fzf prompt with `--height 40% --reverse`

**Rationale**:
- Users are familiar with this interface
- Maintains consistency with existing UX
- No reason to change working selection flow

## Risks / Trade-offs

### Risk 1: `env-secrets` CLI availability
- **Risk**: If `env-secrets` is not installed, function fails silently
- **Mitigation**: Add a check for `env-secrets` existence at function start, similar to existing `fzf` check

### Risk 2: Breaking change for `.bw_env` users
- **Risk**: Any user relying on `.bw_env` files will lose that functionality
- **Mitigation**: This is intentional — `.bw_env` is not used in the current configuration

### Risk 3: Command substitution performance
- **Risk**: `eval "$(env-secrets ...)"` adds a subprocess
- **Mitigation**: Acceptable trade-off for simplicity; env-secrets is fast
