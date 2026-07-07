## Why

The SSH module (`zsh/modules/ssh/`) has several bugs that prevent it from working correctly on Linux, uses unsafe defaults (MITM-vulnerable `StrictHostKeyChecking`), and contains dead code. The module fails silently — `ssh::connect` crashes on Linux, and `ssh::list` uses an unconventional `less` pipe that's fragile. These issues erode trust in the tooling and block Linux users from using SSH host selection via fzf.

## What Changes

- **Fix `ssh::list`** — Replace `less` pipe with direct file redirection (`<"${SSH_CONFIG_FILE}" grep ...`) for reliable host listing
- **Fix `ssh::connect`** — Add Linux support using `xclip`/`wl-copy` instead of macOS-only `pbcopy`/`ghead`
- **Fix `StrictHostKeyChecking`** — Change from `no` to `ask` (SSH default) to prevent MITM attacks
- **Remove dead code** — Delete unused `SSH_MESSAGE_NVM` variable
- **Clean up empty stubs** — Remove 9 empty scaffolding files that add noise with no value

## Capabilities

### New Capabilities

- `ssh-connect`: Cross-platform SSH host selection with clipboard copy via fzf (macOS + Linux)
- `ssh-list`: Reliable SSH host listing from `~/.ssh/config`
- `ssh-security`: Secure default SSH config with MITM protection

### Modified Capabilities

<!-- No existing specs to modify — this is a new module fix. -->

## Impact

- **Affected files**: `zsh/modules/ssh/internal/base.zsh`, `zsh/modules/ssh/data/assh.yml`, `zsh/modules/ssh/config/base.zsh`
- **Removed files**: 9 empty stub files across `config/`, `internal/`, and `pkg/` directories
- **New dependency**: `xclip` on Linux (already handled by `core::install` pattern)
- **Backward compatibility**: `ssh::connect` now works on Linux; behavior unchanged on macOS
