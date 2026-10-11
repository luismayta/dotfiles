# tmux-autostart Specification

## Purpose

Controla el auto-arranque de tmux en shells interactivas zsh: desactivado de forma incondicional — tmux solo se inicia cuando el usuario lo lanza deliberadamente. No existe opt-in por variable de entorno ni por configuración.

## Requirements

### Requirement: Autostart desactivado de forma incondicional

El sistema SHALL NO iniciar tmux automáticamente en una shell interactiva zsh, en ninguna terminal y sin posibilidad de reactivación por variable de entorno. Esto aplica también a las terminales que hoy lo activan (los casos `ghostty*` y `*` de `zsh/detect/terminal.zsh`). Re-habilitar el autostart en el futuro exige un cambio de código deliberado; no hay opt-in.

#### Scenario: Shell interactiva en Ghostty

- **WHEN** una shell interactiva zsh se inicia en Ghostty
- **THEN** tmux NO se inicia ni se attacha automáticamente

#### Scenario: Terminal no detectada por defecto

- **WHEN** una shell interactiva zsh se inicia en una terminal cuyo proceso padre no coincide con `wezterm*`, `alacritty*` ni `ghostty*`
- **THEN** tmux NO se inicia automáticamente (el default es no arrancar)

#### Scenario: Intento de opt-in por variable de entorno

- **WHEN** el usuario define `__ZSH_TMUX_AUTOSTART=true` en `~/.customrc`
- **THEN** tmux NO se inicia automáticamente: el guard se ejecuta al fuentear `core/main.zsh` en `zsh/zshrc:23`, antes de que `~/.customrc` se fuentea en `zsh/zshrc:49`, y las cuatro ramas de `zsh/detect/terminal.zsh` sobreescriben cualquier valor predefinido

### Requirement: Fallback seguro sin detección de terminal

El sistema SHALL NO iniciar tmux automáticamente cuando la detección de terminal no definió `__ZSH_TMUX_AUTOSTART` (por ejemplo, si `zsh/detect/terminal.zsh` no se cargó): el fallback del guard es no arrancar. No se exige ningún valor concreto de la variable para decidir — el resultado requerido es siempre no arrancar.

#### Scenario: Detección de terminal ausente

- **WHEN** una shell interactiva zsh se inicia y `__ZSH_TMUX_AUTOSTART` no está definida por la detección de terminal ni por el usuario
- **THEN** tmux NO se inicia automáticamente (el fallback del guard es no arrancar)
