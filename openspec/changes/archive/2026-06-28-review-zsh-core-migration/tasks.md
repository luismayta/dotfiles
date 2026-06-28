## 1. Config Layer — iOS Tooling Configuration

- [x] 1.1 Create `config/ios.zsh` with `IOS_PACKAGE_NAME`, `APPS_IOS` array, and iOS tool paths
- [x] 1.2 Update `config/main.zsh` to source `ios.zsh` (behind OS guard or unconditionally)

## 2. Config Layer — Enhanced Android Configuration

- [x] 2.1 Add `ANDROID_PLATFORM_VERSION` (default: `35`) and `ANDROID_SDK_VERSION` (default: `35.0.1`) to `config/android.zsh`
- [x] 2.2 Add `ANDROID_FILE_REPOSITORIES` path export to `config/android.zsh`

## 3. Internal Layer — iOS Implementation

- [x] 3.1 Create `internal/ios.zsh` with `mobile::internal::ios::install` function (gem install cocoapods, brew install usbmuxd/libimobiledevice/ideviceinstaller/ios-deploy, pod setup)
- [x] 3.2 Add `mobile::internal::ios::load` function (CocoaPods PATH)
- [x] 3.3 Add `mobile::internal::ios::upgrade` function (stub with instructions)
- [x] 3.4 Update `internal/main.zsh` to source `ios.zsh` with macOS guard + Flutter heuristic auto-install

## 4. Internal Layer — Enhanced Android Implementation

- [x] 4.1 Update `mobile::internal::android::install` in `internal/base.zsh`: keep `core::ensure` for brew packages, add Java check + OpenJDK install, add sdkmanager setup + platform/build-tools/M2 repository installation

## 5. Public API Layer — iOS Functions

- [x] 5.1 Create `pkg/ios.zsh` with `ios::install`, `ios::load`, `ios::upgrade` public wrappers (delegate to `mobile::internal::ios::*`)
- [x] 5.2 Update `pkg/main.zsh` to source `ios.zsh` (behind macOS guard)
- [x] 5.3 Add `ios::setup` to `pkg/helper.zsh` (chains install → load → pod setup)
- [x] 5.4 Update `mobile::setup` in `pkg/helper.zsh` to include `ios::setup` on macOS

## 6. Verify

- [x] 6.1 Source the module: `source zsh/modules/mobile/plugin.zsh` — verify no errors
- [x] 6.2 Run `android::install` — verify sdkmanager installs platforms and build-tools
- [x] 6.3 Run `ios::setup` on macOS — verify iOS tools install
- [x] 6.4 Run `mobile::setup` — verify full chain works
- [x] 6.5 Verify `internal/main.zsh` auto-install behavior (with and without Flutter)
- [x] 6.6 Verify Linux safety — iOS auto-install is skipped, no errors
