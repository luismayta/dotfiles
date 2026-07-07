## Why

The SSH module (`zsh/modules/ssh/`) duplicates functionality already provided by `zsh/core/`: manual clipboard dispatch with OS-specific tool detection, raw `if ! exists; then install; fi` guards instead of `core::ensure`, and a manual `cp` backup pattern instead of the shared `backup` utility. There's also a leftover `less` dependency guard that is dead code since the `ssh::list` fix replaced `less | grep` with file redirection.

Consolidating on core APIs reduces duplication, makes the module easier to maintain, and ensures consistent behavior across all modules.

## What Changes

1. **`ssh::connect` — Use `pbcopy` from core**: Replace the `case OSTYPE` block with `wl-copy`/`xclip` fallback by calling `pbcopy`, which `core/pkg/linux.zsh` already defines as a cross-platform clipboard wrapper (wl-copy → xclip → xsel), and is native on macOS. Eliminates ~15 lines of OS-specific clipboard logic.

2. **`internal/main.zsh` — Use `core::ensure`**: Replace 5 manual `if ! core::exists X; then core::install X; fi` blocks with the idiomatic `core::ensure X` pattern.

3. **`internal/main.zsh` — Remove `less` guard**: The `less` dependency guard is dead code since `ssh::list` no longer uses `less` (replaced with direct file redirection in the fix-ssh-module change). Remove it.

4. **`ssh::build` — Use `backup` from core**: Replace the manual `cp "${file}" "${file}.backup.$(date ...)"` pattern with the shared `backup` function from `core/internal/backup.zsh`, aligning with the dotfiles backup strategy.

No user-facing behavior changes — all refactoring is internal.

## Capabilities

### New Capabilities
*(none — purely internal refactoring, no new user-facing capabilities)*

### Modified Capabilities
*(none — no spec-level behavior changes)*

## Impact

- **`zsh/modules/ssh/internal/base.zsh`**: Lines 28–46 (`ssh::connect` clipboard dispatch) replaced by single `pbcopy` call; `ssh::build` backup logic simplified.
- **`zsh/modules/ssh/internal/main.zsh`**: 5 dependency guards replaced with `core::ensure`; `less` line removed.
- **Dependencies**: No new dependencies — `pbcopy` and `backup` are already loaded by core before the SSH module initializes.
- **Backward compatibility**: Full — clipboard behavior is identical on macOS (native `pbcopy`) and Linux (same fallback chain via core's `pbcopy` wrapper).
