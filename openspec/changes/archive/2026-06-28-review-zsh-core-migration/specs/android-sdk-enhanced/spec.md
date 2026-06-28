## ADDED Requirements

### Requirement: SDK manager-based Android platform installation

The system SHALL enhance `android::install` to install Android SDK platforms, build-tools, and M2 repositories via `sdkmanager` in addition to the existing brew-based package installation.

#### Scenario: sdkmanager is installed if missing

- **WHEN** `android::install` is called and `sdkmanager` is not found
- **THEN** the system SHALL install `android-commandlinetools` via brew and copy it to `$ANDROID_HOME/cmdline-tools/latest/`

#### Scenario: Android platforms installed via sdkmanager

- **WHEN** `android::install` is called
- **THEN** the system SHALL run `sdkmanager "platforms;android-$ANDROID_PLATFORM_VERSION"` with the configured platform version

#### Scenario: Android build-tools installed via sdkmanager

- **WHEN** `android::install` is called
- **THEN** the system SHALL run `sdkmanager "build-tools;$ANDROID_SDK_VERSION"` with the configured SDK version

#### Scenario: M2 repositories installed

- **WHEN** `android::install` is called
- **THEN** the system SHALL install `extras;google;m2repository` and `extras;android;m2repository` via sdkmanager

### Requirement: Configurable Android platform versions

The system SHALL define configuration variables for Android SDK platform version and SDK build-tools version in `config/android.zsh`, matching the pattern from zsh-core.

#### Scenario: ANDROID_PLATFORM_VERSION defaults to 35

- **WHEN** the mobile module loads
- **THEN** `ANDROID_PLATFORM_VERSION` SHALL be set to `35` unless overridden

#### Scenario: ANDROID_SDK_VERSION defaults to 35.0.1

- **WHEN** the mobile module loads
- **THEN** `ANDROID_SDK_VERSION` SHALL be set to `35.0.1` unless overridden

### Requirement: Java dependency check

The system SHALL check for Java before running sdkmanager and auto-install OpenJDK if missing.

#### Scenario: OpenJDK installed when missing

- **WHEN** `android::install` is called and `java` is not found
- **THEN** the system SHALL install `openjdk@11`, `openjdk@17`, and `openjdk@21` via brew

### Requirement: Backward compatibility

The enhanced `android::install` SHALL still install brew packages (`android-studio`, `android-platform-tools`) via `core::ensure` as before, then layer sdkmanager on top.

#### Scenario: Brew packages still installed

- **WHEN** `android::install` is called
- **THEN** the system SHALL still run `core::ensure` for each package in `APPS_ANDROID`
