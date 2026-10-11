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
`zsh/detect/terminal.zsh` según el terminal padre.

**El auto-arranque de tmux está deshabilitado permanentemente, sin opt-in.**
`zsh/detect/terminal.zsh` siempre fija la variable en `"false"` (todos los
emuladores y el catch-all), y el helper la trata como `"false"` cuando no está
definida. No existe ninguna forma de habilitar el auto-arranque vía variable de
entorno: no exportes esta variable esperando que tmux arranque.

Anteriormente existía un contrato opt-in (`export __ZSH_TMUX_AUTOSTART=true`
en `~/.customrc`), pero no podía funcionar — `~/.customrc` se sourcea después
de que el guard lo evalúe, y los `case` de detección sobrescriben cualquier
valor preestablecido.

#### TMUX_SOCKET

> **Legado / huérfana (orphaned):** ningún emulador define ya esta variable (el
> commit `5082cd20` eliminó los productores), pero el código de tmux todavía la
> lee, así que se conserva hasta que el módulo tmux migre.

Socket tmux dedicado por emulador de terminal. NO la define zsh — la define el
emulador (Ghostty, WezTerm, Alacritty). Si no está definida, tmux usa `default`.

```zsh
# Ghostty:  env = TMUX_SOCKET=ghostty
# WezTerm:  TMUX_SOCKET = "wezterm"
# Alacritty: TMUX_SOCKET = "alacritty"
```

### Herdr

#### HERDR_WORKSPACE

Identificador de emulador de terminal para el enrutamiento de sesiones de herdr.
NO la define zsh — la define el emulador (Ghostty, WezTerm, Alacritty).

```zsh
# Ghostty:  env = HERDR_WORKSPACE=ghostty
# WezTerm:  HERDR_WORKSPACE = "wezterm"
# Alacritty: HERDR_WORKSPACE = "alacritty"
```

La consume `hrd::start` en `zsh/modules/herdr/pkg/helper.zsh`: selecciona la
sesión de herdr a la que enruta, pasándola directamente mediante el flag
`--session` de herdr.

Si `HERDR_WORKSPACE` no está definida o está vacía, herdr arranca sin
enrutamiento (graceful, sin fallar) — análogo al fallback de tmux con
`TMUX_SOCKET`.

Nota: la variable se hereda por los procesos hijos (p. ej. Alacritty lanzado
desde WezTerm hereda `wezterm`); por eso la detección de terminal en
`zsh/zshrc` usa `TERM_PROGRAM` y no esta variable (ver el comentario en
`wezterm.lua`).

