---
type: Reference
title: Environment Variables
description: Environment variable reference
tags: [environment, reference]
---

## Env Vars

### Application

#### ZSH_DISABLED_MODULES

Lista de módulos zsh que NO se cargan al iniciar la shell (espacio o coma separados).
Se define en `~/.customrc` (o `$CUSTOMRC`).

```zsh
export ZSH_DISABLED_MODULES="tmux"
export ZSH_DISABLED_MODULES="tmux starship"
export ZSH_DISABLED_MODULES="tmux,starship"
```

Los módulos deshabilitados se omiten tanto en `zsh/system/*/plugin.zsh` como en `zsh/modules/*/plugin.zsh`.
Si la variable no está definida, todos los módulos cargan.

### Tmux

#### ZSH_TMUX_ENABLED

Habilita el módulo tmux (helpers, aliases, config de TPM). Default: `false`.

```zsh
export ZSH_TMUX_ENABLED="${ZSH_TMUX_ENABLED:-false}"
```

#### __ZSH_TMUX_AUTOSTART

Controla el auto-arranque (auto-attach) de tmux en shells interactivas. La define
`zsh/detect/terminal.zsh` según el terminal padre. Contrato opt-in: tmux solo arranca
si la variable es `"true"`. Nota: el default actual se está invirtiendo a `"false"`
via el change `fix-tmux-auto-start`; para habilitar el auto-arranque explícitamente:

```zsh
export __ZSH_TMUX_AUTOSTART=true
```

#### TMUX_SOCKET

Socket tmux dedicado por emulador de terminal. NO la define zsh — la define el
emulador (Ghostty, WezTerm, Alacritty). Si no está definida, tmux usa `default`.

```zsh
# Ghostty:  env = TMUX_SOCKET=ghostty
# WezTerm:  TMUX_SOCKET = "wezterm"
# Alacritty: TMUX_SOCKET = "alacritty"
```
