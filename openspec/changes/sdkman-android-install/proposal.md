## Why

The Android SDK installation in the mobile module has two blocking issues: (1) Java provisioning via Homebrew OpenJDK is broken (keg-only formula never exposes `java` in PATH) and only works on macOS, and (2) there is no Linux install path at all — `internal/linux.zsh` is empty. Switching to SDKMAN resolves the Java detection problem, works natively on both macOS and Linux, and simplifies the install to a single JDK version instead of three.

## What Changes

- Replace Homebrew OpenJDK 11/17/21 with SDKMAN-based Java 17 (Temurin) provisioning in `mobile::internal::android::install`
- Add SDKMAN auto-install (if missing) as a dependency step
- Add Linux cmdline-tools download path (Google direct) for `sdkmanager` installation
- Extend `android::load` to include `cmdline-tools/latest/bin`, `build-tools/`, and `emulator/` in PATH
- Move `flutter::post_install` Android SDK config out of macOS-only guard so Linux also runs `flutter config --android-sdk` and `flutter doctor --android-licenses`
- Remove error suppression (`2>/dev/null || true`) from sdkmanager calls so failures surface

## Capabilities

### New Capabilities
- `sdkman-java`: SDKMAN installation and Java 17 Temurin provisioning for Android SDK
- `cross-platform-android`: Linux Android SDK install via direct Google cmdline-tools download

### Modified Capabilities
- `android-install`: Java source changes from brew OpenJDK → SDKMAN; Linux path added; sdkmanager install split per-platform
- `android-load`: PATH extends beyond platform-tools to include cmdline-tools, build-tools, and emulator

## Impact

- `zsh/modules/mobile/internal/base.zsh`: `mobile::internal::android::install` and `mobile::internal::android::load` rewritten
- `zsh/modules/mobile/internal/linux.zsh`: populated with Android-specific Linux install logic
- `zsh/modules/mobile/internal/flutter.zsh`: `post_install` macOS guard removed for `flutter config --android-sdk` / licenses
- `zsh/modules/mobile/config/android.zsh`: no changes expected (env vars remain the same)
- `zsh/modules/mobile/pkg/base.zsh`, `pkg/helper.zsh`: no changes expected
- Dependencies: SDKMAN requires `curl`, `unzip`, `zip` (already ensured by `core::ensure`)
