## 1. Module Scaffold

- [ ] 1.1 Create `zsh/modules/hyprland/` directory structure (config/, data/, internal/, pkg/)
- [ ] 1.2 Create `plugin.zsh` entry point with idempotency guard, module path, and OS dispatch
- [ ] 1.3 Add Hyprland module reference to `.zshrc` module loader if needed

## 2. Config Layer (Paths & Variables)

- [ ] 2.1 Create `config/base.zsh` with `HYPRLAND_PATH`, `HYPRLAND_CONFIG_DIR`, `HYPRLAND_PACKAGE_NAME` variables
- [ ] 2.2 Create `config/main.zsh` with OS dispatcher (sources base + OS-specific, linux only)
- [ ] 2.3 Create `config/linux.zsh` with Linux-specific paths
- [ ] 2.4 Create `config/osx.zsh` stub (no-op for non-Linux)

## 3. Hyprland Lua Configs (data/)

- [ ] 3.1 Create `data/hypr/hyprland.lua` — main entry with `hl.config()` core settings, startup events, and `require()` includes for all sub-modules
- [ ] 3.2 Create `data/hypr/hypr-binds.lua` — keybindings (launchers, window management, workspace nav, media keys, screenshots, mouse binds, touchpad gestures)
- [ ] 3.3 Create `data/hypr/hypr-binds-user.lua` — empty user overrides file with documentation header
- [ ] 3.4 Create `data/hypr/hypr-windowrules.lua` — window rules (float, tile, layer, no-anim, pin)
- [ ] 3.5 Create `data/hypr/hypr-layout.lua` — layout defaults (gaps, border, rounding, dwindle/master settings)
- [ ] 3.6 Create `data/hypr/hypr-colors.lua` — Catppuccin Mocha theme colors (borders, group colors, groupbar)
- [ ] 3.7 Create `data/hypr/hypr-outputs.lua` — default monitor configuration
- [ ] 3.8 Create `data/hypr/hypr-cursor.lua` — cursor theme settings

## 4. Internal Layer (Install Functions)

- [ ] 4.1 Create `internal/base.zsh` with `hyprland::internal::hyprland::install` for Hyprland compositor
- [ ] 4.2 Add ecosystem package installers (`hypridle`, `hyprlock`, `hyprpaper`, `waybar`, `dunst`)
- [ ] 4.3 Create `internal/main.zsh` with OS dispatcher
- [ ] 4.4 Create `internal/linux.zsh` with Linux-specific install logic
- [ ] 4.5 Create `internal/osx.zsh` — macOS stub (no-op)

## 5. Public API Layer (pkg/)

- [ ] 5.1 Create `pkg/base.zsh` with `hyprland::install`, `hyprland::post_install`, `hyprland::sync` public API
- [ ] 5.2 Create `pkg/main.zsh` with OS dispatcher + helper and alias sources
- [ ] 5.3 Create `pkg/helper.zsh` with `edithypr`, session management, wallpaper helpers
- [ ] 5.4 Create `pkg/alias.zsh` with convenient aliases
- [ ] 5.5 Create `pkg/linux.zsh` — Linux-specific dispatch
- [ ] 5.6 Create `pkg/osx.zsh` — macOS stub (no-op)

## 6. Verification

- [ ] 6.1 Run `lsp_diagnostics` on all created zsh files
- [ ] 6.2 Verify module structure follows the `data/` → `~/.config/` sync pattern
- [ ] 6.3 Verify Hyprland Lua config syntax (`hl.*` API calls match Hyprland 0.55+ spec)
- [ ] 6.4 Load module in zsh and validate no errors on both Linux and macOS