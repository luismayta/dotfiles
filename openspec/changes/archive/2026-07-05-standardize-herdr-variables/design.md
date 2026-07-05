## Context

El módulo herdr de dotfiles define ~8 variables de entorno distribuidas en 5 archivos (`config/base.zsh`, `config/linux.zsh`, `config/osx.zsh`, `internal/base.zsh`, `pkg/base.zsh`, `pkg/helper.zsh`, `plugin.zsh`). Actualmente usan tres formatos de prefijo distintos:

- `HERDR_*`: sin namespace (3 variables)
- `ZSH_HRD_*`: abreviación inconsistente (1 variable)
- `ZSH_HERDR_*`: formato estándar (variables ya migradas)

Ninguna variable se referencia fuera del módulo `zsh/modules/herdr/`, lo que hace el rename seguro y sin impacto externo.

## Goals / Non-Goals

**Goals:**
- Unificar todas las variables del módulo herdr bajo el prefijo `ZSH_HERDR_*`
- Mantener backward compatibility durante la transición (export del nombre viejo como alias)

**Non-Goals:**
- No cambiar funcionalidad, lógica, ni comportamiento
- No migrar variables externas a herdr (e.g., `HERDR_CONFIG_PATH` del binario herdr — eso ya se resolvió en el fix anterior)
- No crear un sistema general de deprecación de variables

## Decisions

| Decisión | Opción elegida | Alternativas | Razón |
|---|---|---|---|
| Estrategia de rename | `replaceAll` por variable + verificación manual | Editar cada ocurrencia individual | `replaceAll` es más rápido y preciso; el riesgo es bajo porque las cadenas son únicas (ej. `HERDR_PACKAGE_NAME` no aparece en otro contexto) |
| Backward compatibility | Mantener `export HERDR_PACKAGE_NAME=$ZSH_HERDR_PACKAGE_NAME` como alias | No mantener compatibilidad | Evita romper shells existentes que ya tienen `$HERDR_PACKAGE_NAME` expandido en funciones cargadas; el alias es temporal y se puede eliminar en el próximo ciclo de cleanup |
| Orden de migración | 1) `config/base.zsh` (definiciones) → 2) referencias en `internal/` y `pkg/` → 3) `plugin.zsh` | Cambiar todo en paralelo | Las definiciones deben actualizarse primero antes que sus consumidores |
| Manejo de `ZSH_HRD_*` | Renombrar completo a `ZSH_HERDR_*` | Dejar `HRD` como abreviatura | Inconsistente con el resto del módulo; `HERDR` es más legible |

## Risks / Trade-offs

- **Riesgo: Shell ya tiene `$HERDR_PACKAGE_NAME` expandido** → Mitigación: alias backward-compatible evita ruptura inmediata
- **Riesgo: Typo en el rename** → Mitigación: las referencias son directas (sin string interpolation compleja); verificación con `grep` post-cambio
- **Trade-off**: El alias backward-compatible añade una línea extra por variable, pero la eliminación futura es trivial (buscar y borrar)
