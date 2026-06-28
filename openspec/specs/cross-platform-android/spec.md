## Requirements

### Requirement: Linux cmdline-tools download

The system SHALL download Android command-line tools directly from Google on Linux.

#### Scenario: cmdline-tools not installed on Linux
- **WHEN** `sdkmanager` is not found AND `uname -s` is Linux
- **THEN** system downloads `commandlinetools-linux-*_latest.zip` from `dl.google.com/android/repository/`
- **THEN** system extracts to `"${ANDROID_HOME}/cmdline-tools/"`
- **THEN** system renames extracted folder to `"${ANDROID_HOME}/cmdline-tools/latest"`

#### Scenario: macOS cmdline-tools via Homebrew
- **WHEN** `sdkmanager` is not found AND `uname -s` is Darwin
- **THEN** system runs `core::ensure android-commandlinetools`
- **THEN** system copies from `$(brew --prefix)/share/android-commandlinetools/` to `"${ANDROID_HOME}/cmdline-tools/latest/"`

### Requirement: sdkmanager component install

The system SHALL install Android SDK components via sdkmanager on all platforms.

#### Scenario: sdkmanager available
- **WHEN** `sdkmanager` is found after platform-specific install
- **THEN** system runs `sdkmanager --update --sdk_root="${ANDROID_HOME}"`
- **THEN** system installs `platforms;android-${ANDROID_PLATFORM_VERSION}`
- **THEN** system installs `platform-tools`
- **THEN** system installs `build-tools;${ANDROID_SDK_VERSION}`
- **THEN** system installs `extras;google;m2repository`
- **THEN** system installs `extras;android;m2repository`
- **THEN** errors from sdkmanager SHALL be visible (no `2>/dev/null || true` suppression)
