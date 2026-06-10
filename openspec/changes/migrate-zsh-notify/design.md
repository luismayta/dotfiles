## Context

`luismayta/zsh-notify` is an external zsh plugin providing desktop notifications with terminal output integration, configurable sound themes, and audio assets. The source repo has a 2-layer structure with `assets/` and `sounds/` directories containing 2 sound themes (default and piano). Functions are under the `notify::` namespace.

## Goals / Non-Goals

**Goals:**
- Port all `notify::*` functions into `zsh/modules/notify/`
- Copy audio assets (assets/, sounds/ with 2 themes)
- Support darwin and linux OS dispatch
- Remove `luismayta/zsh-notify` from `zsh/zsh_plugins.txt`
- Maintain exact function names and behavior

**Non-Goals:**
- No changes to notification behavior or sound themes
- No changes to zshenv or zshrc loader
- No audio format conversion

## Decisions

1. **Module root var**: `ZSH_NOTIFY_PATH` — follows the established pattern.
2. **Structure**: ~20 files + `assets/` and `sounds/` directories (subdirectories: `default/`, `piano/`).
3. **OS dispatch**: macOS uses `terminal-notifier` or `osascript`; Linux uses `notify-send`.
4. **Sound playback**: macOS uses `afplay`; Linux uses `paplay` or `aplay`.

## Risks / Trade-offs

- Binary audio files (.wav, .mp3) increase repo size — acceptable for UX feature.
- Cross-platform sound paths must be resolved relative to `ZSH_NOTIFY_PATH`.
