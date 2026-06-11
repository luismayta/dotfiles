## ADDED Requirements

### Requirement: Hyprland package installation
The module SHALL install the Hyprland compositor via `core::install`.

#### Scenario: Install on Linux
- **WHEN** `hyprland::install` is called on Linux
- **THEN** it SHALL call `core::install hyprland`
- **THEN** it SHALL run `hyprland::post_install` after successful install

#### Scenario: No-op on macOS
- **WHEN** `hyprland::install` is called on macOS
- **THEN** it SHALL do nothing and return successfully

### Requirement: Ecosystem package installation
The module SHALL install Hyprland ecosystem packages via `core::install`.

#### Scenario: Install ecosystem packages
- **WHEN** `hyprland::install` is called on Linux
- **THEN** it SHALL install `hypridle` (idle management daemon)
- **THEN** it SHALL install `hyprlock` (screen locker)
- **THEN** it SHALL install `hyprpaper` (wallpaper utility)
- **THEN** it SHALL install `waybar` (status bar)
- **THEN** it SHALL install `dunst` (notification daemon)

#### Scenario: Check package existence before install
- **WHEN** installing any package
- **THEN** it SHALL check `core::exists <package>` before installing
- **THEN** it SHALL skip installation if the package already exists

### Requirement: Post-install sync
The module SHALL sync configs after installation.

#### Scenario: Config sync after install
- **WHEN** `hyprland::post_install` runs
- **THEN** it SHALL call `hyprland::sync`
- **THEN** it SHALL display a success message