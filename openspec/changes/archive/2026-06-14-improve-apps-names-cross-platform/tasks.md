## 1. Restructure apps base config file header

- [x] 1.1 Add goenv-style file header to `zsh/modules/apps/config/base.zsh`: shebang, encoding comment, file description block with `File:` and `Description:` fields, shellcheck directive
- [x] 1.2 Add section header comments above each category (IDE Tools, JetBrains, Communication, etc.) matching goenv comment style
- [x] 1.3 Add inline comments to existing variables for clarity

## 2. Rename existing arrays to __DARWIN suffix

- [x] 2.1 Rename `APPS_IDE_TOOLS` to `APPS_IDE_TOOLS__DARWIN`, preserving current values `(tig meld)`
- [x] 2.2 Rename `APPS_JETBRAINS` to `APPS_JETBRAINS__DARWIN`, preserving `(jetbrains-toolbox intellij-idea-ce)`
- [x] 2.3 Rename `APPS_COMMUNICATION` to `APPS_COMMUNICATION__DARWIN`, preserving `(discord)`
- [x] 2.4 Rename `APPS_KNOWLEDGE` to `APPS_KNOWLEDGE__DARWIN`, preserving `(obsidian drawio)`
- [x] 2.5 Rename `APPS_DEVOPS` to `APPS_DEVOPS__DARWIN`, preserving `(multipass ngrok)`
- [x] 2.6 Rename `APPS_DATABASE_CLIENTS` to `APPS_DATABASE_CLIENTS__DARWIN`, preserving `(dbeaver-community beekeeper-studio redisinsight datagrip)`
- [x] 2.7 Rename `APPS_BROWSER` to `APPS_BROWSER__DARWIN`, preserving `(brave-browser)`
- [x] 2.8 Rename `APPS_ANDROID` to `APPS_ANDROID__DARWIN`, preserving `(android-studio android-platform-tools genymotion)`
- [x] 2.9 Rename `APPS_MOBILE` to `APPS_MOBILE__DARWIN`, preserving `(watchman fastlane)`
- [x] 2.10 Rename `APPS_VPN_CLIENTS` to `APPS_VPN_CLIENTS__DARWIN`, preserving `(openvpn wireguard wireguard-tools)`
- [x] 2.11 Rename `APPS_PROJECT_MANAGEMENT` to `APPS_PROJECT_MANAGEMENT__DARWIN`, preserving `(jira-cli)`
- [x] 2.12 Rename `APPS_WEB_APPS` to `APPS_WEB_APPS__DARWIN`, preserving `(pake)`

## 3. Add __LINUX variant arrays with Arch Linux package names

- [x] 3.1 Add `APPS_IDE_TOOLS__LINUX=(tig meld)` (same names on Arch — official extra repo)
- [x] 3.2 Add `APPS_JETBRAINS__LINUX=(jetbrains-toolbox intellij-idea-community-edition)` (AUR + official)
- [x] 3.3 Add `APPS_COMMUNICATION__LINUX=(discord)` (AUR)
- [x] 3.4 Add `APPS_KNOWLEDGE__LINUX=(obsidian-bin drawio-desktop)` (AUR + official extra)
- [x] 3.5 Add `APPS_DEVOPS__LINUX=(canonical-multipass ngrok)` (both AUR)
- [x] 3.6 Add `APPS_DATABASE_CLIENTS__LINUX=(dbeaver beekeeper-studio-bin redisinsight-bin datagrip)` (official + AUR)
- [x] 3.7 Add `APPS_BROWSER__LINUX=(brave-bin)` (AUR)
- [x] 3.8 Add `APPS_ANDROID__LINUX=(android-studio android-platform-tools genymotion)` (all AUR)
- [x] 3.9 Add `APPS_MOBILE__LINUX=(watchman-bin)` (AUR; fastlane is a Ruby gem, no system package)
- [x] 3.10 Add `APPS_VPN_CLIENTS__LINUX=(openvpn wireguard-tools)` (both official extra; wireguard is same as wireguard-tools)
- [x] 3.11 Add `APPS_PROJECT_MANAGEMENT__LINUX=(jira-cli)` (AUR)
- [x] 3.12 Add `APPS_WEB_APPS__LINUX=()` (pake uses `core::cargo::install pake`, no Arch package — installed via rust module)

## 4. Add OS resolution block

- [x] 4.1 Add resolution block at end of base.zsh: `if [[ $OSTYPE =~ ^darwin ]]` → resolve from `__DARWIN` arrays; `elif [[ $OSTYPE =~ ^linux ]]` → resolve from `__LINUX` arrays; else → fallback to `__DARWIN`
- [x] 4.2 Ensure APPS_PACKAGES references the resolved (non-suffixed) APPS_<CATEGORY> arrays

## 5. Populate Linux OS-specific config

- [x] 5.1 Populate `config/linux.zsh` with any Linux-exclusive apps (currently none identified — keep as placeholder ready for future additions)
- [x] 5.2 Verify `config/osx.zsh` remains unchanged (already correct)

## 6. Verify backward compatibility

- [x] 6.1 Source `config/main.zsh` in zsh on macOS and verify all APPS_<CATEGORY> arrays and APPS_PACKAGES are correct
- [x] 6.2 Verify all existing macOS app names are preserved exactly
- [x] 6.3 Run shellcheck on all modified .zsh files
