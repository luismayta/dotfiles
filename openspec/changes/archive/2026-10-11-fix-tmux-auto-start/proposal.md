## Why

tmux se auto-arranca en parte de las shells interactivas zsh sin que el usuario lo haya habilitado explícitamente: solo los casos `ghostty*` y `*` (default) de `zsh/detect/terminal.zsh` definen `__ZSH_TMUX_AUTOSTART="true"` — WezTerm y Alacritty ya eran `"false"`, así que no era "cada shell interactiva". El mecanismo vive en `zsh/system/core/pkg/helper/tmux.zsh` (auto-attach `new-session -A -s allsafe`) y es **opt-out por defecto**. Los intentos previos de desactivarlo fallaron porque `ZSH_TMUX_ENABLED=false` (el switch del módulo tmux) **no controla este autostart** — el helper vive en `core/`, fuera del módulo. Nota sobre el módulo: `ZSH_TMUX_ENABLED` defaulta a `"false"` (`zsh/modules/tmux/config/base.zsh:2`, consumido en `zsh/modules/tmux/plugin.zsh:25`) y `~/.customrc` añade además `ZSH_DISABLED_MODULES="tmux"` — el módulo tmux ya está deshabilitado por defecto, y este cambio no lo altera.

## What Changes

- El auto-arranque de tmux pasa de **opt-out a siempre desactivado**: por defecto NO se arranca tmux en ninguna terminal y **no existe opt-in** — reactivarlo en el futuro exige un cambio de código deliberado.
- `zsh/detect/terminal.zsh`: los casos `ghostty*` y `*` (default) definen `__ZSH_TMUX_AUTOSTART="false"` en lugar de `"true"`. WezTerm/Alacritty ya eran `"false"` y se mantienen.
- `zsh/system/core/pkg/helper/tmux.zsh`: el fallback del guard cambia de `:-true` a `:-false` — si `terminal.zsh` no se cargó (o no definió la variable), el autostart NO corre.
- Sin opt-in y sin documentación de opt-in: `export __ZSH_TMUX_AUTOSTART=true` en `~/.customrc` **no tiene efecto** (el guard se ejecuta al fuentear `core/main.zsh` en `zsh/zshrc:23`, antes de que `~/.customrc` se fuentea en `zsh/zshrc:49`, y las cuatro ramas de `zsh/detect/terminal.zsh` sobreescriben cualquier valor predefinido). No se documenta ninguna variable para re-habilitar el autostart.
- El módulo tmux (helpers, aliases, config) NO cambia: permanece deshabilitado por defecto (`ZSH_TMUX_ENABLED=false`) y además deshabilitado en `~/.customrc` vía `ZSH_DISABLED_MODULES="tmux"`. Solo cambia el arranque automático.

## Capabilities

### New Capabilities
- `tmux-autostart`: comportamiento del auto-arranque de tmux en shells interactivas zsh — desactivado de forma incondicional, sin opt-in por terminal ni por variable de entorno.

### Modified Capabilities
<!-- Ninguna: `zshrc-load` no declara requisitos sobre el autostart de tmux; el comportamiento es nuevo a nivel de spec. -->

## Impact

- `zsh/detect/terminal.zsh` — defaults de `__ZSH_TMUX_AUTOSTART` (líneas 27-32: `ghostty*` y `*`).
- `zsh/system/core/pkg/helper/tmux.zsh` — fallback del guard en línea 22 (`:-true` → `:-false`).
- Sin cambios de API, dependencias ni scripts de instalación. No hay opt-in: quien quiera el autostart anterior debe hacer un cambio de código deliberado (por decisión explícita, fuera de este cambio).
