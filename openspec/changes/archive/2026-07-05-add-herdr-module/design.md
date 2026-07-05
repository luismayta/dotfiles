## Context

The dotfiles project already manages tmux (a general-purpose terminal multiplexer) through a zsh module with the standard 3-layer architecture. **herdr** is a complementary tool — a terminal multiplexer built specifically for AI coding agents. It provides agent-aware state visibility (blocked/working/done/idle), persistent sessions that survive disconnection, and a plugin system.

This module follows the exact same conventions established by `zsh/modules/tmux/` and `zsh/modules/zed/`, documented in `docs/guides/create-module.md`. No new architectural patterns are needed — the existing module scaffold is a proven fit.

## Goals / Non-Goals

**Goals:**
- Auto-install herdr on first module load (via official install script, with Brew fallback)
- Sync herdr configuration files from `data/` to `$HOME/.config/herdr/`
- Provide user-callable commands: `herdr::install`, `herdr::sync`, `herdr::setup`
- Follow the exact 3-layer architecture (config/internal/pkg) used by all existing modules
- Support both Linux and macOS with OS-specific stubs

**Non-Goals:**
- Not creating tmuxinator-like project launchers (herdr has workspaces natively)
- Not managing herdr plugins or integrations (future concern)
- Not reimplementing herdr's socket API or CLI wrappers
- Not modifying existing modules or shared core infrastructure

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Primary install method | `curl -fsSL https://herdr.dev/install.sh \| sh` | Matches herdr's recommended approach. Same pattern as `zed` module. |
| Fallback install method | `brew install herdr` | Available on macOS; some users prefer package managers. Adds resilience. |
| Config path | `$HOME/.config/herdr/` | herdr's default config location. Consistent with `XDG_CONFIG_HOME`. |
| Config source | `ZSH_HERDR_DATA_PATH` | Config files live in `data/` and are rsynced to `$HOME/.config/herdr/` — same pattern as tmux. |
| Module name | `herdr` | Matches the tool's binary name. Consistent naming with `tmux`, `zed`. |
| OS dispatch | Full stubs in all 3 layers | Even if empty, makes platform contract explicit. Follows the guide. |
| No adapter pattern needed | Single provider | herdr has only one backend — no need for the `adapter/` subdirectory pattern. |
| Data directory | `data/` holds herdr config | Populated from `~/Projects/src/github.com/Sin-cy/dotfiles/herdr/.config/herdr/`. |

### Install strategy

The internal install function uses a two-tier approach:
1. **Primary**: Run the official install script via curl
2. **Fallback** (macOS): Try `brew install herdr` if the script fails

After install, `core::ensure herdr` verifies the binary is in `$PATH`.

### Sync strategy

Follows the same `rsync` pattern as `tmux::sync`:
```zsh
rsync -avzh "${ZSH_HERDR_DATA_PATH}/" "${HERDR_CONFIG_PATH}/"
```

`data/` is populated from the external config source at module creation time — files live in the repo and are synced on demand.

## Risks / Trade-offs

- **Install script availability**: The `herdr.dev` domain or install script URL could change. Mitigation: Brew fallback on macOS provides a secondary path.
- **Config drift**: If herdr config changes in the external repo (Sin-cy/dotfiles), `data/` in this repo may lag. Mitigation: re-copy and commit `data/` when needed.
- **Competing with tmux**: herdr is complementary, not a replacement. Tmux handles general terminal multiplexing; herdr is specialized for AI agents. Both modules coexist without conflict.
