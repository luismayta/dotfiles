## Context

The SSH module (`zsh/modules/ssh/`) was written before `zsh/core/` had matured its shared utility API. As a result, it contains hand-rolled equivalents of functions already provided by core:

- **Clipboard**: `ssh::connect` has a `case OSTYPE` block detecting `wl-copy`/`xclip` on Linux and `pbcopy` on macOS. Core's `pkg/linux.zsh` already defines a `pbcopy` function that wraps `wl-copy` → `xclip` → `xsel`, and macOS provides `pbcopy` natively.
- **Dependency guards**: `internal/main.zsh` uses 5 `if ! core::exists X; then core::install X; fi` blocks. Core provides `core::ensure` as the idiomatic one-liner.
- **Backup**: `ssh::build` manually backs up the SSH config with `cp "${file}" "${file}.backup.$(date ...)"`. Core provides a `backup` function that copies to `~/.backup/<date>/`.
- **Dead code**: A `less` dependency guard remains from before `ssh::list` was fixed to use file redirection instead of `less | grep`.

## Goals / Non-Goals

**Goals:**
- Replace SSH-internal clipboard dispatch with `pbcopy` from core
- Replace manual dependency guards with `core::ensure`
- Remove dead `less` dependency guard
- Use core's `backup` function for config backup in `ssh::build`
- Zero user-facing behavior changes

**Non-Goals:**
- No changes to the public API (`ssh::list`, `ssh::build`, `ssh::connect`, etc.)
- No changes to the assh.yml config or SSH_DATA_PATH contents
- No changes to module loading order or plugin.zsh
- Not converting the `core::exists`-based clipboard detection in `ssh::connect` (it can still use `core::exists` for `wl-copy`/`xclip` — but will be replaced by the single `pbcopy` call)

## Decisions

### Decision 1: Use `pbcopy` from core instead of manual OS dispatch

- **Choice**: Replace `case OSTYPE` in `ssh::connect` (lines 28–46 of `internal/base.zsh`) with `print -n "ssh ${buffer}" | pbcopy`
- **Rationale**: Core's `pkg/linux.zsh` already defines `pbcopy` as a cross-platform wrapper with the same fallback chain (`wl-copy` → `xclip` → `xsel`) plus an error message. macOS has native `pbcopy`. The SSH module was duplicating this logic.
- **Alternatives considered**:
  - Keep the manual dispatch: More code, maintenance burden, inconsistent with other modules that use `pbcopy` from core.
  - Detect `pbcopy` availability and fall back: Core guarantees `pbcopy` is available on Linux (it auto-installs `xclip` in `core/pkg/linux.zsh` line 6: `if ! core::exists xclip; then core::install xclip; fi`), so the guard is unnecessary.

### Decision 2: Use `core::ensure` for dependency guards

- **Choice**: Replace `if ! core::exists X; then core::install X; fi` with `core::ensure X` for curl, fzf, jq, assh in `internal/main.zsh`
- **Rationale**: `core::ensure` is defined as `core::exists "${1}" || core::install "${1}"` — identical behavior, less verbose.
- **Alternatives considered**: Keep as-is — not wrong, but inconsistent with the idiomatic core pattern used elsewhere.

### Decision 3: Remove `less` dependency guard

- **Choice**: Delete the `core::ensure less` line from `internal/main.zsh`
- **Rationale**: `less` was only needed by the old `ssh::list` implementation that piped through `less | grep`. The fix-ssh-module change replaced it with `< "$SSH_CONFIG_FILE" grep ...`, so `less` is no longer used by this module.
- **Risk**: `less` might still be referenced elsewhere in the dotfiles ecosystem. That's fine — `less` is a base system utility on both Linux and macOS, and removing the guard only affects the SSH module's dependency management.

### Decision 4: Use `backup` from core for config backup

- **Choice**: In `ssh::build`, replace the manual `cp` with `backup "${SSH_CONFIG_FILE}"` before overwriting
- **Rationale**: Core's `backup` function (in `internal/backup.zsh`) copies the file to `~/.backup/<date>/<filename>` with a timestamp, which is more organized than leaving `.backup.<timestamp>` files alongside the original.
- **Behavior difference**: Old: `~/.ssh/config.backup.20260706_120000`; New: `~/.backup/20260706/config`. This is more consistent with the dotfiles backup strategy and keeps `~/.ssh/` clean.
- **Alternatives considered**:
  - Keep manual `cp`: Works but clutters `~/.ssh/` with backup files.
  - Use `core::backup::snapshot`: Too heavy — that's a full rsync project backup, not what we need here.

## Risks / Trade-offs

- **[Backup location change]** The config backup will now go to `~/.backup/<date>/config` instead of `~/.ssh/config.backup.<timestamp>`. If a user relies on the old path, they won't find it. **Mitigation**: This is a minor internal detail; the backup timestamp is informational, and `~/.backup/` is the canonical dotfiles backup location used by the `backup` function across all modules.
- **[pbcopy availability]** `core/pkg/linux.zsh` defines `pbcopy` but it's loaded after core's `pkg/main.zsh` sources the OS dispatch. Since core loads before any module (core `main.zsh` is sourced early in `zshrc`), SSH always has `pbcopy` available. **Mitigation**: None needed — loading order guarantees availability.
- **[Backward compatibility]** Zero risk — all changes are internal to the module's private functions. The public API (`ssh::list`, `ssh::build`, `ssh::connect`, etc.) is unchanged.
