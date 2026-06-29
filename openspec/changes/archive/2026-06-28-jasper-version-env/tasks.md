## 1. Mobile — Flutter Version Override

- [x] 1.1 Update `zsh/modules/mobile/config/flutter.zsh` to use `JASPER_FLUTTER_VERSION` override pattern
- [x] 1.2 Verify `flutter::load` and `flutter::install` still work with both default and overridden version

## 2. Mobile — Android SDK Version Override

- [x] 2.1 Update `zsh/modules/mobile/config/android.zsh` to use `JASPER_ANDROID_PLATFORM_VERSION` override
- [x] 2.2 Update `zsh/modules/mobile/config/android.zsh` to use `JASPER_ANDROID_SDK_VERSION` override
- [x] 2.3 Update `zsh/modules/mobile/config/android.zsh` to use `JASPER_ANDROID_CMDLINE_TOOLS_VERSION` override

## 3. Mobile — SDKMAN Java Version Override

- [x] 3.1 Update `zsh/modules/mobile/config/android.zsh` to use `JASPER_SDKMAN_JAVA_VERSION` override

## 4. fnm — Version Override

- [x] 4.1 Update `zsh/modules/fnm/config/base.zsh` to use `JASPER_FNM_VERSION` override pattern

## 5. Core — Android Version Override

- [x] 5.1 Update `zsh/core/config/env.zsh` to use `JASPER_ANDROID_PLATFORM_VERSION` override
- [x] 5.2 Update `zsh/core/config/env.zsh` to use `JASPER_ANDROID_SDK_VERSION` override

## 6. Verification

- [x] 6.1 Source all modified config files and confirm no errors
- [x] 6.2 Test that `JASPER_*` override variable changes the resolved version
- [x] 6.3 Test that omitting `JASPER_*` uses the default version
