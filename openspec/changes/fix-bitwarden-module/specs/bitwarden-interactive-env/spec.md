# Bitwarden Interactive Vault Selection

## Purpose

Enable users to interactively select which Bitwarden vault to load from a predefined list of vault paths using fzf, providing quick access to different Bitwarden accounts and workspaces.

## Context

The Bitwarden module loads vault items using the Bitwarden CLI. Users may have multiple vaults across different organizations and personal accounts (e.g., `hadenlabs/clients/client1/env`, `me/env`, `codipe.pe/env`). This feature allows users to select which vault to use via an interactive fzf menu, rather than manually specifying vault paths.

## Requirements

### Functional Requirements

1. **Vault List Configuration**
   - The module MUST define `BITWARDEN_VARS_LIST` as an array variable containing vault paths
   - Default values MUST include all configured vault paths from the user's Bitwarden organization
   - Users MUST be able to modify this variable in their shell configuration

2. **Interactive Selection**
   - When `bw::load::env` is called and `BITWARDEN_VARS_LIST` contains multiple values, the function MUST present an fzf-based interactive selection menu
   - The menu MUST display all available vault paths from `BITWARDEN_VARS_LIST`
   - Users MUST be able to select one vault from the list
   - The selected vault MUST be loaded using `bw get item`

3. **Fallback Behavior**
   - If `BITWARDEN_VARS_LIST` is not set, the function MUST fall back to loading the entire `~/.bw_env` file (current behavior)
   - If `BITWARDEN_VARS_LIST` contains only one value, the function MUST load that vault directly without showing fzf
   - If `~/.bw_env` does not exist, the function MUST silently return without error

4. **Error Handling**
   - If the selected vault is not found in Bitwarden, the function MUST display a warning using `message_warning`
   - If fzf is not available, the function MUST fall back to loading the first vault in the list

### Non-Functional Requirements

1. **Performance**
   - The interactive selection MUST not add noticeable delay to shell operations
   - Fzf MUST be invoked with appropriate options for quick selection

2. **Compatibility**
   - The feature MUST work on both macOS and Linux
   - The feature MUST be backward compatible with existing configurations

3. **Usability**
   - The selection menu MUST be clear and easy to use
   - The selected vault MUST be visually distinct in the menu

## Technical Details

### Configuration

The `BITWARDEN_VARS_LIST` variable will be defined in `config/base.zsh`:

```zsh
# Bitwarden vault paths for interactive selection
BITWARDEN_VARS_LIST=(
    "hadenlabs/clients/alvaronm/env"
    "hadenlabs/clients/belcorp.biz/env"
    "me/env"
    "codipe.pe/env"
    # ... more vaults
)
```

### Implementation

The `bw::load::env` function in `internal/base.zsh` will be modified to:

1. Check if `BITWARDEN_VARS_LIST` is set and has multiple values
2. If yes, use fzf to present an interactive selection menu
3. Load the selected vault using `bw get item`
4. Extract the password and export it as `BW_SESSION`
5. If no, fall back to current behavior (load entire file or single vault)

### Fzf Integration

The fzf command will be invoked with:
- `--prompt "Select Bitwarden vault: "` for clear labeling
- `--height 40%` for appropriate menu size
- `--reverse` for top-down display
- Standard fzf options for consistent behavior

## Acceptance Criteria

1. When `BITWARDEN_VARS_LIST` is set with multiple values, calling `bw::load::env` shows an fzf selection menu
2. Selecting a vault from the menu loads that vault using `bw get item`
3. When `BITWARDEN_VARS_LIST` is not set, `bw::load::env` falls back to loading the entire `~/.bw_env` file
4. When `BITWARDEN_VARS_LIST` has one value, that vault is loaded directly without fzf
5. If the selected vault is not found in Bitwarden, a warning is displayed
6. The feature works correctly on both macOS and Linux
7. Existing functionality is preserved without regressions