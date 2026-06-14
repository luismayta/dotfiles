## 1. Configurar input del teclado en general.lua

- [x] 1.1 Agregar bloque `hl.input({ kb_repeat_rate = 35; kb_repeat_delay = 200 })` en la sección INPUT de `zsh/modules/hyprland/data/configs/general.lua`

## 2. Sincronizar y verificar

- [x] 2.1 Ejecutar `hyprland::sync` (rsync data/ → ~/.config/hypr/) para copiar el cambio
- [x] 2.2 Recargar configuración con `hyprctl reload`
- [x] 2.3 Verificar que los valores se aplicaron: `hyprctl getoption input:repeat_rate` → 35 y `hyprctl getoption input:repeat_delay` → 200
- [x] 2.4 Probar que mantener presionada una tecla (ej. en terminal o editor) tenga respuesta inmediata similar a macOS
