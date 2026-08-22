## Why

tmux se auto-arranca en cada shell interactiva zsh sin que el usuario lo haya habilitado explícitamente. El mecanismo vive en `zsh/system/core/pkg/helper/tmux.zsh` (auto-attach `new-session -A -s allsafe`) y es **opt-out por defecto** (`__ZSH_TMUX_AUTOSTART` default `"true"` en `zsh/detect/terminal.zsh`). Los intentos previos de desactivarlo fallaron porque `ZSH_TMUX_ENABLED=false` (el switch del módulo tmux) **no controla este autostart** — el helper vive en `core/`, fuera del módulo.

## What Changes

- El auto-arranque de tmux pasa de **opt-out a opt-in**: por defecto NO se arranca tmux en ninguna terminal, salvo habilitación explícita.
- `zsh/detect/terminal.zsh`: los casos `ghostty*` y `*` (default) definen `__ZSH_TMUX_AUTOSTART="false"` en lugar de `"true"`. WezTerm/Alacritty ya eran `"false"` y se mantienen.
- `zsh/system/core/pkg/helper/tmux.zsh`: el fallback del guard cambia de `:-true` a `:-false` — si `terminal.zsh` no se cargó (o no definió la variable), el autostart NO corre.
- Documentación en `zsh/zshrc`: cómo opt-in explícitamente (`export __ZSH_TMUX_AUTOSTART=true` en `~/.customrc`).
- El módulo tmux (helpers, aliases, config) NO cambia: sigue disponible bajo `ZSH_TMUX_ENABLED` como hasta ahora. Solo cambia el arranque automático.

## Capabilities

### New Capabilities
- `tmux-autostart`: comportamiento del auto-arranque de tmux en shells interactivas zsh — desactivado por defecto, habilitable explícitamente por terminal o por variable de entorno.

### Modified Capabilities
<!-- Ninguna: `zshrc-load` no declara requisitos sobre el autostart de tmux; el comportamiento es nuevo a nivel de spec. -->

## Impact

- `zsh/detect/terminal.zsh` — defaults de `__ZSH_TMUX_AUTOSTART` (líneas 27-32).
- `zsh/system/core/pkg/helper/tmux.zsh` — fallback del guard en línea 22 (`:-true` → `:-false`).
- `zsh/zshrc` — comentario de documentación sobre el opt-in (líneas ~53-56).
- Sin cambios de API, dependencias ni scripts de instalación. Los usuarios que quieran el autostart anterior deben setear `__ZSH_TMUX_AUTOSTART=true` explícitamente.
