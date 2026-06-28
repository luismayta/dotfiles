## Why

The mobile module still contains hardcoded values (version numbers, install paths) in implementation files (`internal/`) that should be configurable variables in `config/`. This follows the pattern established in the previous `sdkman-android-install` change, where `SDKMAN_INSTALL_URL` and `SDKMAN_JAVA_VERSION` were extracted from `internal/base.zsh` to `config/android.zsh`. Making these values configurable means they can be overridden without editing implementation code — important for CI environments, different Linux distributions, or future version bumps.

## What Changes

- Add `ANDROID_CMDLINE_TOOLS_VERSION` to `config/android.zsh` with `11076708` as default; use it in `internal/base.zsh` instead of the hardcoded URL string
- Add `SDKMAN_DIR` to `config/android.zsh` with `~/.sdkman` as default; use it in `internal/base.zsh` instead of the hardcoded path

## Capabilities

### New Capabilities
- `android-cmdline-tools-version`: Extract the Android cmdline-tools download version to a config variable so it can be bumped or overridden without touching implementation code
- `sdkman-path`: Extract the SDKMAN install directory to a config variable so it works with non-default SDKMAN locations

### Modified Capabilities
- (none)

## Impact

- `internal/base.zsh` — two hardcoded strings replaced with `$ANDROID_CMDLINE_TOOLS_VERSION` and `$SDKMAN_DIR`
- `config/android.zsh` — two new export lines added
- No breaking changes, no behavior change for existing users (defaults match current values)
