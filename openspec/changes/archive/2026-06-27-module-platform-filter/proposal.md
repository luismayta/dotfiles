## Why

Cada módulo de zsh bajo `zsh/modules/` se carga siempre que exista su `plugin.zsh`. Módulos como `hyprland` (Linux-only) se sourcean en macOS y dependen de stubs no-op para no hacer nada — código muerto que se ejecuta en cada shell. No hay una forma estándar de declarar "este módulo solo funciona en X plataforma". La única vía es `ZSH_DISABLED_MODULES` en `~/.customrc`, manual y por máquina.

Necesitamos un patrón uniforme y configurable para que cada módulo pueda auto-deshabilitarse según la plataforma, sin tocar el loader.

## What Changes

- Cada módulo declara `ZSH_<MODULE>_ENABLED=true` en su `config/base.zsh`
- Los configs de plataforma (`config/osx.zsh` o `config/linux.zsh`) pueden override a `false` cuando el módulo no aplique en ese SO
- Cada `plugin.zsh` añade un guard `$ZSH_<MODULE>_ENABLED || return` después de sourcear su config
- El loader no se modifica — el `return` dentro del sourced file hace que el loop del loader continúe con el siguiente módulo
- El usuario puede override desde `~/.customrc` seteando la variable antes de que se carguen los módulos

## Capabilities

### New Capabilities

- `module-enabled-guard`: Patrón completo — variable `ZSH_<MODULE>_ENABLED` en cascade `base.zsh` → `osx.zsh`/`linux.zsh` + guard `$ZSH_<MODULE>_ENABLED || return` en `plugin.zsh`
- `module-platform-audit`: Auditoría de todos los módulos para determinar qué plataforma aplica cada uno

### Modified Capabilities

- *(none — no existing specs to modify)*

## Impact

- Cada `config/base.zsh` → +1 línea (`ZSH_<MODULE>_ENABLED=true`)
- Cada `plugin.zsh` → +1 línea (`$ZSH_<MODULE>_ENABLED || return` tras source config)
- `config/osx.zsh` o `config/linux.zsh` → +1 línea en los módulos restringidos
- Loader en `zsh/zshrc` → **sin cambios**
- `~/.customrc` → sigue funcionando, más override granular disponible
