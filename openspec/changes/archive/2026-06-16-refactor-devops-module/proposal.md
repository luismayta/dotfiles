## Why

El módulo `zsh/modules/devops` contiene configuraciones duplicadas que ya existen en `zsh/core`, como la variable `DEVOPS_KUBECTL_KUBE_EDITOR` que redefine el editor mientras core ya define `$EDITOR`. También declara paths propios (`DEVOPS_KUBECTL_LOCAL_PATH_BIN`) cuando core ya tiene `LOCAL_PATH_BIN`, y maneja paths del sistema (`path::append`/`path::prepend`) manualmente en vez de reutilizar los helpers de core. Esta duplicación crea desalineación: cambios en core no se reflejan en devops, y viceversa.

## What Changes

- **Eliminar `DEVOPS_KUBECTL_KUBE_EDITOR`** y reemplazar su uso por `$EDITOR` (definido en `zsh/core/config/env.zsh`)
- **Eliminar `DEVOPS_KUBECTL_LOCAL_PATH_BIN="/usr/local/bin"`** y reutilizar `LOCAL_PATH_BIN` de core
- **Eliminar `DEVOPS_ARCHITECTURE_NAME`** — no se usa fuera del módulo y es derivable de `$(uname -m)`
- **Eliminar `DEVOPS_APPLICATION_PATH="/Applications"`** — hardcodeado a macOS, no referenciado fuera
- **Reemplazar manipulaciones manuales de `PATH`** por `path::append`/`path::prepend` de core
- **Mantener las funciones `message_*`** que ya se delegan en core — están correctas
- **Consolidar variables de Kubernetes paths** que estén duplicadas o redundantes
- **Estandarizar nombres de constantes** eliminando prefijo `DEVOPS_` donde la variable es local al módulo y no se exporta

## Capabilities

### New Capabilities
- `core-alignment`: Alinear variables de entorno, paths y helpers del módulo devops con los definidos en `zsh/core`, eliminando duplicación y delegando en core como fuente única de verdad.

### Modified Capabilities
- *(none — no existing specs in this repo)*

## Impact

- **Archivos a modificar**: `zsh/modules/devops/config/base.zsh`, `zsh/modules/devops/config/osx.zsh`, `zsh/modules/devops/config/linux.zsh`, `zsh/modules/devops/internal/kubectl.zsh`, `zsh/modules/devops/internal/tfenv.zsh`, `zsh/modules/devops/pkg/k9s.zsh`, `zsh/modules/devops/pkg/kubectl.zsh`
- **Variables eliminadas**: `DEVOPS_KUBECTL_KUBE_EDITOR`, `DEVOPS_KUBECTL_LOCAL_PATH_BIN`, `DEVOPS_ARCHITECTURE_NAME`, `DEVOPS_APPLICATION_PATH`
- **Dependencias afectadas**: Ninguna — todos los consumidores de estas variables son internos al módulo devops
- **Riesgo bajo**: Cambios puramente de limpieza/estandarización; no hay cambios en API pública del módulo
