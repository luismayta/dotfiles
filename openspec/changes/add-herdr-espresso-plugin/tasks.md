## 1. Registro del plugin

- [x] 1.1 Agregar `Hanyang-Li/herdr-espresso` al array `ZSH_HERDR_INSTALL_PLUGINS` en `zsh/modules/herdr/config/plugins.zsh` (en la categoría correspondiente, formato `owner/repo`)
- [x] 1.2 Verificar que al recargar zsh el plugin se instala automáticamente: `herdr plugin list` incluye `herdr-espresso`

## 2. Integración con la UI de herdr

- [x] 2.1 Agregar keybinding `espresso.toggle` en `zsh/modules/herdr/data/config.toml` (bloque `[[keys.command]]` con `type = "plugin_action"` y `command = "espresso.toggle"`, verificando que la tecla no colisione con las existentes)
- [x] 2.2 Configurar el marcador `$espresso` en `[ui.sidebar.agents]` de `zsh/modules/herdr/data/config.toml` (token `$espresso` en `rows`)

## 3. Dependencia del entorno (CLI espresso) — implementada en el módulo

- [x] 3.1 Implementar `herdr::internal::espresso::install` en `zsh/modules/herdr/internal/install.zsh` (instalador oficial vía `curl | sh`, idempotente, solo macOS)
- [x] 3.2 Agregar guard de auto-instalación en `zsh/modules/herdr/plugin.zsh` (OSTYPE darwin + flag `ZSH_HERDR_ESPRESSO_ENABLED`) y variable de config en `config/base.zsh`
- [x] 3.3 Implementar `herdr::espresso::daemon::install` (función manual, requiere sudo) con wrapper público en `pkg/base.zsh`
- [x] 3.4 Verificar que al recargar zsh en macOS el CLI espresso se instala automáticamente

## 4. Verificación funcional

- [ ] 4.1 Verificar el toggle del monitoreo en un panel de agente: la Mac permanece despierta mientras el agente trabaja y puede dormir cuando se vuelve inactivo
- [ ] 4.2 Verificar que el marcador `espresso` aparece en la barra lateral junto al panel monitoreado
- [ ] 4.3 Verificar que el toggle en un panel de shell plano muestra notificación de rechazo y no activa el monitoreo