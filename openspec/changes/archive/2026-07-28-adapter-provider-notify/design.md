## Context

El módulo notify actualmente auto-detecta el proveedor de notificaciones mediante `core::exists` en las funciones `notify::internal::popup` de los archivos OS-specific (`linux.zsh`, `osx.zsh`). Esto mezcla:

1. **Decisión de qué proveedor usar** — en la misma función que envía la notificación
2. **Extensibilidad** — agregar un nuevo proveedor (Slack, ntfy, etc.) requiere modificar 3+ archivos
3. **Control de usuario** — no hay variable `ZSH_NOTIFY_PROVIDER`

El módulo Docker resuelve exactamente este problema con el patrón **provider adapter**: cada proveedor tiene su propio archivo en `config/adapter/` + `internal/adapter/`, y una variable `ZSH_NOTIFY_PROVIDER` selecciona cuál cargar.

## Goals / Non-Goals

**Goals:**
- Implementar `ZSH_NOTIFY_PROVIDER` ("noti", "notify-send", "auto")
- Crear directorios `config/adapter/` e `internal/adapter/`
- Cada adapter define: `send`, `install`, `render`, `sync`
- OS popups delegan al adapter activo
- Mantener compatibilidad: `auto` = comportamiento actual (auto-detect)
- Seguir el patrón Docker (override via source order)

**Non-Goals:**
- Agregar nuevos proveedores (Slack, ntfy, etc.) — esto se hará después
- Modificar el contrato de las funciones públicas existentes (`notify::noti::send` se mantiene)
- Cambiar el formato de las notificaciones

## Decisions

### Decision 1: Seguir el patrón Docker (override via source order)

**Alternativas consideradas:**
- **Condicional simple** (`if ZSH_NOTIFY_PROVIDER = noti`) — funciona pero no escala para nuevos proveedores
- **Function dispatch** (`${+functions[adapter::send]}`) — más complejo, el patrón Docker es más claro

**Elección:** Override via source order (como Docker):

```zsh
# 1. OS-level define la función genérica
notify::internal::popup { notify::adapter::send "$@" }

# 2. Adapter-specific (last source wins)
# config/adapter/noti.zsh redefine notify::adapter::send
```

### Decision 2: Variable ZSH_NOTIFY_PROVIDER con valores específicos

```zsh
ZSH_NOTIFY_PROVIDER="auto"    # auto-detect (default)
ZSH_NOTIFY_PROVIDER="noti"    # solo noti
ZSH_NOTIFY_PROVIDER="notify-send"  # solo notify-send
```

**Razón:** Simple, válido, extensible. Nuevos proveedores solo agregan un case.

### Decision 3: Adapter contract mínimo

Cada adapter define 4 funciones:

| Función | Obligatoria | Descripción |
|---------|-------------|-------------|
| `notify::adapter::send` | Sí | Enviar notificación |
| `notify::adapter::install` | Sí | Instalar el tool |
| `notify::adapter::render` | No (si no aplica) | Generar config |
| `notify::adapter::sync` | No (si no aplica) | Sincronizar data |

**Razón:** Suficiente para cubrir todos los proveedores actuales y futuros.

## Risks / Trade-offs

- **[Risk]** Breaking change si alguien llama `notify::noti::send` directamente → **Mitigation:** Mantener funciones públicas como wrappers al adapter
- **[Trade-off]** Más archivos → **Mitigation:** Mejor separación, escalable

## Migration Plan

1. Crear directorios `config/adapter/` e `internal/adapter/`
2. Mover `config/noti.zsh` → `config/adapter/noti.zsh`
3. Mover `config/notify-send.zsh` → `config/adapter/notify-send.zsh`
4. Mover `internal/noti.zsh` → `internal/adapter/noti.zsh`
5. Mover `internal/notify-send.zsh` → `internal/adapter/notify-send.zsh`
6. Actualizar `config/main.zsh` con dispatch de adapters
7. Actualizar `internal/main.zsh` con dispatch de adapters
8. Reemplazar OS popups con dispatch al adapter
9. Limpiar archivos viejos

**Rollback:** Git revert del cambio completo.
