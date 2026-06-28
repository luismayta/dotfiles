## Why

El archivo `starship.toml` (271 líneas) ha crecido orgánicamente sin una estructura coherente: mezcla estilos de formato, íconos emoji con Nerd Fonts, tiene configuraciones muertas (battery, time, localip deshabilitadas con código comentado) y módulos custom inline que podrían simplificarse. Esto dificulta el mantenimiento y la legibilidad. El refactor busca unificar criterios, eliminar ruido y dejar el archivo más fácil de entender y modificar.

## What Changes

- **Organización por secciones**: Agrupar módulos relacionados con comentarios claros (Core, Git, Cloud, Lenguajes, etc.)
- **Consistencia de formato**: Unificar cómo se declaran `format`, `style` y `symbol` en todos los módulos
- **Limpieza de configuraciones muertas**: Remover bloques `disabled = true` que arrastran config innecesaria (battery display, time, localip)
- **Estandarización de íconos**: Definir si se usa Nerd Font o emoji de forma consistente, no mezclado
- **Optimización de custom modules**: Los `[custom.giturl]` y `[custom.githash]` corren scripts bash en cada prompt — evaluar si se pueden simplificar o reemplazar con módulos nativos de starship
- **Python section**: Verificar `pyenv_version_name = true` post-migración a módulo `python`

## Capabilities

### New Capabilities
- `prompt-organization`: Estructura lógica del archivo con secciones agrupadas y comentarios de cabecera
- `format-consistency`: Patrón uniforme para `format`, `style` y `symbol` en todos los módulos
- `config-cleanup`: Remoción de configuraciones muertas y código comentado
- `custom-module-refactor`: Optimización de los módulos custom `[custom.*]` (giturl, githash, proxy)

### Modified Capabilities
- *(ninguna — no hay spec existente para starship)*

## Impact

- Archivo: `zsh/modules/starship/data/starship.toml`
- Ningún cambio funcional en el prompt — solo reorganización y limpieza
- Los custom modules `giturl` y `githash` podrían cambiar su implementación interna pero el output visual debe mantenerse idéntico
