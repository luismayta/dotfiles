## ADDED Requirements

### Requirement: Resource and font management
The Resources module SHALL provide font installation and asset management for macOS and Linux.

#### Scenario: Module loads on zsh start
- **WHEN** zsh starts and sources `zsh/modules/resources/plugin.zsh`
- **THEN** the module SHALL set `RESOURCES_PATH` and SHALL source `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh`
- **THEN** the module SHALL define `__ZSH_RESOURCES_LOADED=1` to prevent double-loading

#### Scenario: Environment variables are set
- **WHEN** the module loads
- **THEN** `RESOURCES_PACKAGE_NAME` SHALL be `resources`
- **AND** `RESOURCES_ASSETS_DIR` SHALL be `$RESOURCES_PATH/assets`
- **AND** `RESOURCES_ASSETS_FONTS_DIR` SHALL be `$RESOURCES_PATH/assets/fonts`
- **WHEN** the module loads on macOS
- **THEN** `RESOURCES_FONTS_DIR` SHALL be `$HOME/Library/Fonts`
- **WHEN** the module loads on Linux
- **THEN** `RESOURCES_FONTS_DIR` SHALL be `$HOME/.fonts`

#### Scenario: Font sync via resources::fonts::sync
- **WHEN** user runs `resources::fonts::sync`
- **THEN** the module SHALL rsync `$RESOURCES_ASSETS_FONTS_DIR/` to `$RESOURCES_FONTS_DIR`
- **AND** SHALL run `fc-cache -fv` on Linux to update the font cache

#### Scenario: Assets directory exists
- **WHEN** the module loads
- **THEN** `$RESOURCES_ASSETS_DIR` SHALL contain fonts and images for distribution

#### Scenario: Dependency check
- **WHEN** the module loads
- **THEN** it SHALL ensure `rsync` is installed