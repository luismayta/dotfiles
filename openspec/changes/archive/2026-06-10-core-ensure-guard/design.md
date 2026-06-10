## Context

Actualmente 10+ módulos en `zsh/modules/` usan este patrón manual al cargarse:

```zsh
if ! core::exists <tool>; then
  core::install <tool>
fi
```

Esto duplica lógica que pertenece al core. Cada módulo copia exactamente el mismo guard cambiando solo el nombre del tool. `zsh/core/pkg/base.zsh` ya expone `core::exists` y `core::install` como wrappers públicos. Este cambio añade `core::ensure <tool>` como la combinación de ambos.

## Goals / Non-Goals

**Goals:**
- Proveer `core::ensure <tool>` como el guard canónico en `zsh/core/pkg/base.zsh`
- Migrar los 10+ módulos que usan el patrón inline a `core::ensure`
- Mantener compatibilidad total — no se rompen llamadas existentes a `core::exists` o `core::install`

**Non-Goals:**
- No se modifica la lógica interna de `core::exists` o `core::install`
- No se añaden nuevas dependencias
- No se refactoriza el post_install bookend ni ningún otro patrón
- No se tocan version managers (fnm, goenv, pyenv, rust) — se descartaron por variabilidad futura

## Decisions

| Decisión | Opción elegida | Alternativa considerada | Razón |
|---|---|---|---|
| Implementación | `core::ensure() { core::exists "$1" \|\| core::install "$1" }` | Variante con salida temprana, flags opcionales | La forma más simple. El 100% de los casos de uso son idénticos: exists? si no, install. Sin flags. |
| Lugar | `zsh/core/pkg/base.zsh` | `zsh/core/internal/api.zsh` | Sigue el patrón existente: los wrappers públicos van en `pkg/`, la impl en `internal/`. Pero para una función tan simple (~2 líneas reales) no justifica un archivo separado. |
| Nombre | `core::ensure` | `core::guard`, `core::require` | `ensure` comunica intención: "asegúrate de que esto esté instalado". Consistente con el naming `core::exists`/`core::install`. |

## Risks / Trade-offs

- **[Bajo] Algún módulo podría necesitar behaviour distinto** (e.g., mensaje personalizado antes de instalar, o no instalar automáticamente). → `core::ensure` es opt-in. Los módulos que necesiten comportamiento distinto siguen usando `core::exists` + `core::install` manualmente como hoy.
- **[Bajo] Migración manual de 10+ archivos** → Cada cambio es mecánico y verificable: reemplazar `if ! core::exists X; then core::install X; fi` por `core::ensure X`. Se puede auditar con grep.
- **[Muy bajo] Alguien podría usar `core::ensure` para tools que no existen en Homebrew** → El comportamiento es idéntico al código que reemplaza; no es nuevo riesgo.

## Migration Plan

1. Añadir `core::ensure` a `zsh/core/pkg/base.zsh`
2. Por cada módulo que use el patrón, reemplazar el guard inline por `core::ensure <tool>`
3. Verificar con `zsh -n` que la sintaxis es correcta
4. Commit

Rollback: Revertir el commit o, si solo un módulo falla, revertir la llamada a `core::ensure` en ese módulo manteniendo el guard manual.