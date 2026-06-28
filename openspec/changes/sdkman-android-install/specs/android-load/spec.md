## ADDED Requirements

### Requirement: PATH extension for Android tools

The `android::load` function SHALL add all relevant Android SDK tool directories to PATH.

#### Scenario: All directories present
- **WHEN** `ANDROID_PLATFORM_TOOLS` is a directory
- **THEN** it is prepended to `PATH`
- **WHEN** `"${ANDROID_HOME}/cmdline-tools/latest/bin"` is a directory
- **THEN** it is prepended to `PATH`
- **WHEN** `"${ANDROID_HOME}/build-tools/${ANDROID_SDK_VERSION}"` is a directory
- **THEN** it is prepended to `PATH`
- **WHEN** `"${ANDROID_HOME}/emulator"` is a directory
- **THEN** it is prepended to `PATH`

#### Scenario: Directories missing
- **WHEN** any of the above directories do not exist
- **THEN** that directory is silently skipped (no error)
- **THEN** other directories are still added to PATH
