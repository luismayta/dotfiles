## Why

El módulo ghq actualmente deriva `ZSH_GHQ_ROOT` ejecutando `ghq root` al cargar, con fallback genérico `${PROJECTS:-${HOME}/projects}`. Esto es frágil: si `ghq` no está instalado en el primer arranque (o el usuario no configuró `ghq.root`), el root apunta a una ruta que no es la real del workspace. Queremos un default determinista: `GHQ_ROOT` debe resolver a `${HOME}/Projects/src`, que ya es el valor canónico de `PROJECTS` definido en `zsh/zshenv`.

## What Changes

- El default de `ZSH_GHQ_ROOT` en `zsh/modules/ghq/config/base.zsh` pasa a ser `${HOME}/Projects/src` en lugar del fallback genérico.
- El alias backward-compat `GHQ_ROOT` sigue apuntando al canónico `ZSH_GHQ_ROOT`, por lo que `GHQ_ROOT` también resuelve a `${HOME}/Projects/src`.
- Se conserva la sobreescritura por parte del usuario: si `GHQ_ROOT` o `ZSH_GHQ_ROOT` ya están definidos en el entorno, se respetan (patrón `${VAR:-default}`).
- Se elimina la dependencia del cálculo en tiempo de carga de `ghq root` para el default (la resolución real de `ghq root` puede seguir usándose solo si la variable no fue seteada explícitamente por el usuario).

## Capabilities

### New Capabilities

### Modified Capabilities
- `ghq-module`: el requisito "Variables de entorno con prefijo ZSH_GHQ_" cambia el valor por defecto de `ZSH_GHQ_ROOT`/`GHQ_ROOT` a `${HOME}/Projects/src`, determinista e independiente de la instalación/estado de `ghq` en el primer arranque.

## Impact

- **Código**: `zsh/modules/ghq/config/base.zsh` (líneas ~8-9 y alias L23); posible ajuste en `pkg/base.zsh` si referencia el fallback genérico.
- **Documentación**: `zsh/modules/ghq/README.yaml` (y `README.md` regenerado vía `task readme`) si documentan el default de `GHQ_ROOT`.
- **Dependencias**: ninguna nueva; reutiliza `PROJECTS`/`${HOME}` ya disponibles.
- **Compatibilidad**: no rompe la API pública (`ghq::install`, `ghq::sync`, `ghq::setup`) ni el contrato de prefijos `ZSH_GHQ_`/aliases `GHQ_*`.
