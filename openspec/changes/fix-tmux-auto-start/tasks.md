## 1. Invertir el default en la detección de terminal

- [ ] 1.1 En `zsh/detect/terminal.zsh`, cambiar el caso `ghostty*)` de `__ZSH_TMUX_AUTOSTART="true"` a `"false"`
- [ ] 1.2 En `zsh/detect/terminal.zsh`, cambiar el caso default `*)` de `__ZSH_TMUX_AUTOSTART="true"` a `"false"`
- [ ] 1.3 Actualizar el comentario de cabecera de `zsh/detect/terminal.zsh` si describe el default como `"true"` (línea 10: `"true" to allow tmux auto-start` → describir el nuevo contrato opt-in)

## 2. Fallback seguro en el helper de core

- [ ] 2.1 En `zsh/system/core/pkg/helper/tmux.zsh`, cambiar el guard de la línea 22: `${__ZSH_TMUX_AUTOSTART:-true}` → `${__ZSH_TMUX_AUTOSTART:-false}`
- [ ] 2.2 Actualizar el comentario del guard (líneas 11-13) para reflejar que el default es NO arrancar sin opt-in explícito

## 3. Documentar el opt-in

- [ ] 3.1 En `zsh/zshrc`, junto a los comentarios de `ZSH_DISABLED_MODULES` (~líneas 53-56), añadir la documentación del opt-in: `export __ZSH_TMUX_AUTOSTART=true` en `~/.customrc` para restaurar el auto-arranque

## 4. Verificación

- [ ] 4.1 `zsh -n` sobre `zsh/detect/terminal.zsh`, `zsh/system/core/pkg/helper/tmux.zsh` y `zsh/zshrc` (sin errores de sintaxis)
- [ ] 4.2 Simular: con `__ZSH_TMUX_AUTOSTART` no definida, el guard del helper evalúa a no-arrancar (verificar el fallback `:-false`)
- [ ] 4.3 Simular: con `__ZSH_TMUX_AUTOSTART="true"` y sin `TMUX` definido, el guard evalúa a arrancar
