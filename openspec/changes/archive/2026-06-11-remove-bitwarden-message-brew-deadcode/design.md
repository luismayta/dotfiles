## Context

Como parte de HAD-62 (`standardize-message-vars`), todas las variables `*_MESSAGE_BREW` de módulos se centralizaron en `CORE_MESSAGE_BREW` en `zsh/core/config/env.zsh`. Los módulos que fueron limpiados en ese cambio incluyen: aliases, clean, devops, git, goenv, notify, pazi, scmbreeze, starship.

Sin embargo, 4 módulos quedaron con su `*_MESSAGE_BREW` definida pero nunca referenciada: bitwarden, ssh, tmux, docker. Posiblemente fueron creados o migrados después del cleanup original.

## Goals / Non-Goals

**Goals:**
- Eliminar las 4 variables `*_MESSAGE_BREW` dead code de módulos
- Dejar `CORE_MESSAGE_BREW` como la única fuente de verdad para mensajes brew

**Non-Goals:**
- No modificar `CORE_MESSAGE_BREW` ni su definición en `zsh/core/config/env.zsh`
- No refactorizar la estructura de los módulos

## Decisions

| Decision | Rationale |
|---|---|
| Eliminación directa, sin deprecación | Cero consumidores → no hay nada que migrar. Si algún script externo referencia estas variables (extremadamente improbable), sería un bug propio. |
| Coherencia con HAD-62 | Sigue el mismo patrón ya aplicado a los otros 9 módulos. |

## Risks / Trade-offs

- **Ninguno identificado**. Las 4 variables son dead code comprobado. El grep confirma que ningún archivo `.zsh` dentro o fuera de los módulos las referencia. `CORE_MESSAGE_BREW` está activo y usado por 4 consumidores (`api.zsh`, `osx.zsh`, `eza.zsh`, `git/base.zsh`).