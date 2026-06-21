## Context

El archivo `zsh/modules/hyprland/data/configs/general.lua` contiene la configuración de Hyprland en formato Lua (usando `hl.config({})`). Cuatro claves actualmente producen errores "unknown config key" porque no coinciden con los nombres que Hyprland reconoce en su versión actual.

La configuración de Hyprland se maneja mediante el archivo `general.lua` que se compila a través de `hyprland.lua` (entry point). No hay otros archivos de configuración Hyprland en el repo que contengan estas claves.

Investigación previa confirma los nombres correctos contra el source de Hyprland (`ConfigDescriptions.hpp`) y la wiki oficial.

## Goals / Non-Goals

**Goals:**
- Eliminar los 4 errores "unknown config key" al hacer `hyprctl reload`
- Mantener comportamiento semántico equivalente al intencionado originalmente
- Dejar el archivo `general.lua` libre de advertencias de configuración

**Non-Goals:**
- No se introducen nuevas funcionalidades de Hyprland
- No se modifica la estructura del archivo ni otros bloques de configuración
- No se afectan otros módulos del dotfiles

## Decisions

### 1. Corrección directa in-situ (vs. migración gradual)
Se reemplazan los nombres de clave directamente en el archivo. No hay beneficios en mantener compatibilidad hacia atrás porque Hyprland ya ignora las claves incorrectas — el comportamiento actual es equivalente a no tener esas líneas.

### 2. `on_focus_under_fullscreen = 2` (default) como reemplazo de `new_window_takes_over_fullscreen = false`
El valor `2` (unfullscreen/unmaximize) es el nuevo comportamiento por defecto de Hyprland y es la traducción más cercana a `false` (no tomar control de fullscreen). Alternativas consideradas:
- `0` (ignore focus request): más restrictivo, diferente comportamiento
- `1` (takes over): equivalente a `true`, no es lo que queremos
Decisión: `2` por ser el default y el equivalente semántico más cercano.

### 3. División de `disable_xdg_anr` en dos claves
La clave `disable_xdg_anr` nunca existió como una sola opción. Se reemplaza por dos claves independientes que cubren la intención original:
- `disable_xdg_env_checks = true` — equivalente a "disable XDG" (suprime warning)
- `enable_anr_dialog = false` — equivalente a "disable ANR" (desactiva el diálogo)

## Risks / Trade-offs

- **Bajo riesgo**: cada reemplazo es directo y documentado por Hyprland upstream
- **Verificación**: `hyprctl reload` + inspección del log de Hyprland para confirmar que los errores desaparecen
- **Rollback**: trivial — revertir el commit o restaurar las líneas originales
- **Hyprland version lock**: si Hyprland se actualiza y vuelve a renombrar estas claves, el error se repetiría. No hay acción preventiva posible más allá de mantener el dotfiles sincronizado con la versión instalada.
