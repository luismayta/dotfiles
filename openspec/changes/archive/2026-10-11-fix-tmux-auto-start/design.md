## Context

El autostart de tmux vive en `zsh/system/core/pkg/helper/tmux.zsh` y es opt-out por defecto: `zsh/detect/terminal.zsh` define `__ZSH_TMUX_AUTOSTART="true"` para Ghostty y cualquier terminal no detectada (WezTerm/Alacritty ya son `"false"`), y el helper usa `:-true` como fallback si la variable no existe. `ZSH_TMUX_ENABLED` (módulo tmux, default `false`) NO controla este helper — por eso los intentos previos de desactivación vía módulo fallaron. Ver proposal.md — Why.

## Goals / Non-Goals

**Goals:**
- Invertir el contrato: autostart OFF de forma incondicional en todas las terminales (sin opt-in).
- Doble seguro: ni la detección de terminal ni el helper arrancan tmux — ambos quedan en "no arrancar".
- Preservar el mecanismo (detección + guard) como punto de reactivación futura; re-habilitarlo hoy exige un cambio de código, no una variable.

**Non-Goals:**
- No cambiar el módulo tmux (`zsh/modules/tmux/`): helpers, aliases, config y `ZSH_TMUX_ENABLED` quedan intactos.
- No migrar ni tocar la configuración de tmux en `$HOME` (`.tmux.conf`, TPM, `~/.config/tmux`) — divergencia fuera de alcance.
- No modificar el comportamiento de WezTerm/Alacritty (ya estaban en `"false"`).
- No corregir el orden de carga de `~/.customrc` respecto de `core/main.zsh` en `zsh/zshrc` (defecto latente, ver D3).

## Decisions

**D1 — Invertir el default en `zsh/detect/terminal.zsh`, no eliminar el helper.**
Se cambian `ghostty*` y `*)` de `"true"` a `"false"`. El helper y la variable se conservan.
*Rationale:* la detección por terminal sigue siendo útil como estructura de política por terminal, y el clúster se conserva como lugar documentado donde un cambio de código deliberado podría re-habilitar el autostart en el futuro.
*Alternativa considerada:* borrar el autostart por completo — rechazada por ahora: el usuario prefiere conservar el clúster en su lugar aunque hoy sea código muerto (ver Risks). La justificación anterior de esta decisión era falsa: el "contrato para Ghostty (que define `TMUX_SOCKET`)" no existe desde el commit `5082cd20`, donde Ghostty pasó a definir `HERDR_WORKSPACE=ghostty` y ningún emulador define `TMUX_SOCKET`.

**D2 — Fallback `:-true` → `:-false` en `zsh/system/core/pkg/helper/tmux.zsh`.**
Defensa en profundidad: si `terminal.zsh` no se cargó o no definió la variable, el default es no arrancar.
*Rationale:* sin esto, una shell cuyo sourcing de `detect/terminal.zsh` falle volvería a arrancar tmux (regresión al comportamiento actual).
*Alternativa considerada:* depender solo de `terminal.zsh` — rechazada, deja un agujero si el sourcing falla o el archivo se reordena.

**D3 — El autostart se queda en `core/`, NO se mueve al módulo tmux.**
El autostart es comportamiento de sesión/terminal (core), no del módulo de herramientas. Moverlo ataría el arranque a `ZSH_TMUX_ENABLED` y habilitar el módulo por helpers reactivaría el autostart — acoplamiento no deseado.
*Defecto latente descubierto al planear (corrige la afirmación anterior sobre `ZSH_DISABLED_MODULES`):* el guard de `ZSH_DISABLED_MODULES` (líneas 17-19 del helper) NO apaga el autostart, como se afirmaba aquí. `zsh/zshrc:23` fuentea `core/main.zsh` (que fuentea `pkg/helper/tmux.zsh`, donde el guard vive), pero `~/.customrc` — donde se define `ZSH_DISABLED_MODULES` — solo se fuentea en `zsh/zshrc:49`: el guard lee la variable 26 líneas antes de que exista, así que deshabilitar el módulo tmux por `ZSH_DISABLED_MODULES` no tiene ningún efecto sobre el autostart (verificado empíricamente con tmux stubbeado). Tras este cambio el defecto queda inofensivo porque la rama de autostart es inalcanzable por defecto; corregir el orden de carga queda fuera de alcance de este cambio (ver Non-Goals) y se registra como deuda en `tasks.md`.

## Risks / Trade-offs

- [Usuarios que dependen del autostart lo pierden silenciosamente] → Mitigación: esta propuesta documenta el cambio de contrato; por decisión explícita del usuario NO hay opt-in — reactivarlo exige un cambio de código deliberado. Es un repositorio personal de un solo usuario.
- [La copia local `~/.zshrc` (cp, no symlink) no se actualiza sola] → Mitigación: el comportamiento (detect + helper) se lee desde el repo vía sourcing, así que el default OFF aplica en la próxima shell sin re-sincronizar.
- [Ghostty pierde el auto-attach a un socket dedicado que ya no existe] → El helper corre `tmux -L "${TMUX_SOCKET:-default}"` y nada define `TMUX_SOCKET`, así que en la práctica el autostart siempre resolvía a `-L default`; no hay socket dedicado que perder. Es exactamente lo que pide el usuario; no hay opt-in (ver D1/D3).
- [Código muerto por diseño] → Con `__ZSH_TMUX_AUTOSTART` permanentemente `"false"` y sin opt-in, el guard del helper (línea 22) nunca se cumple: `zsh/system/core/pkg/helper/tmux.zsh` queda inalcanzable y `zsh/detect/terminal.zsh` setea una variable que siempre es `"false"`. Decisión del usuario: dejar este clúster en su lugar por ahora en vez de borrarlo; no es una tarea de este cambio.

## Migration Plan

1. Aplicar cambios en el repo (detect, helper).
2. Nueva shell → el default OFF ya está activo (sourcing desde el repo).
3. Rollback: revertir los dos archivos; el comportamiento anterior (opt-out) se restaura.

## Open Questions

Ninguna. El alcance está definido por la propuesta y el spec.
