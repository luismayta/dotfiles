## Context

El módulo Hyprland en `zsh/modules/hyprland/` maneja toda la configuración del compositor Wayland. El archivo `data/configs/general.lua` contiene la configuración de monitores e input, pero la sección `INPUT` (línea 33-35) está vacía. Esto significa que Hyprland usa sus valores por defecto para el teclado:

| Parámetro      | Default Hyprland | macOS (típico) |
|----------------|------------------|----------------|
| `repeat_delay` | 600ms            | 150-200ms      |
| `repeat_rate`  | 25 cps           | 35-40 cps      |

La diferencia es notable — macOS comienza a repetir ~3x más rápido y la tasa de repetición es ~1.5x más rápida.

## Goals / Non-Goals

**Goals:**
- Configurar `repeat_delay` en ~200ms para inicio de repetición inmediato (como macOS)
- Configurar `repeat_rate` en ~35-40 cps para velocidad de repetición fluida (como macOS)
- Mantener el resto de configuración de input intacto (touchpad, mouse, etc.)
- Seguir el patrón existente del módulo Hyprland (configuración en Lua)

**Non-Goals:**
- No modificar configuración de touchpad, mouse, o tabletas
- No cambiar el layout del teclado (ya configurado en otro lado)
- No modificar el input method (fcitx5)
- No agregar configuración que no esté relacionada con keyboard repeat

## Decisions

| Decisión | Opción | Rationale |
|----------|--------|-----------|
| `repeat_delay = 200` | 200ms | El sweet spot entre evitar repeticiones accidentales y respuesta inmediata. macOS usa ~150-200ms en el ajuste más rápido. |
| `repeat_rate = 35` | 35 cps | Coincide con el extremo rápido de macOS (~35 cps). Suficientemente rápido para navegación fluida sin ser excesivo. |
| Ubicación: `general.lua` | Seguir convención existente | La sección INPUT ya existe en `general.lua` — solo está vacía. Es el lugar canónico para esta configuración en Hyprland. |
| Formato: bloque `input { keyboard {} }` | API estándar de Hyprland | Es la forma correcta de configurar input de teclado en la API Lua de Hyprland v0.45+. |

## Risks / Trade-offs

- **[Rendimiento]**: Sin riesgo — cambiar repeat_rate/delay no afecta rendimiento del compositor
- **[Precisión]**: Valores muy agresivos (delay < 150ms, rate > 50) pueden causar repeticiones accidentales al escribir
  - **Mitigación**: 200ms / 35cps son valores probados y conservadores
- **[Regresión]**: Si Hyprland cambia su API de input en el futuro
  - **Mitigación**: Es una API estable desde v0.40+. Se notaría al recargar la configuración.
