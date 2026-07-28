## Context

El módulo `zsh/modules/notify/` sigue una arquitectura de 3 capas (config → internal → pkg) y actualmente usa `notify-send` (Linux) / `osascript` (macOS) para notificaciones de escritorio. El usuario necesita notificaciones móviles vía Telegram.

**Estado actual:**
- `internal/linux.zsh` → `notify::internal::popup` usa `notify-send`
- `internal/osx.zsh` → `notify::internal::popup` usa `osascript`
- Hooks `preexec/precmd` detectan comandos >10s automáticamente
- Sonido vía `mpg123`

**Herramienta a integrar:** `noti` (codeberg.org/roble/noti) — CLI written en Go que envía notificaciones a múltiples servicios incluyendo Telegram.

## Goals / Non-Goals

**Goals:**
- Reemplazar `notify-send` por `noti` como backend de notificaciones
- Configurar Telegram como canal de notificación móvil
- Mantener la arquitectura three-layer del módulo
- Mantener compatibilidad con macOS y Linux
- Conservar el sonido de notificación vía `mpg123`
- Mantener los hooks automáticos `preexec/precmd`

**Non-Goals:**
- Soporte para otros servicios de noti (Slack, Pushbullet, etc.) — se puede agregar después
- Modificar la lógica de detección de comandos largos
- Cambiar el threshold de 10 segundos
- Agregar notificaciones de escritorio como fallback

## Decisions

### Decision 1: Usar noti como reemplazo directo de notify-send

**Alternativas consideradas:**
- **ntfy directo** (ntfy.sh) — más simple pero solo un servicio
- **notify-send + webhook** — requiere configurar webhook manualmente
- **noti** — soporta Telegram + muchos servicios, config YAML, CLI simple

**Elección:** noti porque:
- Ya tiene integración nativa con Telegram
- Config YAML limpia en `~/.config/noti/noti.yaml`
- Binario standalone (Go), sin dependencias runtime
- Soporta macOS y Linux con el mismo binario

### Decision 2: Mantener notify-send como fallback

**Razón:** Si noti no está instalado, el módulo debe seguir funcionando con `notify-send`. Se implementa un patrón de fallback:
1. Intentar noti primero
2. Si `core::exists noti` falla, usar notify-send (Linux) / osascript (macOS)

### Decision 3: Configuración via variables de entorno

**Alternativas:**
- Hardcodear token/chatId en el YAML
- Usar variables de entorno referenciadas en el YAML

**Elección:** Variables de entorno (`ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN`, `ZSH_NOTIFY_NOTI_TELEGRAM_CHATID`) porque:
- No exponer secrets en archivos versionados
- Consistente con el patrón existente del módulo
- Permite diferentes configs por máquina

### Decision 4: PATH-only pattern (sin shell hooks)

**Razón:** noti es un CLI standalone que no provee shell hooks, completions, ni keybindings. Solo necesita estar en PATH.

## Risks / Trade-offs

- **[Risk]** Token de Telegram expuesto en variables de entorno → **Mitigation:** Documentar que deben estar en `.zshrc.local` o keychain, no en archivos versionados
- **[Risk]** noti no instalado en nuevas máquinas → **Mitigation:** Fallback a notify-send + mensaje informativo
- **[Trade-off]** Agrega dependencia externa (noti binary) → **Mitigation:** Homebrew/AUR/nix disponibles, binario auto-contenido

## Migration Plan

1. Instalar noti en la máquina de desarrollo
2. Configurar `~/.config/noti/noti.yaml` con Telegram
3. Exportar variables de entorno en `.zshrc.local`
4. Copiar archivos modificados del módulo notify
5. Probar con comando largo (`sleep 15 && echo done`)
6. Verificar llegada de notificación a Telegram

**Rollback:** Revertir archivos del módulo notify a versión anterior. noti se puede desinstalar sin efectos secundarios.

## Open Questions

- ¿El usuario ya tiene un bot de Telegram creado?
- ¿Qué threshold de tiempo usar para notificar? (actual: 10s)
- ¿Notificar solo en éxito o también en error?
