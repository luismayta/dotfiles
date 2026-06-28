## Why

The `zsh-core` module (hadenlabs/zsh-core) contains mobile development tooling — Android SDK installation via sdkmanager, iOS dependencies (CocoaPods, usbmuxd, libimobiledevice, ios-deploy) — that overlaps with or is absent from the `zsh/modules/mobile` module. Instead of maintaining parallel implementations, mobile-specific logic should live in the mobile module where it belongs, following the same `config → internal → pkg` architecture as every other module.

This review identifies what to port, what to enhance, and what to leave in place.

## What Changes

### New Capabilities

1. **iOS development tooling** — Port `core::internal::osx::dependences::install` from zsh-core into the mobile module as a proper `ios::setup` flow (CocoaPods, usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy). Currently the mobile module has no iOS support at all.

2. **Enhanced Android SDK installation** — Replace the current mobile module's simplistic `core::ensure android-studio android-platform-tools` with zsh-core's more robust sdkmanager-based approach (command-line tools, platform versions, build-tools, M2 repositories). Keep the existing load/alias logic.

### Improvements

3. **`mobile::setup` becomes comprehensive** — Chain iOS + Android setup so one call provisions the full mobile workstation.

### What stays in zsh-core (NOT ported)

- `core::install` / `core::exists` / message helpers — these are generic framework functions
- eza aliases, fzf functions, Docker wrappers, backup, git helpers — already in their respective modules or not mobile-specific
- `ip`, `localip`, `net`, `pubkey`, `download`, `agr` — general utilities, not mobile-related

## Capabilities

### New Capabilities

- `ios-tooling`: iOS development dependency management (CocoaPods, usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy). macOS-only capability that installs and configures the toolchain required for iOS development.
- `android-sdk-enhanced`: Upgraded Android SDK installation using sdkmanager instead of `core::ensure`, with configurable platform versions and full component set.

### Modified Capabilities

- _None._ Existing specs are not changing their requirements; this change adds new capabilities.

## Impact

### Affected files in `zsh/modules/mobile/`

| File | Change |
|---|---|
| `config/main.zsh` | Add `ios.zsh` source |
| `config/base.zsh` | Add iOS env vars (paths, versions) |
| `config/ios.zsh` | **New** — iOS tool paths and package list |
| `internal/main.zsh` | Add iOS auto-install block |
| `internal/base.zsh` | Enhance `android::install` with sdkmanager; add iOS internal functions |
| `internal/ios.zsh` | **New** — iOS install/load/upgrade internal implementation |
| `pkg/main.zsh` | Source new iOS public API |
| `pkg/base.zsh` | Add `ios::install`, `ios::load`, `ios::upgrade` |
| `pkg/ios.zsh` | **New** — iOS public API wrappers |
| `pkg/helper.zsh` | Add `ios::setup`, integrate into `mobile::setup` |

### Dependencies

- macOS (iOS tools only work on Darwin)
- `gem` (RubyGems) for CocoaPods
- `brew` for usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy
- `curl`, `unzip`, `java` (already required by mobile module)
- `sdkmanager` (Android command-line tools, already in zsh-core approach)
