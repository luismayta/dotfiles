## 1. Config

- [x] 1.1 Add `ZSH_NOTIFY_SOUND_THEME="${ZSH_NOTIFY_SOUND_THEME:-r2d2}"` to `config/base.zsh`

## 2. Implementation

- [x] 2.1 Replace hardcoded `r2d2` in `internal/base.zsh` with `${ZSH_NOTIFY_SOUND_THEME}`

## 3. Verification

- [x] 3.1 Test default (no override) — sounds load from `r2d2/`
- [x] 3.2 Set `ZSH_NOTIFY_SOUND_THEME=autobots` — sounds load from `autobots/`
