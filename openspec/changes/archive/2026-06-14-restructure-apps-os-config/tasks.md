## 1. Rewrite base.zsh — keep cross-OS apps, remove OS-specific data

- [x] 1.1 Remove all `APPS_<CATEGORY>__DARWIN` and `APPS_<CATEGORY>__LINUX` suffixed arrays from `zsh/modules/apps/config/base.zsh`
- [x] 1.2 Remove the OSTYPE resolution block (suffix selector + nameref loop + unset) from `zsh/modules/apps/config/base.zsh`
- [x] 1.3 Define bare `APPS_<CATEGORY>` arrays in `base.zsh` for categories with identical package names on both OS: `APPS_IDE_TOOLS`, `APPS_COMMUNICATION`, `APPS_ANDROID`, `APPS_VPN_CLIENTS`, `APPS_PROJECT_MANAGEMENT`
- [x] 1.4 Define empty `APPS_<CATEGORY` arrays in `base.zsh` for categories that are OS-specific (JETBRAINS, KNOWLEDGE, DEVOPS, DATABASE_CLIENTS, BROWSER, MOBILE, WEB_APPS) — to be populated by OS files
- [x] 1.5 Remove `APPS_PACKAGES` from `base.zsh` (will move to `main.zsh`)

## 2. Populate osx.zsh with macOS-specific category arrays

- [x] 2.1 Define macOS-specific `APPS_<CATEGORY>` arrays in `zsh/modules/apps/config/osx.zsh` with brew/brew-cask package names (JETBRAINS, KNOWLEDGE, DEVOPS, DATABASE_CLIENTS, BROWSER, MOBILE, WEB_APPS)
- [x] 2.2 Migrate exclusive macOS apps (raycast, unite, orbstack, comet, tunnelblick) from `_OSX` suffix pattern to `APPS_<CATEGORY>+=()` inline append pattern
- [x] 2.3 Remove the `_OSX` suffix array pattern and the old `APPS_PACKAGES+=()` block from `osx.zsh`

## 3. Populate linux.zsh with Linux-specific category arrays

- [x] 3.1 Define Linux-specific `APPS_<CATEGORY>` arrays in `zsh/modules/apps/config/linux.zsh` with Arch package names (JETBRAINS, KNOWLEDGE, DEVOPS, DATABASE_CLIENTS, BROWSER, MOBILE, WEB_APPS)

## 4. Move APPS_PACKAGES to main.zsh

- [x] 4.1 Add `APPS_PACKAGES` aggregate definition at the end of `zsh/modules/apps/config/main.zsh`, sourcing both base.zsh and the OS file before constructing the aggregate list
- [x] 4.2 Export `APPS_PACKAGES` in `main.zsh`

## 5. Verify

- [x] 5.1 Run `shellcheck` on all four config files (base.zsh, osx.zsh, linux.zsh, main.zsh) — zero new warnings
- [x] 5.2 Run `task validate` to confirm all pre-commit hooks pass
