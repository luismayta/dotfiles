## Why

The notify module hardcodes `r2d2` as the sound theme in `internal/base.zsh`. There are already 3 sound themes available (`r2d2`, `autobots`, `default`) but no way to switch between them without editing module source. Adding a single config variable lets users pick their preferred theme from `config/`.

## What Changes

- Add `ZSH_NOTIFY_SOUND_THEME` variable in `config/base.zsh` (default: `r2d2`)
- Replace hardcoded `r2d2` references in `internal/base.zsh` with `${ZSH_NOTIFY_SOUND_THEME}`

## Capabilities

### New Capabilities
- `notify-sound-theme`: Configurable sound theme via `ZSH_NOTIFY_SOUND_THEME` variable

### Modified Capabilities

## Impact

- **Files**: `zsh/modules/notify/config/base.zsh`, `zsh/modules/notify/internal/base.zsh`
- **Breaking**: No — default remains `r2d2`
