# HAD-96: Reemplazar notify-send por noti para enviar notificaciones a Telegram vía hooks automáticos

## Contenido Fuente

### Scenario

El usuario necesita recibir notificaciones en su teléfono cuando un comando de larga duración termina. Actualmente el módulo notify usa notify-send para notificaciones de escritorio, pero se requiere notificaciones móviles vía Telegram usando noti como backend.

### Acceptance Tests

- noti se instala correctamente (homebrew o binario pre-compilado)
- Se configura noti con Telegram como servicio de notificación
- El hook preexec/precmd activa noti automáticamente para comandos >10s
- La notificación llega a Telegram con título del comando y mensaje descriptivo
- Se mantiene la compatibilidad con macOS (sin notify-send)
- El sonido de notificación se mantiene vía mpg123

### Sources

- https://codeberg.org/roble/noti
- https://github.com/luismayta/dotfiles.git

---

## Enriquecimiento

Status: skipped_no_context_queries

### CodeGraph Enrichment

Status: partial

> CodeGraph no indexa archivos zsh/shell. Contexto estructurado derivado de lecturas directas del módulo notify existente.

#### Estructura del módulo notify (archivos relevantes)

**plugin.zsh** — Loader principal
- Hooks: `preexec → notify::command::store`, `precmd → notify::command::completed`
- Variables: `_ZSH_NOTIFY_TIME_THRESHOLD=10`, `_ZSH_NOTIFY_RE_SKIP_COMMANDS`, `_ZSH_NOTIFY_TERMINAL_BUNDLE`

**config/base.zsh** — Configuración
- `ZSH_NOTIFY_ENABLED=true`, paths de assets, sound theme `r2d2`

**internal/base.zsh** — Core functions
- `notify::internal::command::store` — almacena comando y timestamp
- `notify::internal::command::completed` — calcula timediff, llama success/error
- `notify::internal::success` — popup + play sound
- `notify::internal::error` — popup + play sound
- `notify::internal::popup` — stub (override por OS)

**internal/linux.zsh** — Backend Linux
- `notify::internal::popup` — usa `notify-send --urgency=low -i`

**pkg/base.zsh** — Public API
- Wrappers: `notify::success`, `notify::error`, `notify::play`, `notify::popup`, `notify::command::completed`, `notify::command::store`

---

## Guía de Implementación: Three-Layer Architecture

El notify module YA sigue este patrón (config → internal → pkg). La integración de noti DEBE mantener esta arquitectura.

### Capas

| Capa | Responsabilidad | Directorio |
|------|----------------|------------|
| **config** | Variables de entorno, detección de OS, paths | `config/` |
| **internal** | Implementación privada, lógica de negocio | `internal/` |
| **pkg** | API pública, wrappers para otros módulos | `pkg/` |

### Convenciones de Nombres

- Internas: `notify::noti::internal::<verb>` (ej. `notify::noti::internal::send`)
- Públicas: `notify::noti::<verb>` (ej. `notify::noti::send`)
- Variables config: `ZSH_NOTIFY_NOTI_<VAR>` (ej. `ZSH_NOTIFY_NOTI_TOKEN`)

### Guard Pattern

Toda función internal DEBE verificar `core::exists noti` antes de proceder y retornar temprano si no está instalado.

### Shell Integration

noti NO provee shell hooks (es CLI standalone). Patrón correcto: **PATH-only** — solo agregar noti al PATH via `path::prepend` en la capa de carga.

### Registro

Agregar `noti` al array `DEVOPS_TOOLS` (o equivalente en notify) en `config/base.zsh`.

### Configuración noti para Telegram

```yaml
# ~/.config/noti/noti.yaml
telegram:
  token: "$ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN"
  chatId: "$ZSH_NOTIFY_NOTI_TELEGRAM_CHATID"
```

Las variables se definen en `config/linux.zsh` (o `config/base.zsh`).

### Testing

1. **Load test:** `source plugin.zsh` sin errores
2. **Function verification:** `which notify::noti::send` retorna función
3. **Integration test:** comando largo >10s envía notificación a Telegram

### Checklist

- [ ] config/ define variables de entorno (token, chatId)
- [ ] internal/ implementa `send` con guard `core::exists noti`
- [ ] pkg/ expone wrapper público
- [ ] Variable naming sigue patrón `ZSH_NOTIFY_NOTI_*`
- [ ] Función naming sigue patrón `notify::noti::*`
- [ ] `core::exists` check presente en todas las funciones internal
- [ ] Message functions usan `message_info` / `message_success` / `message_error`

---

## Instrucciones

Genera una especificación OpenSpec en markdown, en inglés, con trazabilidad a HAD-96.

Rules:
- Usa SOLO la información proporcionada — NO inventes información
- Convierte acceptance tests en requerimientos usando MUST / SHOULD / MAY
- Incluye file paths del enrichment como contexto de código relevante
- Sigue la arquitectura three-layer (config → internal → pkg) documentada arriba
- Aplica naming conventions y guard patterns del tool implementation guide
