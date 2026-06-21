## Context

The `zsh/modules/nvim/` module follows a three-layer architecture:

```
plugin.zsh → config/main.zsh  (configuration variables)
           → internal/main.zsh (internal implementation)
           → pkg/main.zsh     (public API)
```

Each layer dispatches OS-specific variants via `case "${OSTYPE}"`. Currently:

- **`config/linux.zsh`** defines `NVIM_DATA_HOME`, `NVIM_CACHE_HOME`, `NVIM_STATE_HOME` using XDG base directories
- **`internal/linux.zsh`** defines the exact same three variables again — pure duplication
- **`internal/base.zsh`** (`nvim::internal::clean`) uses hardcoded paths `${HOME}/.local/share/nvim` etc. instead of the XDG variables
- **`pkg/linux.zsh`** defines `nvim::clean::xdg` which uses the XDG vars but with a non-standard name
- **`pkg/base.zsh`** defines `nvim::clean` which delegates to `nvim::internal::clean` (hardcoded paths)

This means the XDG variables are defined but not used by the primary clean function.

## Goals / Non-Goals

**Goals:**
- Eliminate the duplicated XDG variable definitions (config + internal layers)
- Make `nvim::clean` honor the XDG variables on all OSes
- Remove the oddly-named `nvim::clean::xdg` in favor of the standard `nvim::clean`
- Remove all dead dispatch files that become empty after consolidation

**Non-Goals:**
- Changing the public API signature of `nvim::clean`
- Adding new capabilities or features
- Changing how other nvim functions work (sync, install, upgrade)
- Porting changes to `data/` (Neovim Lua config) — only the zsh module

## Decisions

### 1. Remove `internal/linux.zsh` entirely
- **Rationale**: It only contained the three XDG export lines that are already in `config/linux.zsh`. The config layer is the correct place for variable definitions — the internal layer should contain logic, not configuration.
- **Alternative considered**: Keep both but deduplicate — adds complexity for no benefit.

### 2. Make `nvim::internal::clean` use XDG variables with fallback
- **Rationale**: Instead of hardcoded paths, use `$NVIM_DATA_HOME`, `$NVIM_CACHE_HOME`, `$NVIM_STATE_HOME`. These are set by the config layer on Linux. On macOS (where no XDG override exists), they fall back to the same default paths the function currently hardcodes.
- **Implementation**: Replace:
  ```zsh
  command rm -rf \
      "${HOME}/.local/share/nvim" \
      "${HOME}/.cache/nvim" \
      "${HOME}/.local/state/nvim"
  ```
  With:
  ```zsh
  : "${NVIM_DATA_HOME:=${HOME}/.local/share/nvim}"
  : "${NVIM_CACHE_HOME:=${HOME}/.cache/nvim}"
  : "${NVIM_STATE_HOME:=${HOME}/.local/state/nvim}"
  command rm -rf \
      "${NVIM_DATA_HOME}" \
      "${NVIM_CACHE_HOME}" \
      "${NVIM_STATE_HOME}"
  ```

### 3. Remove `pkg/linux.zsh` and `nvim::clean::xdg`
- **Rationale**: Once `nvim::clean` uses the XDG vars, `nvim::clean::xdg` becomes redundant. The standard `nvim::clean` does everything `nvim::clean::xdg` did.
- **Alternative considered**: Keep `nvim::clean::xdg` as a deprecated alias — unnecessary churn for no real migration need.

### 4. Remove Linux dispatch from `internal/main.zsh` and `pkg/main.zsh`
- **Rationale**: After removing `internal/linux.zsh` and `pkg/linux.zsh`, their corresponding `*) source ...` branches in `main.zsh` files have nothing to source. Remove the branches entirely.
- **Note**: The `darwin*` branches remain (`internal/osx.zsh` and `pkg/osx.zsh` still have content).

## Risks / Trade-offs

- **macOS fallback behavior**: macOS doesn't define `NVIM_DATA_HOME` etc. in its config layer. The `: "${VAR:=default}"` fallback in `internal/base.zsh` ensures the same paths are used as before. No risk.
- **Other consumers of `nvim::clean::xdg`**: If there are scripts elsewhere in the dotfiles that call `nvim::clean::xdg`, they would break. A search reveals no other references in the repository.
- **Custom `NVIM_*_HOME` overrides**: If a user has custom overrides set before the module loads, `: "${VAR:=default}"` respects existing values. No risk.
