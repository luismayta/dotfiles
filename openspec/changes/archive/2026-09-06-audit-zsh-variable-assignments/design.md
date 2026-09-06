## Context

Los módulos zsh (helix, nvim) siguen una estructura de capas: `config/base.zsh` → `config/{osx,linux}.zsh`. El operador `:=` en zsh asigna solo si la variable es null o unset, lo cual es correcto para defaults pero incorrecto para overrides de plataforma.

**Problema actual:** `osx.zsh` usa `:=` para variables que DEBEN sobreescribir el default, causando que el valor de `base.zsh` persista en macOS.

## Goals / Non-Goals

**Goals:**
- Establecer patrón claro: `:=` para defaults, `=` para overrides
- Corregir helix `osx.zsh` (ya hecho)
- Auditar nvim para el mismo patrón
- Documentar el patrón en README del módulo

**Non-Goals:**
- Cambiar la estructura de capas de módulos
- Modificar variables que no son de configuración de plataforma
- Refactorizar otros módulos no afectados

## Decisions

### Decisión 1: Usar `=` para overrides de plataforma
**Rationale:** El operador `=` en zsh asigna incondicionalmente, garantizando que el override de plataforma siempre se aplique.

**Alternativa considerada:** Usar `unset` + `:=` — más verboso y propenso a errores.

### Decisión 2: Mantener `:=` en bloques `if` de Homebrew
**Rationale:** Dentro de `if/elif`, cada rama es independiente y solo una se ejecuta. `:=` es semánticamente correcto aquí.

### Decisión 3: Auditar solo módulos helix y nvim
**Rationale:** Son los dos módulos que usan el patrón de configuración por capas con overrides de plataforma.

## Risks / Trade-offs

- **Riesgo:** Overrides incondicionales podrían sobreescribir configuración de usuario
  - **Mitigación:** Los overrides de plataforma solo aplican a variables específicas de binario/ruta, no a configuración de usuario

- **Riesgo:** Otros módulos podrían tener el mismo problema no detectado
  - **Mitigación:** La auditoría actual cubre los módulos conocidos; se puede extender a otros módulos en el futuro

## Migration Plan

1. Verificar helix `osx.zsh` (ya corregido)
2. Auditar nvim `osx.zsh` y `base.zsh`
3. Documentar patrón en README de cada módulo
4. Probar en macOS y Linux para confirmar comportamiento
