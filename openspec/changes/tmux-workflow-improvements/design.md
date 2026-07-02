## Context

La configuración actual de tmux en este dotfiles tiene una brecha significativa entre macOS y Linux en cuanto a integración con el portapapeles. macOS usa OSC 52 + `pbcopy`/`pbpaste` con bindings completos para mouse, copy-mode, y paste. Linux solo tiene bindings básicos con `xclip`/`wl-copy` y no soporta OSC 52, mouse copying, ni paste desde sistema.

Además, ambos plataformas carecen de atajos modernos para navegación rápida de paneles, acciones rápidas sin entrar a copy-mode, y mejoras en gestión de sesiones.

## Goals / Non-Goals

**Goals:**
- Portar la funcionalidad completa de clipboard de macOS a Linux (OSC 52, mouse copy, buffer-to-clipboard, system paste)
- Agregar navegación de paneles con Alt+dirección y números
- Implementar acciones rápidas (copiar ruta del panel, copiar output, toggle sincronización visible)
- Mejorar `ftm`/`ftmk` con inline preview y renombrar rápido
- Mantener 100% compatibility hacia atrás — ningún binding existente se rompe

**Non-Goals:**
- No se agregan nuevos plugins de TPM
- No se modifica el theme/status bar (Catppuccin)
- No se reestructura la arquitectura del módulo tmux
- No se toca la configuración de macOS (solo Linux se actualiza)
- No se migra de tmuxinator a otra herramienta

## Decisions

### 1. OSC 52 como mecanismo primario de clipboard en Linux
- **Decisión:** Habilitar `set-clipboard external` en linux.conf y usar `xclip`/`wl-copy` como fallback, igual que macOS usa `pbcopy`
- **Por qué:** OSC 52 permite copiar desde sesiones SSH y contenedores remotos. Es el estándar moderno. Neovim y otros tools ya lo usan.
- **Alternativa considerada:** Solo `xclip` — pero no funciona en Wayland puro ni en SSH.

### 2. Atajos Alt+Arrow para navegación de paneles
- **Decisión:** Usar `bind-key -n M-h/j/k/l` para navegación directa sin prefix (como alternativa a `prefix h/j/k/l`)
- **Por qué:** Reduce un keystroke por navegación. Es el estándar en la mayoría de configuraciones modernas. Tmux soporta `-n` (sin prefix) bien.
- **Riesgo:** Puede conflictuar con atajos de la terminal (ej: Alt+f/b en bash/zsh). Se documentará explícitamente.

### 3. Prefix+number para ventanas (no panes)
- **Decisión:** Usar `bind-key -n M-0..9 select-window -t :0..9` (Alt+número cambia de ventana)
- **Por qué:** Para sesiones con múltiples ventanas, cambiar sin prefix es mucho más rápido.
- **Riesgo:** Alt+número puede conflictuar con algunas terminales. Se puede deshabilitar por variable de entorno.

### 4. Funciones helper en Zsh, no en tmux.conf
- **Decisión:** Las mejoras de sesión (`ftm` inline, renombrar rápido) van en `pkg/helper.zsh`
- **Por qué:** Ya existe el patrón en ese archivo. Mantiene la lógica compleja en Zsh donde es más fácil de mantener.

### 5. Buffer-to-clipboard en Linux
- **Decisión:** Usar `run-shell "tmux save-buffer - | xclip -selection clipboard"` (adaptado al clipboard tool disponible)
- **Por qué:** Permite copiar el contenido del buffer de tmux (último texto copiado dentro de tmux) al portapapeles del sistema con un solo comando.

## Risks / Trade-offs

| Riesgo | Mitigación |
|--------|------------|
| **Alt+arrows conflictúan con terminal**: Algunas terminales (gnome-terminal, kitty) usan Alt+arrow para word-wise navigation | Documentar el conflicto. Usuarios pueden deshabilitar con variable `TMUX_NO_ALT_NAV=true`. Alternativa: usar `bind-key -n M-S-h/j/k/l` como fallback. |
| **OSC 52 no soportado en algunas terminales**: Alacritty sí, gnome-terminal sí, xterm sí, algunos SSH clients no | `set-clipboard external` es soft-fail si la terminal no lo soporta. Tener `xclip`/`wl-copy` como fallback en los bindings. |
| **Binding overload**: Demasiados bindings pueden ser difíciles de recordar | Los bindings siguen el estándar de la comunidad (tmux-yank, tmux-copycat). Se documentarán en un comentario al inicio del archivo. |
| **xclip requiere sesión X**: No funciona en TTY puro | `wl-copy` como fallback en Wayland, y display-message si no hay clipboard disponible. |
