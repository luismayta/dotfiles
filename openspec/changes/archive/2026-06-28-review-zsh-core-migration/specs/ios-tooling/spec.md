## ADDED Requirements

### Requirement: iOS development tool installation

The system SHALL provide an `ios::install` function that installs the full iOS development toolchain on macOS (CocoaPods, usbmuxd, libimobiledevice, ideviceinstaller, ios-deploy). The function SHALL be a no-op on non-macOS platforms.

#### Scenario: Installs CocoaPods via RubyGems

- **WHEN** `ios::install` is called on macOS and `gem` is available
- **THEN** the function SHALL run `gem install cocoapods`

#### Scenario: Installs USB multiplexing tools via Homebrew

- **WHEN** `ios::install` is called on macOS
- **THEN** the function SHALL run `brew install --HEAD usbmuxd` and `brew link usbmuxd`

#### Scenario: Installs device management tools

- **WHEN** `ios::install` is called on macOS
- **THEN** the function SHALL run `brew install --HEAD libimobiledevice`, `brew install ideviceinstaller`, and `brew install ios-deploy`

#### Scenario: Warns on missing gem

- **WHEN** `ios::install` is called and `gem` is not found
- **THEN** the function SHALL print a warning message and return without installing

#### Scenario: No-op on Linux

- **WHEN** `ios::install` is called on a Linux system
- **THEN** the function SHALL print an info message and return without installing

### Requirement: iOS development tool loading

The system SHALL provide an `ios::load` function that optionally adds CocoaPods binaries to PATH if the `.cocoapods` directory exists.

#### Scenario: Loads CocoaPods path if installed

- **WHEN** `ios::load` is called and CocoaPods is installed
- **THEN** the system SHALL add CocoaPods binaries to PATH

### Requirement: iOS setup composite function

The system SHALL provide an `ios::setup` function that chains install, load, and CocoaPods spec repo setup.

#### Scenario: Full iOS setup on macOS

- **WHEN** `ios::setup` is called on macOS
- **THEN** the system SHALL install iOS tools, load paths, and run `pod setup`

### Requirement: Integration with mobile::setup

The system SHALL update `mobile::setup` so that on macOS it optionally runs `ios::setup` after Android and Flutter setup.

#### Scenario: mobile::setup runs iOS setup on macOS

- **WHEN** `mobile::setup` is called on macOS
- **THEN** the system SHALL run `ios::setup` after Android and Flutter setup

### Requirement: Auto-install guard for iOS tools

The system SHALL auto-install iOS tools in `internal/main.zsh` only on macOS AND only when Flutter is detected (as a heuristic that the user intends iOS development). Explicit `ios::setup` SHALL always work regardless.

#### Scenario: Auto-install on macOS with Flutter present

- **WHEN** the mobile module loads on macOS and `flutter` binary is found
- **THEN** the system SHALL auto-install iOS tools if missing

#### Scenario: No auto-install on macOS without Flutter

- **WHEN** the mobile module loads on macOS and `flutter` is not found
- **THEN** the system SHALL skip iOS tool auto-installation

#### Scenario: No auto-install on Linux

- **WHEN** the mobile module loads on Linux
- **THEN** the system SHALL skip iOS tool auto-installation
