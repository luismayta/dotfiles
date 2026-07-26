## Context

The notify module has 3 sound themes under `assets/sounds/` (`r2d2`, `autobots`, `default`), each containing `success.mp3` and `error.mp3`. Currently `internal/base.zsh` hardcodes the `r2d2` path:

```zsh
notify::internal::play "${ZSH_NOTIFY_ASSETS_SOUND_PATH}/r2d2/success.mp3"
```

## Goals / Non-Goals

**Goals:**
- Allow switching sound themes via a single config variable
- Keep backward compatibility (default = `r2d2`)

**Non-Goals:**
- Changing the directory structure or asset format
- Supporting multiple themes simultaneously

## Decisions

### 1. Single variable `ZSH_NOTIFY_SOUND_THEME`

**Decision**: Add `ZSH_NOTIFY_SOUND_THEME` with default `r2d2`. The sound path becomes `${ZSH_NOTIFY_ASSETS_SOUND_PATH}/${ZSH_NOTIFY_SOUND_THEME}/success.mp3`.

**Rationale**: One line in config, one interpolation point. Consistent with `ZSH_YAZI_THEME` pattern already in the dotfiles.

## Risks / Trade-offs

- **[Risk] Invalid theme name** → `mpg123` fails silently (already does this). No new risk.
