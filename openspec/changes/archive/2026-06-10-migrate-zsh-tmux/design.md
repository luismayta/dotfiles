## Context

The `hadenlabs/zsh-tmux` plugin is currently loaded via antidote from `zsh/zsh_plugins.txt`. It provides tmux installation management, TPM (Tmux Plugin Manager) installation, tmuxinator setup, session management helpers, and OS-specific clipboard integration. The source at `/Users/luchomayta/projects/src/github.com/hadenlabs/zsh-tmux/` follows a config/internal/pkg 3-layer architecture with factory-function sourcing and OS dispatch (identical structural pattern to the already-migrated `zsh-rust` module).

The module ships config data in `data/conf/` (`.tmux.conf`) and `data/sync/` (OS-specific tmux confs, tmuxinator templates) that get rsynced to `$HOME/` and `$HOME/.config/` at install time.

The monorepo convention (established by `zsh/modules/core/`, `zsh/modules/brew/`, and `zsh/modules/rust/`) uses:
- `plugin.zsh` with idempotency guard → chains `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`
- Direct sourcing (no factory function wrappers)
- OS-specific files sourced via `case ${OSTYPE}` in `main.zsh` dispatchers
- All functions defined unconditionally (no conditional OS-only definitions)
- Auto-install side-effects in `pkg/base.zsh`
- Config data files stored under module root (e.g., `data/` directory)

Supported platforms: macOS (darwin), Linux (archlinux, cachyos, generic).

## Goals / Non-Goals

**Goals:**
- Port all `tmux::*` functions, `ftm`, `ftmk`, `tx::project`, `edittmux` into `zsh/modules/tmux/` preserving public API
- Port config data (`data/conf/`, `data/sync/`) into module's data directory
- Remove `hadenlabs/zsh-tmux` antidote bundle
- Match the canonical module file layout (~17 files including data)
- Ensure functions available on all platforms (macOS, Arch Linux, CachyOS)
- Pass `zsh -n` and `task validate`

**Non-Goals:**
- Rename functions or change public API
- Port docs, CI, or non-essential repo infrastructure
- Modify the external repo
- Change the tmux config file structure or content
- Refactor `tmux::dependences` (misspelling preserved for compatibility)

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Source chain pattern | Direct sourcing (rust/brew pattern) | Original uses factory functions (`tmux::config::main::factory`); monorepo convention removes wrapper layer for simplicity |
| Config data directory | `data/` under module root | Original uses `data/` at plugin root; preserved for consistency with rsync logic in `tmux::sync` |
| `TMUX_PATH` variable | Local to module | Replaces `ZSH_TMUX_PATH` from external plugin; computed as `$(dirname "${0}")` in `plugin.zsh` |
| `internal/` OS files | `osx.zsh` and `linux.zsh` | `linux.zsh` empty (install is generic via `core::install`); `osx.zsh` has `reattach-to-user-namespace` install check |
| `pkg/` OS files | Placeholder stubs | Original had empty OS-specific pkg files; preserved for future platform additions |
| `pkg/alias.zsh` | Keep with `tx=tmuxinator` alias | Original defines alias `tx` if `tmuxinator` exists; preserved as-is |
| `pkg/helper.zsh` | Port `edittmux`, `tx::project`, `ftm`, `ftmk` | These are the primary UX surface — session management, tmuxinator launcher, config editor |
| Auto-install side-effects | Move to `pkg/base.zsh` | Matches rust/brew convention where auto-install/load side-effects live in `pkg/base.zsh`, not `internal/main.zsh` |
| `config/linux.zsh` / `config/osx.zsh` | Empty placeholders | Original had empty config OS files; preserved for future platform-specific environment vars |
| `internal/linux.zsh` | Empty placeholder | Tmux install is platform-agnostic via `core::install tmux` |

## Risks / Trade-offs

- [Low] `core::exists fzf` call in `config/main.zsh` for auto-install — moved to `internal/main.zsh` or `pkg/base.zsh` to keep config layer pure (matching pattern)
- [Low] `tmux::sync` uses `rsync` with specific paths (`ZSH_TMUX_PATH/data/conf/` → `$HOME/`) — path must be updated to new module root
- [Low] The original `config/main.zsh` calls `core::exists fzf` and installs if missing — this side-effect moves to `internal/main.zsh` to keep config pure
- [Low] `tmux::dependences` function — misspelling preserved exactly to avoid breaking any callers