## 1. MPD Zsh Module ✅

- [x] 1.1 Create `zsh/modules/mpd/` module structure (config, internal, pkg, data dirs)
- [x] 1.2 Create `zsh/modules/mpd/plugin.zsh` — entry point with idempotency guard
- [x] 1.3 Create `zsh/modules/mpd/config/base.zsh` — MPD_PACKAGE_NAME, MPD_MPC_PACKAGE_NAME, MPD_SOCKET_PATH
- [x] 1.4 Create `zsh/modules/mpd/config/main.zsh` — OS dispatch factory
- [x] 1.5 Create `zsh/modules/mpd/config/linux.zsh` — MPD_SERVICE_NAME for systemd
- [x] 1.6 Create `zsh/modules/mpd/config/osx.zsh` — MPD_SERVICE_NAME for brew
- [x] 1.7 Create `zsh/modules/mpd/internal/base.zsh` — mpd::internal::install (mpd + mpc via core::install)
- [x] 1.8 Create `zsh/modules/mpd/internal/main.zsh` — factory, OS dispatch, auto-install + auto-load
- [x] 1.9 Create `zsh/modules/mpd/internal/linux.zsh` — systemd user service (enable/start/stop/status)
- [x] 1.10 Create `zsh/modules/mpd/internal/osx.zsh` — brew services (start/stop/status)
- [x] 1.11 Create `zsh/modules/mpd/pkg/base.zsh` — public API (install, start, stop, status, play, pause, etc.)
- [x] 1.12 Create `zsh/modules/mpd/pkg/main.zsh` — factory with OS dispatch
- [x] 1.13 Create `zsh/modules/mpd/pkg/linux.zsh` — placeholder
- [x] 1.14 Create `zsh/modules/mpd/pkg/osx.zsh` — placeholder
- [x] 1.15 Create `zsh/modules/mpd/pkg/alias.zsh` — mp, mpplay, mppause, mpstop, mpnext, mpprev, mptoggle, mpvol, mpcurrent, mppl
- [x] 1.16 Create `zsh/modules/mpd/data/.gitkeep`

## 2. Waybar Base Configuration ✅

- [x] 2.1 Create `zsh/modules/waybar/data/config` with base waybar config (jsonc): bar position, height, modules-left/center/right arrays, standard modules (workspaces, clock, tray)
- [x] 2.2 Create `zsh/modules/waybar/data/style.css` with minimal styling (font, padding, colors, bar background)

## 3. Custom Module Framework ✅

- [x] 3.1 Create `zsh/modules/waybar/data/scripts/` directory
- [x] 3.2 Verify `waybar::internal::config::sync` rsync handles scripts/ subdirectory correctly (rsync -a preserves permissions)

## 4. MPD Module Scripts (Waybar Integration) ✅

- [x] 4.1 Create `data/scripts/mpd-waybar.sh` — scrolling song title with play/pause/stop icons, event-driven via `mpc idle`
- [x] 4.2 Create `data/scripts/is_in_playlist.sh` — heart icon showing favorite status, event-driven via `mpc idle`
- [x] 4.3 Create `data/scripts/mpd-heart-toggle.sh` — click handler to toggle song in/out of favorite playlist
- [x] 4.4 Ensure all MPD scripts are executable (chmod +x in the file or via post_install)

## 5. Wire MPD into Config ✅

- [x] 5.1 Add `custom/mpd` config block to waybar config (exec, tail, markup, on-click, on-scroll)
- [x] 5.2 Add `custom/is_in_playlist` config block to waybar config (exec, format, on-click)
- [x] 5.3 Add custom/mpd and custom/is_in_playlist to the bar layout (modules-right or modules-center)

## 6. Verification ✅

- [x] 6.1 Run `waybar::sync` and verify all files land in `~/.config/waybar/`
- [x] 6.2 Verify script permissions are correct after sync
- [x] 6.3 Start waybar and confirm base modules render (workspaces, clock, tray)
