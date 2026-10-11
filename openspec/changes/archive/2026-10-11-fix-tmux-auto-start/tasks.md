## 1. Invertir el default en la detección de terminal

- [x] 1.1 En `zsh/detect/terminal.zsh`, cambiar el caso `ghostty*)` de `__ZSH_TMUX_AUTOSTART="true"` a `"false"`
- [x] 1.2 En `zsh/detect/terminal.zsh`, cambiar el caso default `*)` de `__ZSH_TMUX_AUTOSTART="true"` a `"false"`
- [x] 1.3 Actualizar el comentario de cabecera de `zsh/detect/terminal.zsh` si describe el default como `"true"` (línea 10: `"true" to allow tmux auto-start` → describir el nuevo contrato: sin opt-in, autostart siempre desactivado)

## 2. Fallback seguro en el helper de core

- [x] 2.1 En `zsh/system/core/pkg/helper/tmux.zsh`, cambiar el guard de la línea 22: `${__ZSH_TMUX_AUTOSTART:-true}` → `${__ZSH_TMUX_AUTOSTART:-false}`
- [x] 2.2 Actualizar el comentario del guard (líneas 11-13) para reflejar que el default es NO arrancar y que no existe opt-in

## 3. Verificación

- [x] 3.1 `zsh -n` sobre `zsh/detect/terminal.zsh`, `zsh/system/core/pkg/helper/tmux.zsh` y `zsh/zshrc` (sin errores de sintaxis)
- [x] 3.2 Simular: con `__ZSH_TMUX_AUTOSTART` no definida, el guard del helper evalúa a no-arrancar (verificar el fallback `:-false`)
- [x] 3.3 Simular: con `__ZSH_TMUX_AUTOSTART="true"` (solo como prueba mecánica del guard — no existe opt-in soportado) y sin `TMUX` definido, el guard evalúa a arrancar; documenta que el guard es un blocklist (`!= "false"`), no un allowlist

## Workflow follow-up

- Defecto latente conocido, sin arreglar a propósito y diferido a un cambio futuro: en `zsh/zshrc`, `core/main.zsh` se fuentea en la línea 23 pero `~/.customrc` (donde se define `ZSH_DISABLED_MODULES`) en la línea 49, así que el guard de `ZSH_DISABLED_MODULES` del helper (líneas 17-19) se evalúa antes de que la variable exista y nunca apaga el autostart. Tras este cambio es inofensivo porque la rama de autostart queda inalcanzable por defecto.
- `docs/env-vars.md` (líneas 40-45) documenta el opt-in `__ZSH_TMUX_AUTOSTART`; esa documentación está siendo eliminada por el flujo de trabajo paralelo (ese archivo pertenece a otro agente).
