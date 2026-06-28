## Requirements

### Requirement: Android SDK install orchestration

The system SHALL install Android SDK packages, Java, and command-line tools via `mobile::internal::android::install`.

#### Scenario: Clean install
- **WHEN** `adb` is not found on first shell load
- **THEN** system installs brew packages from `APPS_ANDROID` array
- **THEN** system provisions Java 17 via SDKMAN (see `sdkman-java` spec)
- **THEN** system installs cmdline-tools (platform-specific, see `cross-platform-android` spec)
- **THEN** system runs sdkmanager to install all SDK components
- **THEN** system prints success message on completion

#### Scenario: SDKMAN install failure
- **WHEN** curl download of SDKMAN installer fails
- **THEN** system prints error and continues without Java install

#### Scenario: sdkmanager not available after platform install
- **WHEN** platform-specific cmdline-tools step fails to make sdkmanager available
- **THEN** system prints warning: "sdkmanager not available. Install android-commandlinetools and try again."

### Requirement: Android SDK load

The system SHALL add Android SDK tools to PATH via `mobile::internal::android::load`.

#### Scenario: ANDROID_HOME exists
- **WHEN** `ANDROID_PLATFORM_TOOLS` directory exists
- **THEN** `"${ANDROID_PLATFORM_TOOLS}"` is prepended to PATH
- **WHEN** `"${ANDROID_HOME}/cmdline-tools/latest/bin"` directory exists
- **THEN** it is prepended to PATH
- **WHEN** `"${ANDROID_HOME}/build-tools/${ANDROID_SDK_VERSION}"` directory exists
- **THEN** it is prepended to PATH
- **WHEN** `"${ANDROID_HOME}/emulator"` directory exists
- **THEN** it is prepended to PATH
