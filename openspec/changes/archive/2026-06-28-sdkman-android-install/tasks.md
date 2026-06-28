## 1. SDKMAN + Java Provisioning

- [ ] 1.1 Add SDKMAN auto-install at top of `mobile::internal::android::install`: check if `sdk` exists, if not run `curl -s "https://get.sdkman.io?rcupdate=false" | bash`, then source `"${HOME}/.sdkman/bin/sdkman-init.sh"`
- [ ] 1.2 Replace brew OpenJDK 11/17/21 block with SDKMAN Java 17 install: `sdk install java 17.0.13-tem && sdk default java 17.0.13-tem`, guarded by `java -version &>/dev/null`
- [ ] 1.3 Remove `core::ensure openjdk@11`, `core::ensure openjdk@17`, `core::ensure openjdk@21` lines

## 2. Cross-Platform cmdline-tools + sdkmanager

- [ ] 2.1 Add Linux download path in `mobile::internal::android::install`: detect Linux, download `commandlinetools-linux-*_latest.zip` from `dl.google.com/android/repository/`, extract to `"${ANDROID_HOME}/cmdline-tools/"`, rename folder to `latest`
- [ ] 2.2 Keep macOS brew path for `android-commandlinetools` (existing logic)
- [ ] 2.3 Remove `2>/dev/null || true` suppression from all sdkmanager calls so errors surface
- [ ] 2.4 Populate `zsh/modules/mobile/internal/linux.zsh` with Android-specific Linux install logic (sourcing the cross-platform code from `internal/base.zsh` — the function is already platform-aware via OSTYPE checks)

## 3. Extend android::load PATH

- [ ] 3.1 In `mobile::internal::android::load`, add `cmdline-tools/latest/bin` to PATH if directory exists
- [ ] 3.2 Add `build-tools/${ANDROID_SDK_VERSION}` to PATH if directory exists
- [ ] 3.3 Add `emulator` to PATH if directory exists

## 4. Flutter post_install Cross-Platform

- [ ] 4.1 In `mobile::internal::flutter::post_install`, remove the `case darwin*` guard so `flutter config --android-sdk` and `flutter doctor --android-licenses` run on Linux too

## 5. Verify

- [ ] 5.1 Run `zsh -n zsh/modules/mobile/internal/base.zsh` to validate syntax
- [ ] 5.2 Run `zsh -n zsh/modules/mobile/internal/flutter.zsh` to validate syntax
- [ ] 5.3 Run `zsh -n zsh/modules/mobile/internal/linux.zsh` to validate syntax
- [ ] 5.4 Run `zsh -n zsh/modules/mobile/plugin.zsh` to validate syntax (module entry point)
