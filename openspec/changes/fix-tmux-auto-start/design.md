## Context

El autostart de tmux vive en `zsh/system/core/pkg/helper/tmux.zsh` y es opt-out por defecto: `zsh/detect/terminal.zsh` define `__ZSH_TMUX_AUTOSTART="true"` para Ghostty y cualquier terminal no detectada (WezTerm/Alacritty ya son `"false"`), y el helper usa `:-true` como fallback si la variable no existe. `ZSH_TMUX_ENABLED` (módulo tmux, default `false`) NO controla este helper — por eso los intentos previos de desactivación vía módulo fallaron. Ver proposal.md — Why.

## Goals / Non-Goals

**Goals:**
- Invertir el contrato: autostart opt-in (default OFF) en todas las terminales.
- Doble seguro: ni la detección de terminal ni el helper arrancan tmux sin opt-in explícito.
- Preservar el mecanismo completo para quien quiera habilitarlo (un cambio de variable).

**Non-Goals:**
- No cambiar el módulo tmux (`zsh/modules/tmux/`): helpers, aliases, config y `ZSH_TMUX_ENABLED` quedan intactos.
- No migrar ni tocar la configuración de tmux en `$HOME` (`.tmux.conf`, TPM, `~/.config/tmux`) — divergencia fuera de alcance.
- No modificar el comportamiento de WezTerm/Alacritty (ya estaban en `"false"`).

## Decisions

**D1 — Invertir el default en `zsh/detect/terminal.zsh`, no eliminar el helper.**
Se cambian `ghostty*` y `*)` de `"true"` a `"false"`. El helper y la variable se conservan como mecanismo de opt-in.
*Rationale:* la detección por terminal sigue siendo útil (política por terminal); eliminar el helper destruiría la feature para quien la usa.
*Alternativa considerada:* borrar el autostart por completo — rechazada, pierde funcionalidad y rompe el contrato para Ghostty (que define `TMUX_SOCKET`).

**D2 — Fallback `:-true` → `:-false` en `zsh/system/core/pkg/helper/tmux.zsh`.**
Defensa en profundidad: si `terminal.zsh` no se cargó o no definió la variable, el default es no arrancar.
*Rationale:* sin esto, una shell cuyo sourcing de `detect/terminal.zsh` falle volvería a arrancar tmux (regresión al comportamiento actual).
*Alternativa considerada:* depender solo de `terminal.zsh` — rechazada, deja un agujero si el sourcing falla o el archivo se reordena.

**D3 — El autostart se queda en `core/`, NO se mueve al módulo tmux.**
El autostart es comportamiento de sesión/terminal (core), no del módulo de herramientas. Moverlo ataría el arranque a `ZSH_TMUX_ENABLED` y habilitar el módulo por helpers reactivaría el autostart — acoplamiento no deseado. El guard existente de `ZSH_DISABLED_MODULES` (línea 17-19 del helper) se mantiene: deshabilitar el módulo tmux por `ZSH_DISABLED_MODULES` sigue apagando también el autostart.

**D4 — Documentar el opt-in en `zsh/zshrc`.**
Junto a los comentarios existentes de `ZSH_DISABLED_MODULES` (~líneas 53-56) se documenta `export __ZSH_TMUX_AUTOSTART=true` en `~/.customrc`.

## Risks / Trade-offs

- [Usuarios que dependen del autostart lo pierden silenciosamente] → Mitigación: comentario de opt-in en `zsh/zshrc` + esta propuesta documenta el cambio de contrato; es un repositorio personal de un solo usuario.
- [La copia local `~/.zshrc` (cp, no symlink) no se actualiza sola] → Mitigación: el comentario de docs solo afecta al repo; el comportamiento (detect + helper) se lee desde el repo vía sourcing, así que el default OFF aplica en la próxima shell sin re-sincronizar. Para la doc nueva, re-copiar `zsh/zshrc` (install.sh ya hace `cp`).
- [Ghostty: se pierde el auto-attach a la sesión con socket dedicado] → Mitigación: es exactamente lo que pide el usuario; el opt-in (`__ZSH_TMUX_AUTOSTART=true`) restaura el comportamiento anterior si se desea.

## Migration Plan

1. Aplicar cambios en el repo (detect, helper, zshrc).
2. Nueva shell → el default OFF ya está activo (sourcing desde el repo).
3. Rollback: revertir los tres archivos; el comportamiento anterior (opt-out) se restaura.

## Open Questions

Ninguna. El alcance está definido por la propuesta y el spec.
