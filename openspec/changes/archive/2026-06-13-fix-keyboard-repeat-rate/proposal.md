## Why

Al mantener presionada una tecla en Hyprland, la repetición es notablemente más lenta que en macOS. Esto afecta la fluidez en navegación (vim, scroll, movimientos por teclado) y edición de texto. Hyprland usa valores por defecto (`repeat_delay=600ms`, `repeat_rate=25cps`) que están lejos de la respuesta inmediata de macOS (~150-200ms delay, ~35-40cps).

## What Changes

- Agregar configuración de `input { keyboard { ... } }` en `data/configs/general.lua` con:
  - `repeat_rate`: Velocidad de repetición (chars/sec) — aumentar a ~35-40 para igualar macOS
  - `repeat_delay`: Milisegundos antes de iniciar la repetición — reducir a ~150-200ms para respuesta inmediata
- No se modifican otras secciones de input (touchpad, mouse, etc.)

## Capabilities

### New Capabilities
- `keyboard-input-config`: Configuración de teclado para Hyprland — repeat_rate, repeat_delay y otros parámetros de entrada del teclado

### Modified Capabilities

*(None — no existing specs are changing)*

## Impact

- **Archivo afectado**: `zsh/modules/hyprland/data/configs/general.lua`
- **Alcance**: Solo el subsistema de input del teclado en Hyprland
- **Riesgo**: Mínimo — Hyprland valida los valores en tiempo de carga; valores incorrectos generan error visible
- **Compatibilidad**: Total — solo se agregan valores a una sección vacía
