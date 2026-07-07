## Context

The dotfiles repo has a modular ZSH architecture under `zsh/modules/` where each tool gets its own module following a strict 3-layer pattern: `config/` (env vars), `internal/` (private implementation), `pkg/` (public API). Each module auto-installs its tool if missing and syncs managed config from its `data/` directory.

Yazi is a modern Rust-based terminal file manager. It replaces traditional file managers like ranger, lf, or nnn. It's available in Arch repos (`pacman -S yazi`) and via cargo for other platforms. Its config lives at `~/.config/yazi/` with toml files.

## Goals / Non-Goals

**Goals:**
- Create a ZSH module for yazi following the same patterns as herdr, zed, and other modules
- Auto-install yazi on Arch via pacman, on other platforms via cargo
- Sync managed yazi configuration (yazi.toml, keymap.toml, theme.toml) from `data/` to `~/.config/yazi/`
- Provide `y()` function that enables `cd` on quit via `--cwd-file`
- Expose public API: `yazi::install`, `yazi::sync`, `yazi::setup`, `yazi::post_install`

**Non-Goals:**
- Installing optional yazi dependencies (fd, fzf, ripgrep, zoxide, ffmpeg, 7zip) — those are managed by other modules or the user
- Configuring yazi beyond syncing the managed config files
- Creating yazi themes or keymaps from scratch — just syncing what's in `data/`
- Modifying existing modules or core infrastructure

## Decisions

1. **Install via pacman on Arch, cargo on others** — Yazi is in the Arch extra repo (`pacman -S yazi`), which is the native path. On macOS (no native package via brew since yazi is in homebrew-core) and other Linux distros, fall back to `cargo install --locked yazi-fm yazi-cli`. This matches the pattern used by the rust/goenv modules.

2. **Config directory: `~/.config/yazi/`** — Standard location for yazi. The module will rsync from `data/` to this path, same as zed and herdr.

3. **`y()` wrapper with `--cwd-file`** — Yazi supports `--cwd-file` to write the last-browsed directory to a temp file on exit. The wrapper reads it and `cd`s if different from `$PWD`. This is the idiomatic yazi pattern recommended in its docs and matches the behavior users expect from a terminal file manager.

4. **No core::exists check for cargo** — `core::ensure` handles curl. For Rust-based installs we rely on the existing Rust module having setup cargo. If cargo isn't available, the install step will fail gracefully with a message.

5. **OS-specific clipboard config** — Yazi uses xclip/wl-clipboard on Linux and pbcopy/pbpaste on macOS for clipboard operations, following the same pattern as herdr's clipboard config.

## Risks / Trade-offs

- [Risk] **cargo install is slow** — Building yazi from source on first install can take several minutes on older hardware.
  → Mitigation: On Arch, pacman is near-instant. On non-Arch, consider adding a `cargo binstall` path in the future once it's more widely available.
- [Risk] **Config drift** — If the user modifies files in `~/.config/yazi/` directly and the module runs `yazi::sync`, their changes get overwritten.
  → Mitigation: The sync only runs when explicitly called (`yazi::sync` or `yazi::setup`), not automatically on shell start. This is the same pattern as zed and herdr.
- [Trade-off] **No auto-install of optional deps** — Yazi recommends fd, fzf, ripgrep, zoxide for best experience, but these are managed by other modules. Users need to ensure those are installed separately.
  → Rationale: Following the module system's separation of concerns. Each tool has its own module.
