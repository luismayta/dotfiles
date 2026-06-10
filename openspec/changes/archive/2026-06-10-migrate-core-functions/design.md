## Context

`zsh/core/pkg/docker.zsh` contiene 7 funciones que ejecutan herramientas dentro de contenedores Docker. El módulo `zsh/modules/devops/` ya alberga tooling similar: helm, k9s, kubectl, tfenv. La migración es directa: mover el archivo y actualizar los sources.

Estructura actual de devops/pkg/:
```
devops/pkg/
  base.zsh
  helm.zsh
  k9s.zsh
  kubectl.zsh
  main.zsh      ← sourcea todos los pkg/*.zsh
  tfenv.zsh
```

## Goals / Non-Goals

**Goals:**
- Migrar `docker.zsh` completo a `zsh/modules/devops/pkg/docker.zsh`
- Actualizar `devops/pkg/main.zsh` para sourcear docker.zsh
- Eliminar `zsh/core/pkg/docker.zsh` y su source en `core/pkg/main.zsh`
- Cero cambios en API pública

**Non-Goals:**
- No mover alias.zsh (pertenece a core)
- No mover linux.zsh (pertenece a core)
- No mover helper/core.zsh (pertenece a core)
- No crear módulos nuevos

## Decisions

1. **docker.zsh → devops/pkg/docker.zsh**: Sigue el naming existente del módulo (helm.zsh, k9s.zsh, kubectl.zsh, tfenv.zsh). Cada archivo agrupa funciones por herramienta.

2. **No se requiere linux.zsh ni osx.zsh**: Las funciones docker corren en Docker, no necesitan implementación por plataforma.

3. **No mover a aliases/**: docker.zsh define funciones, no alias. El módulo devops es el lugar correcto.

## Risks / Trade-offs

- **Riesgo mínimo**: docker.zsh no tiene dependencias de core (solo llama a `docker`). Move seguro.
