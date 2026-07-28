## Why

El módulo notify actualmente detecta el proveedor de notificaciones automáticamente (`core::exists noti` → noti, fallback → notify-send). Esto no da control al usuario sobre qué proveedor usar, no es extensible para agregar nuevos proveedores (ntfy, Slack, etc.), y mezcla la lógica de selección con la implementación. Se necesita un patrón de adaptadores (provider strategy) como el que usa el módulo Docker.

## What Changes

- Se crea `ZSH_NOTIFY_PROVIDER` para que el usuario pueda elegir el proveedor
- Se implementa el patrón **provider adapter** (config/adapter/ + internal/adapter/)
- Cada proveedor (noti, notify-send) implementa el mismo contrato: `send`, `install`, `render`, `sync`
- Las OS popups actuales se reemplazan por dispatches al adapter activo
- El auto-detect se mantiene como fallback (`ZSH_NOTIFY_PROVIDER=auto`)

## Capabilities

### New Capabilities
- `provider-adapter-notify`: Patrón provider adapter para el módulo notify, permitiendo seleccionar el proveedor de notificaciones via `ZSH_NOTIFY_PROVIDER`

## Impact

- **Archivos nuevos:**
  - `config/adapter/noti.zsh` — env vars del adapter noti
  - `config/adapter/notify-send.zsh` — env vars del adapter notify-send
  - `internal/adapter/noti.zsh` — implementación noti (send, install, render, sync)
  - `internal/adapter/notify-send.zsh` — implementación notify-send (send, install)

- **Archivos modificados:**
  - `config/base.zsh` — agregar `ZSH_NOTIFY_PROVIDER`
  - `config/main.zsh` — dispatchear adapter según provider
  - `config/noti.zsh` — mover a config/adapter/noti.zsh o limpiar
  - `internal/main.zsh` — dispatchear adapter según provider
  - `internal/linux.zsh` — reemplazar popup por dispatch al adapter
  - `internal/osx.zsh` — reemplazar popup por dispatch al adapter
  - `internal/noti.zsh` — mover a internal/adapter/noti.zsh o limpiar
  - `internal/notify-send.zsh` — mover a internal/adapter/notify-send.zsh o limpiar

- **Archivos eliminados:**
  - `internal/noti.zsh` (reemplazado por adapter)
  - `internal/notify-send.zsh` (reemplazado por adapter)
  - `config/noti.zsh` (reemplazado por adapter)
  - `config/notify-send.zsh` (reemplazado por adapter)
