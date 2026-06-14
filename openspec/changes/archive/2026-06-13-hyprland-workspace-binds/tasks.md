## 1. Setup: Create modular bind directory

- [ ] 1.1 Create `zsh/modules/hyprland/data/hypr/configs/binds/` directory
- [ ] 1.2 Read current `configs/binds.lua` to inventory all binds for migration

## 2. Extract window management binds → `window.lua`

- [ ] 2.1 Create `configs/binds/window.lua` with focus navigation binds (HJKL with SUPER, SHIFT, CTRL variants)
- [ ] 2.2 Add window action binds (Close/Q, Center/C, Float/T, Fullscreen/F)
- [ ] 2.3 Add mouse drag/resize binds (mouse:272, mouse:273)
- [ ] 2.4 Add resize binds (equal/minus with by_layout, SHIFT + equal/minus)
- [ ] 2.5 Add group management binds (W, BracketLeft, BracketRight)
- [ ] 2.6 Add multimedia keys section (XF86Audio*, XF86MonBrightness*)
- [ ] 2.7 Return bind registration function from module

## 3. Extract layout management binds → `layout.lua`

- [ ] 3.1 Create `configs/binds/layout.lua` with togglesplit bind (SUPER + R)
- [ ] 3.2 Add layout cycle binds (Backslash, SHIFT + Backslash) using custom.dsp
- [ ] 3.3 Return bind registration function from module

## 4. Create declarative app launcher → `apps.lua`

- [ ] 4.1 Create `configs/binds/apps.lua` with three-tier modifier tables (hyper, secondary, tertiary)
- [ ] 4.2 Add Hyper tier app entries: Android Studio ([), IntelliJ IDEA (]), Zed (;), Bitwarden (B), draw.io (D), Ghostty (T), Insomnia (I), DataGrip (S), Keybase (K), Jira (J), Obsidian (O), Zoom (Z)
- [ ] 4.3 Add Secondary tier app entries: Zen (A), Comet (C), Discord (D), Figma (F), WhatsApp (H), Telegram (T), Spotify/Music (M), Dolphin (O)
- [ ] 4.4 Add Tertiary tier entries: screenshot (P), screenshot full (CTRL+P), clipboard (V)
- [ ] 4.5 Migrate existing app binds to new apps: Ghostty (RETURN), Ghostty float (SHIFT+RETURN), Zen browser (B), Dolphin (E)
- [ ] 4.6 Add bind registration loop that reads the declarative table and calls hl.bind() for each entry
- [ ] 4.7 Add mnemonic mapping documentation comment block

## 5. Extract workspace + DMS IPC binds → `workspace.lua`

- [ ] 5.1 Create `configs/binds/workspace.lua` with workspace focus/move binds (SUPER + 1-9, SHIFT + 1-9)
- [ ] 5.2 Add scratchpad binds (SUPER + S, SHIFT + S)
- [ ] 5.3 Add DMS IPC binds table (lock, processlist, notifications, notepad, overview, clipboard, powermenu, wallpaper, settings, spotlight, screenshot variants)
- [ ] 5.4 Add workspace profile definitions table (developer, research, speaker) mirroring Hammerspoon config
- [ ] 5.5 Implement `dispatch_profile(name)` function
- [ ] 5.6 Add profile switch hotkey (SUPER + ALT + CTRL + W) that cycles profiles
- [ ] 5.7 Add auto-dispatch of default "developer" profile on module load
- [ ] 5.8 Return bind registration function from module

## 6. Refactor `binds.lua` → orchestrator

- [ ] 6.1 Rewrite `configs/binds.lua` as orchestrator that sets mainMod and requires sub-modules in order (layout → workspace → window → apps)
- [ ] 6.2 Remove all inline bind definitions (now in sub-modules)
- [ ] 6.3 Verify `require("configs.binds")` from `hyprland.lua` continues to work unchanged

## 7. Verification

- [ ] 7.1 Run `task validate` to ensure pre-commit hooks pass
- [ ] 7.2 Verify Lua syntax of all new modules with `luac -p` or similar
- [ ] 7.3 Run `hyprland::sync` to rsync data to ~/.config/hypr/
- [ ] 7.4 Test that Hyprland loads without errors (hyprctl reload)
- [ ] 7.5 Verify each bind category works: window mgmt, layout, app launch, workspace, DMS IPC, multimedia
