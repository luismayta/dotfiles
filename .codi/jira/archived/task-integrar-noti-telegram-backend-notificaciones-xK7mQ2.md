# Task: Integrar noti con Telegram como backend de notificaciones

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Reemplazar notify-send por noti para enviar notificaciones a Telegram vía hooks automáticos
- component: Notifications
- labels: []
- parentEpic:
- issueKey: HAD-96

## Scenario

El usuario necesita recibir notificaciones en su teléfono cuando un comando de larga duración termina. Actualmente el módulo notify usa notify-send para notificaciones de escritorio, pero se requiere notificaciones móviles vía Telegram usando noti como backend.

### Acceptance Tests

1. noti se instala correctamente (homebrew o binario pre-compilado)
2. Se configura noti con Telegram como servicio de notificación
3. El hook preexec/precmd activa noti automáticamente para comandos >10s
4. La notificación llega a Telegram con título del comando y mensaje descriptivo
5. Se mantiene la compatibilidad con macOS (sin notify-send)
6. El sonido de notificación se mantiene vía mpg123

### Sources

- https://codeberg.org/roble/noti
- https://github.com/luismayta/dotfiles.git