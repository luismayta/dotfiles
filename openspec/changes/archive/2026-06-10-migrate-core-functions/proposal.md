## Why

`zsh/core/pkg/docker.zsh` contiene wrappers Docker que pertenecen al dominio de devops (awscli, komiser, youtube-dl, etc.). El módulo `zsh/modules/devops/` ya existe con la misma estructura (helm, k9s, kubectl, tfenv). Migrar docker.zsh ahí consolida todo el tooling devops en un solo módulo.

## What Changes

- Migrar `zsh/core/pkg/docker.zsh` → `zsh/modules/devops/pkg/docker.zsh`
- Las funciones preservan firma y comportamiento exacto
- `zsh/core/pkg/docker.zsh` se elimina; `zsh/core/pkg/main.zsh` deja de sourcearlo
- No se tocan `alias.zsh`, `linux.zsh`, ni `helper/core.zsh` — pertenecen a core

## Capabilities

### New Capabilities
- (ninguno — docker se absorbe en devops existente)

### Modified Capabilities
- `devops`: Nuevo archivo `pkg/docker.zsh` con funciones docker migradas desde core

## Impact

- **`zsh/core/pkg/`**: Se elimina docker.zsh (único archivo con dependencia externa Docker)
- **`zsh/modules/devops/`**: Nuevo `pkg/docker.zsh` siguiendo el naming existente (helm.zsh, k9s.zsh, kubectl.zsh, tfenv.zsh)
- **Riesgo mínimo**: Solo se mueve código, sin cambios de API