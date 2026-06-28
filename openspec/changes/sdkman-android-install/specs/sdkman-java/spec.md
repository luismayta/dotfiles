## ADDED Requirements

### Requirement: SDKMAN auto-install

The system SHALL install SDKMAN if not already present before provisioning Java for Android.

#### Scenario: SDKMAN not installed
- **WHEN** `sdk` command is not found
- **THEN** system downloads and runs `https://get.sdkman.io?rcupdate=false`
- **THEN** system sources `"${HOME}/.sdkman/bin/sdkman-init.sh"` immediately

#### Scenario: SDKMAN already installed
- **WHEN** `sdk` command is found
- **THEN** system sources `"${HOME}/.sdkman/bin/sdkman-init.sh"` without reinstalling

### Requirement: Java 17 Temurin provisioning

The system SHALL provision JDK 17 via SDKMAN for Android SDK dependency.

#### Scenario: Java not available
- **WHEN** `java -version` fails
- **THEN** system runs `sdk install java 17.0.13-tem`
- **THEN** system runs `sdk default java 17.0.13-tem`

#### Scenario: Java already available
- **WHEN** `java -version` succeeds
- **THEN** system skips Java installation entirely
