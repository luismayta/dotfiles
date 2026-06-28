## Context

The `zsh/modules/mobile` module follows the standard three-layer architecture (`config` → `internal` → `pkg`) used by all 33 modules in the dotfiles zsh framework. It currently manages Android SDK and Flutter SDK installation/loading but has no iOS tooling support and its Android setup uses a simplistic `core::ensure` approach.

The external `zsh-core` module (hadenlabs/zsh-core) contains a more thorough Android SDK installation (via sdkmanager with platform versions, build-tools, M2 repositories) and a complete iOS dependencies installer (CocoaPods, usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy). These are mobile-specific capabilities that belong in the mobile module.

The existing `devops` module provides a reference pattern for how multi-tool modules are organized — each tool gets its own file in `internal/` and `pkg/`, with a corresponding config file.

## Goals / Non-Goals

**Goals:**
- Port iOS development tooling (CocoaPods, usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy) from zsh-core into the mobile module as a first-class capability
- Enhance the Android SDK installation to use sdkmanager with configurable platform versions (matching zsh-core's thoroughness)
- Follow the exact same architectural patterns as every other module (config → internal → pkg, OS-specific files, auto-install on load)
- Make `mobile::setup` a comprehensive one-call provisioning for mobile development

**Non-Goals:**
- NOT porting general-purpose utilities from zsh-core (fzf functions, eza aliases, Docker wrappers, backup, git helpers, message utils)
- NOT changing the Flutter management logic (already complete)
- NOT adding iOS tooling to non-macOS platforms (Linux/Windows cannot develop iOS)
- NOT modifying the core framework (`zsh/core/` module) or any other module

## Decisions

### Decision 1: iOS gets its own file set (not merged into base.zsh)

**Choice**: Create `config/ios.zsh`, `internal/ios.zsh`, `pkg/ios.zsh` — following the pattern set by `devops/k9s.zsh` and `devops/kubectl.zsh`.

**Rationale**: iOS tooling is a distinct concern from Android/Flutter. Keeping it in separate files aligns with the existing module convention (one file per tool) and makes it easy to maintain independently. The alternative — appending to `internal/base.zsh` — would bloat that file beyond its current focused scope.

### Decision 2: Android SDK install enhances, not replaces, existing approach

**Choice**: Modify `mobile::internal::android::install` to use sdkmanager for platform components (platforms, build-tools, M2 repos) while keeping the `core::ensure` approach for IDE packages (android-studio).

**Rationale**: The existing `core::ensure` works well for brew-installable GUI apps. The sdkmanager approach adds value for the SDK components (platforms, build-tools) that brew doesn't manage granularly. Hybrid approach gives best of both.

### Decision 3: Auto-install iOS tools only on macOS and only if Flutter is present

**Choice**: The `internal/main.zsh` auto-install block for iOS tools will:
1. Guard on `[[ "${OSTYPE}" == darwin* ]]`
2. Check if `flutter` is installed before auto-installing iOS tools
3. Also provide a manual `ios::setup` for explicit invocation

**Rationale**: iOS tooling is heavy (~500MB+ with CocoaPods) and only relevant for iOS development. Auto-installing unconditionally would penalize users who only do Android/Flutter. Checking for Flutter presence is a reasonable heuristic that the user intends iOS development.

### Decision 4: Follow existing config variable naming conventions

**Choice**: Use `IOS_*` prefixed environment variables matching the Android pattern:
- `IOS_PACKAGE_NAME=ios`
- `APPS_IOS=(cocoapods usbmuxd libimobiledevice ideviceinstaller ios-deploy)`
- `IOS_SETUP_ENABLED="${IOS_SETUP_ENABLED:-true}"`

**Rationale**: Consistency with `APPS_ANDROID`, `ANDROID_HOME`, `FLUTTER_PACKAGE_NAME`, etc. Users familiar with the module can predict variable names.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| **iOS tools change rapidly** (homebrew HEAD formulas) | Pin stable versions where possible; `ios::upgrade` function for explicit upgrades |
| **Android sdkmanager requires Java** | Keep the Java check from zsh-core; install OpenJDK if missing |
| **CocoaPods `pod setup` is slow** (clones CocoaPods Specs repo) | Run in background or skip auto; document as explicit step |
| **Parallel implementation in zsh-core** (zsh-core still has its own versions) | This change adds iOS to mobile; zsh-core remains as-is until deprecated |
| **Linux users get errors on iOS auto-install** | Guard all iOS logic behind `[[ "${OSTYPE}" == darwin* ]]` |

## Migration Plan

1. **Config layer**: Add `config/ios.zsh` with env vars + tool list; update `config/main.zsh` to source it
2. **Internal layer**: Add `internal/ios.zsh` with install/load/upgrade functions; update `internal/main.zsh` with macOS-guarded auto-install
3. **Public API**: Add `pkg/ios.zsh` with `ios::install`, `ios::load`, `ios::upgrade`, `ios::setup`; update `pkg/main.zsh` to source it
4. **Enhance Android**: Update `internal/base.zsh` android install function to use sdkmanager
5. **Update helpers**: Extend `pkg/helper.zsh` with `ios::setup` and update `mobile::setup` to chain iOS + Android
6. **Verify**: Source the module, run `mobile::setup`, verify each tool installs correctly

## Open Questions

1. Should `mobile::setup` auto-install iOS tools by default, or require explicit `ios::setup`? (Decision: manual for now — too heavy for auto)
2. Should we keep the zsh-core versions after porting, or deprecate them? (Decision: keep zsh-core as-is, no changes to that repo)
3. Linux equivalents for iOS tools? (None — iOS development requires macOS/Xcode)
