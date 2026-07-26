## ADDED Requirements

### Requirement: Configurable sound theme
The system SHALL provide a `ZSH_NOTIFY_SOUND_THEME` configuration variable that determines which sound theme directory is used for notification sounds. The default value SHALL be `r2d2`.

#### Scenario: Default sound theme
- **WHEN** `ZSH_NOTIFY_SOUND_THEME` is NOT set
- **THEN** notification sounds SHALL be loaded from `${ZSH_NOTIFY_ASSETS_SOUND_PATH}/r2d2/`

#### Scenario: Custom sound theme
- **WHEN** `ZSH_NOTIFY_SOUND_THEME` is set to `autobots`
- **THEN** notification sounds SHALL be loaded from `${ZSH_NOTIFY_ASSETS_SOUND_PATH}/autobots/`
