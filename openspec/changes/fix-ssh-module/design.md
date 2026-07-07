## Context

The SSH module (`zsh/modules/ssh/`) provides SSH host management: listing hosts from `~/.ssh/config`, connecting via fzf, building config with `assh`, and syncing data. The module follows a layered **Config → Internal → Pkg → Keybindings** architecture but has accumulated defects:

1. `ssh::list` pipes SSH config through `less` — unconventional and fragile outside TTY
2. `ssh::connect` hardcodes macOS tools (`pbcopy`, `ghead`) — crashes on Linux  
3. `data/assh.yml` sets `StrictHostKeyChecking: no` — MITM-vulnerable
4. 9 of 17 files are empty stubs — noise with no value
5. `SSH_MESSAGE_NVM` is defined but never referenced

## Goals / Non-Goals

**Goals:**
- Cross-platform `ssh::connect` (macOS + Linux) with clipboard copy
- Reliable `ssh::list` using standard shell patterns
- Secure SSH config defaults (no global MITM vulnerability)
- Clean module with no dead code or empty scaffolding
- Backward compatible on macOS — no behavior change for existing users

**Non-Goals:**
- Rewriting the module architecture or `assh` integration
- Adding new features beyond fixing existing broken ones
- GUI or TUI improvements beyond the existing fzf workflow
- Spec-level changes to `ssh::upgrade`, `ssh::build`, or `ssh::sync`

## Decisions

### 1. Replace `less` pipe with direct file redirection in `ssh::list`
- **Problem**: `less "${SSH_CONFIG_FILE}" | grep ...` uses a pager as a reader — fragile in non-TTY, adds unnecessary dependency on `less`'s pipe behavior
- **Decision**: Use `<"${SSH_CONFIG_FILE}" grep -i '^host[[:space:]]*' | sed 's/^[Hh][Oo][Ss][Tt][[:space:]]*//'`
- **Rationale**: Direct redirection is the standard shell pattern — no pipe overhead, no pager behavior to worry about, same result

### 2. Cross-platform clipboard for `ssh::connect`
- **Problem**: `echo -e "ssh ${buffer}" | ghead -c -1 | pbcopy` is macOS-only
- **Decision**: Dispatch by OS:
  - macOS: `echo -n "ssh ${buffer}" | pbcopy` (use `echo -n` instead of `ghead -c -1`)
  - Linux: `echo -n "ssh ${buffer}" | xclip -selection clipboard`
  - Wayland fallback: `wl-copy` if `xclip` is unavailable
- **Rationale**: Standard shell patterns avoid GNU coreutils dependency. `pbcopy`/`xclip`/`wl-copy` are the platform-standard clipboard tools.

### 3. Change `StrictHostKeyChecking` to `ask`
- **Problem**: `no` disables host key verification globally — MITM vulnerability on every connection
- **Decision**: Change to `ask` (SSH default behavior — prompt on unknown host key)
- **Rationale**: `ask` is secure and user-friendly. Power users can override in `custom.yml`.

### 4. Remove empty stub files
- **Files to remove**:
  - `config/linux.zsh`, `config/osx.zsh`
  - `internal/helper.zsh`, `internal/linux.zsh`, `internal/osx.zsh`
  - `pkg/helper.zsh`, `pkg/linux.zsh`, `pkg/osx.zsh`
- **Rationale**: 9 empty files sourced conditionally but do nothing. They add cognitive load and file-count noise. Git history preserves them if needed later.

### 5. Remove dead variable `SSH_MESSAGE_NVM`
- **Problem**: Defined in `config/base.zsh`, never used anywhere in the module
- **Decision**: Remove the export line

## Risks / Trade-offs

- **`xclip` not installed** on some Linux systems → `core::install xclip` in internal/main.zsh (already follows the existing pattern for `curl`, `fzf`, `jq`, etc.)
- **Wayland users** may not have `xclip` → Add `wl-copy` detection and fallback in the connect function
- **Stub removal** could cause confusion if someone expects OS-dispatch files → The dispatch `case` statements will be removed too, so no sourcing errors; files can be recreated if platform-specific logic is ever needed
- **`echo -n`** may behave differently across shells → Use `print -n` for zsh-native approach instead, ensuring consistent behavior
