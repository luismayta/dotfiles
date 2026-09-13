# Task: Agregar plugin herdr-espresso al módulo herdr

## Issue Metadata

- projectKey: RD
- issueType: Task
- summary: Registrar plugin herdr-espresso en módulo herdr de dotfiles para mantener Mac despierta con agente IA
- component: 
- labels: []
- parentEpic: 
- issueKey: RD-180
- jpdSource: 

## Scenario

El módulo herdr de dotfiles (zsh/modules/herdr/) gestiona plugins de forma declarativa a través del array ZSH_HERDR_INSTALL_PLUGINS en config/plugins.zsh, que se instalan automáticamente al cargar el módulo.

herdr-espresso es un plugin que mantiene la Mac despierta mientras el agente de codificación de un panel está trabajando activamente, y permite que la Mac entre en suspensión cuando el agente se vuelve inactivo. Requisitos: macOS, herdr 0.7.0+ y CLI espresso en PATH.


### Acceptance Tests

- [ ] Registrar `Hanyang-Li/herdr-espresso` en el array `ZSH_HERDR_INSTALL_PLUGINS` de `zsh/modules/herdr/config/plugins.zsh`
- [ ] Verificar que al recargar el módulo zsh el plugin se instala automáticamente (`herdr plugin list` incluye herdr-espresso)
- [ ] Verificar que el CLI espresso está instalado y disponible en PATH
- [ ] (Opcional) Configurar keybinding `espresso.toggle` en `data/config.toml` para activar/desactivar el monitoreo


### Sources

- https://github.com/Hanyang-Li/herdr-espresso

- https://github.com/luismayta/dotfiles.git