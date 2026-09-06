## Why

Los módulos zsh usan el operador `:=` (asignación condicional) para establecer valores por defecto. Sin embargo, en los archivos OS-específicos (`osx.zsh`, `linux.zsh`) se requiere **sobreescribir** estos valores para plataformas específicas (ej: `hx` en macOS vs `helix` en Linux). El operador `:=` no sobreescribe valores ya existentes, causando que los overrides de plataforma fallen silenciosamente.

**Ejemplo concreto:** En helix, `base.zsh` establece `ZSH_HELIX_PACKAGE_NAME=helix`, pero `osx.zsh` intenta cambiarlo a `hx` usando `:=` — la asignación falla porque la variable ya tiene valor.

## What Changes

- **Auditar** todos los módulos zsh para identificar patrones de asignación incorrectos
- **Corregir** archivos OS-específicos para usar `=` (asignación incondicional) cuando el override es obligatorio
- **Documentar** el patrón correcto: `:=` para defaults, `=` para overrides de plataforma
- **Verificar** que nvim y helix (los dos módulos afectados) funcionen correctamente

## Capabilities

### New Capabilities

- `zsh-variable-assignment-patterns`: Patrón documentado para asignación de variables en módulos zsh — cuándo usar `:=` vs `=`

### Modified Capabilities

<!-- No hay capacidades existentes que cambiar -->

## Impact

- **Archivos afectados:**
  - `zsh/modules/helix/config/osx.zsh` (ya corregido)
  - `zsh/modules/nvim/config/osx.zsh` (necesita revisión)
  - `zsh/modules/nvim/config/base.zsh` (verificar patrón)
  - `zsh/modules/helix/config/base.zsh` (verificar patrón)

- **Comportamiento:** Los usuarios en macOS que tengan helix o nvim instalados via Homebrew verán que los binarios se detectan correctamente

- **Riesgo:** Bajo — cambio en asignación de variables de configuración, no en lógica de negocio
