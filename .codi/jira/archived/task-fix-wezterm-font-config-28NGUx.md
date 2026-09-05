# Task: Fix WezTerm font configuration error

## Issue Metadata

- projectKey: HAD
- issueType: Task
- summary: Eliminar restricción de peso Light en configuración de fuentes de WezTerm
- component: DevOps
- labels: [wezterm, font, config]
- parentEpic: 
- issueKey: HAD-107
- jpdSource: 

## Scenario

WezTerm mostraba un error indicando que no podía cargar la fuente "JetBrainsMono Nerd Font" con peso "Light". La configuración en `fonts.lua` especificaba `weight = "Light"` pero la variante no estaba disponible en el sistema, causando que WezTerm usara fallbacks y la terminal no se renderizara correctamente.

**Archivo afectado:** `zsh/modules/wezterm/data/config/fonts.lua`

**Causa raíz:** La línea `weight = "Light"` en la configuración de fuentes requería una variante de fuente que no estaba instalada.

**Solución aplicada:** Eliminar la línea `weight = "Light"` para que WezTerm use el peso por defecto (Regular).


### Acceptance Tests

1. El archivo `fonts.lua` no debe contener `weight = "Light"`
2. WezTerm debe cargar la fuente JetBrainsMono Nerd Font sin errores
3. La terminal debe renderizar correctamente con la fuente por defecto


### Sources

- https://wezfurlong.org/wezterm/config/fonts.html

- https://github.com/luismayta/dotfiles.git