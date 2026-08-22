## Purpose

Controla el auto-arranque de tmux en shells interactivas zsh: desactivado por defecto, habilitable explícitamente por el usuario para que tmux solo se inicie cuando él lo decida.

## ADDED Requirements

### Requirement: Autostart desactivado por defecto

El sistema SHALL NO iniciar tmux automáticamente en una shell interactiva zsh a menos que la variable `__ZSH_TMUX_AUTOSTART` esté explícitamente definida como `"true"`. Esto aplica a todas las terminales, incluidas aquellas que hoy activan el autostart (Ghostty y terminales no detectadas explícitamente).

#### Scenario: Shell interactiva sin opt-in

- **WHEN** una shell interactiva zsh se inicia en Ghostty sin que `__ZSH_TMUX_AUTOSTART` esté definida como `"true"`
- **THEN** tmux NO se inicia ni se attacha automáticamente

#### Scenario: Terminal no detectada por defecto

- **WHEN** una shell interactiva zsh se inicia en una terminal cuyo proceso padre no coincide con `wezterm*`, `alacritty*` ni `ghostty*`
- **THEN** tmux NO se inicia automáticamente (el default es no arrancar)

### Requirement: Opt-in explícito habilita el autostart

El sistema SHALL iniciar (o attachar a) la sesión tmux automáticamente cuando `__ZSH_TMUX_AUTOSTART` es `"true"`, tmux está instalado y la shell no corre ya dentro de tmux.

#### Scenario: Opt-in explícito activa el arranque

- **WHEN** `__ZSH_TMUX_AUTOSTART="true"` está definida, tmux está instalado y `TMUX` no está definido
- **THEN** el sistema ejecuta el auto-attach/auto-create de la sesión tmux (`new-session -A`)

#### Scenario: Shell dentro de tmux no se anida

- **WHEN** la shell ya corre dentro de tmux (`TMUX` definido)
- **THEN** el sistema NO ejecuta otro arranque de tmux, aunque `__ZSH_TMUX_AUTOSTART="true"`

### Requirement: Fallback seguro sin detección de terminal

El sistema SHALL NO iniciar tmux automáticamente cuando la detección de terminal no definió `__ZSH_TMUX_AUTOSTART` (por ejemplo, si `zsh/detect/terminal.zsh` no se cargó).

#### Scenario: Detección de terminal ausente

- **WHEN** una shell interactiva zsh se inicia y `__ZSH_TMUX_AUTOSTART` no está definida por la detección de terminal ni por el usuario
- **THEN** tmux NO se inicia automáticamente (el fallback del guard es no arrancar)
