## 1. Setup e Instalación

- [x] 1.1 Verificar que noti está instalado (`core::exists noti`) o instalarlo (homebrew/AUR/nix)
- [x] 1.2 Crear `~/.config/noti/noti.yaml` con configuración de Telegram
- [x] 1.3 Definir variables de entorno `ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN` y `ZSH_NOTIFY_NOTI_TELEGRAM_CHATID` en `.zshrc.local`

## 2. Config Layer

- [x] 2.1 Agregar variables `ZSH_NOTIFY_NOTI_ENABLED`, `ZSH_NOTIFY_NOTI_TELEGRAM_TOKEN`, `ZSH_NOTIFY_NOTI_TELEGRAM_CHATID` en `config/base.zsh`
- [x] 2.2 Crear `config/linux.zsh` con config de noti para Linux
- [x] 2.3 Crear `config/osx.zsh` con config de noti para macOS
- [x] 2.4 Agregar función `notify::noti::internal::config` que genera `~/.config/noti/noti.yaml` desde variables de entorno

## 3. Internal Layer

- [x] 3.1 Crear `internal/noti.zsh` con función `notify::noti::internal::send` (guard `core::exists noti`)
- [x] 3.2 Implementar `notify::noti::internal::send` que ejecuta `noti -t "<command>" -m "<message>"`
- [x] 3.3 Modificar `internal/linux.zsh` para usar noti como backend primario con fallback a `notify-send`
- [x] 3.4 Modificar `internal/osx.zsh` para usar noti como backend primario con fallback a `osascript`
- [x] 3.5 Actualizar `internal/base.zsh` para llamar `notify::noti::internal::send` desde `notify::internal::success` y `notify::internal::error`

## 4. Pkg Layer

- [x] 4.1 Crear `pkg/noti.zsh` con wrapper público `notify::noti::send`
- [x] 4.2 Actualizar `pkg/main.zsh` para cargar `pkg/noti.zsh`
- [x] 4.3 Verificar que `notify::noti::send` está disponible públicamente

## 5. Plugin Loader

- [x] 5.1 Actualizar `plugin.zsh` para cargar configuración noti
- [x] 5.2 Agregar guard `ZSH_NOTIFY_NOTI_ENABLED` para habilitar/deshabilitar noti
- [x] 5.3 Generar config de noti al cargar el módulo si no existe `~/.config/noti/noti.yaml`

## 6. Testing

- [ ] 6.1 Test de carga: `source plugin.zsh` sin errores
- [ ] 6.2 Test de función: `which notify::noti::send` retorna función
- [ ] 6.3 Test de integración: ejecutar `sleep 15 && echo done` y verificar llegada a Telegram
- [ ] 6.4 Test de fallback: deshabilitar noti y verificar que notify-send funciona
- [ ] 6.5 Test de sonido: verificar que `mpg123` se ejecuta después de la notificación

## 7. Documentación

- [ ] 7.1 Actualizar `README.md` del módulo notify con nueva funcionalidad
- [ ] 7.2 Documentar variables de entorno requeridas
- [ ] 7.3 Agregar noti como referencia en `openspec/specs/tool-implementation-guide/spec.md`
