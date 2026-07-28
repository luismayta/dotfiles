## Why

El módulo notify actualmente solo envía notificaciones de escritorio via `notify-send` (Linux) o `osascript` (macOS). El usuario necesita recibir notificaciones en su **teléfono** cuando un comando de larga duración termina, pero `notify-send` solo funciona en la máquina local. Se necesita un backend que envíe a Telegram para notificaciones móviles.

## What Changes

- Se integra **noti** (codeberg.org/roble/noti) como nuevo backend de notificaciones
- Se reemplaza `notify-send` por `noti` en el flujo de notificaciones
- Se agrega configuración de Telegram (token + chatId) via variables de entorno
- Se mantiene compatibilidad con macOS (noti soporta ambos OS)
- Se conserva el sonido de notificación vía `mpg123`
- Se mantiene la arquitectura three-layer (config → internal → pkg) del módulo notify

## Capabilities

### New Capabilities

- `noti-telegram-backend`: Integración de noti como backend de notificaciones con soporte Telegram, incluyendo configuración, envío automático vía hooks, y compatibilidad multi-OS

### Modified Capabilities

<!-- Existing capabilities whose REQUIREMENTS are changing -->

- `tool-implementation-guide`: Se agrega noti como referencia de integración de herramientas CLI standalone (patrón PATH-only sin shell hooks)

## Impact

- **Archivos modificados:**
  - `zsh/modules/notify/config/base.zsh` — nuevas variables `ZSH_NOTIFY_NOTI_*`
  - `zsh/modules/notify/config/linux.zsh` — config de noti para Linux
  - `zsh/modules/notify/config/osx.zsh` — config de noti para macOS
  - `zsh/modules/notify/internal/linux.zsh` — reemplazo de `notify-send` por `noti`
  - `zsh/modules/notify/internal/osx.zsh` — reemplazo de osascript por `noti`
  - `zsh/modules/notify/internal/base.zsh` — función `notify::noti::internal::send`
  - `zsh/modules/notify/pkg/base.zsh` — wrapper público `notify::noti::send`
  - `zsh/modules/notify/plugin.zsh` — carga de configuración noti

- **Dependencias nuevas:**
  - `noti` CLI (homebrew, AUR, nix, o binario pre-compilado)

- **Archivos de configuración:**
  - `~/.config/noti/noti.yaml` — configuración de Telegram
