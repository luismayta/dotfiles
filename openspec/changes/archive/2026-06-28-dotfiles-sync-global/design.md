## Context

Los dotfiles tienen 28 funciones `::sync` distribuidas en 16 módulos (`ghostty`, `alacritty`, `wezterm`, `zed`, `starship`, `tmux`, `git`, `ssh`, `nvim`, `ai`, `devops`, `hyprland`, `devbox`, `resources`, `apps`, `dotfiles`). Todas ejecutan `rsync` de directorios `data/` a rutas de configuración en `~/.config/` o `~/`.

No existe un punto de entrada único. Para sincronizar todo hay que conocer y ejecutar cada sync individualmente. Tampoco hay reporte consolidado de resultados.

## Goals / Non-Goals

**Goals:**
- Un solo comando `dotfiles::sync` que ejecute todos los syncs habilitados
- Orden de ejecución determinístico y con dependencias respetadas
- Reporte módulo por módulo (✓ éxito / ✗ error / - saltado)
- Tolerante a fallos: un sync fallido no detiene a los demás
- Integración con la arquitectura existente de módulos (plugin.zsh → config/ → internal/ → pkg/)
- Sin modificar las funciones `::sync` existentes de cada módulo

**Non-Goals:**
- No es un reemplazo de las funciones sync individuales (siguen existiendo)
- No se añade autodetección de módulos (lista explícita)
- No se implementa sync inverso (de ~/.config/ a data/)
- No se añaden nuevas funcionalidades a cada sync existente
- No se maneja resolución de conflictos (rsync unidireccional)

## Decisions

### 1. Ubicación: `zsh/core/pkg/sync.zsh`

**Opción**: Nuevo archivo `zsh/core/pkg/sync.zsh` con `dotfiles::sync` y `DOTFILES_SYNC_PLAN`, referenciado desde `zsh/core/pkg/main.zsh`.
**Rationale**: La función orquesta módulos existentes — no es un módulo nuevo. `zsh/core/pkg/` es donde vive la API pública de core. Sigue el patrón de archivos por concern (como `alias.zsh`, `nix.zsh`). No requiere entrada en `zsh/zshrc` ni mecanismo de enable/disable porque la función siempre debe estar disponible (el control es por módulo individual).

### 2. Lista de sync: declarativa y ordenada

**Opción**: Array asociativo `DOTFILES_SYNC_MODULES` definido en `pkg/base.zsh` con `(orden nombre función descripción)`.
**Rationale**: Explícito, fácil de mantener, permite control de orden y descripciones para el reporte. Autodetección sería frágil (nombres de función inconsistentes) y no permitiría orden personalizado.

```zsh
typeset -ga DOTFILES_SYNC_PLAN
DOTFILES_SYNC_PLAN=(
  "01|Terminals"        "ghostty"   "ghostty::sync"
  "02|Terminals"        "alacritty" "alacritty::sync"
  "03|Terminals"        "wezterm"   "wezterm::sync"
  "04|Terminals"        "zed"       "zed::sync"
  "05|Prompt"           "starship"  "starship::sync"
  "06|Prompt"           "tmux"      "tmux::sync"
  "07|Git"              "git"       "git::sync"
  "08|SSH"              "ssh"       "ssh::sync"
  "09|Editor"           "nvim"      "nvim::sync"
  "10|AI"               "opencode"  "ai::opencode::sync"
  "11|AI"               "fabric"    "ai::fabric::patterns::sync"
  "12|DevOps"           "k9s"       "devops::k9s::sync"
  "13|DevOps"           "komiser"   "devops::komiser::sync"
  "14|Desktop"          "hyprland"  "hyprland::sync"
  "15|Desktop"          "fonts"     "resources::fonts::sync"
  "16|Misc"             "devbox"    "devbox::sync"
)
```

### 3. Ejecución y reporte: bucle con wrapper

**Opción**: Helper local que ejecuta cada sync en subshell capturando éxito/fallo.
**Rationale**: Simple, sin dependencias externas. El wrapper imprime estado en vivo y acumula resultados para el resumen final.

```
Formato en vivo:
  → [01/16] ghostty... ✓

Formato resumen:
  ════════════════════════════════
  dotfiles::sync complete
  Terminals    ✓ ghostty  ✓ alacritty  ✓ wezterm  ✓ zed
  Prompt       ✓ starship  ✓ tmux
  Git          ✓ git
  SSH          ✓ ssh
  Editor       ✓ nvim
  AI           ✓ opencode  ✓ fabric
  DevOps       ✓ k9s  ✓ komiser
  Desktop      ✓ hyprland  ✓ fonts
  Misc         ✓ devbox
  ────────────────────────────────
  16/16 synced  |  0 errors  |  0 skipped
```

### 4. Omisión de módulos deshabilitados

**Opción**: Verificar `ZSH_<MODULE>_ENABLED=false` antes de ejecutar cada sync.
**Rationale**: Cada módulo ya tiene su guardia de habilitación. Si el usuario deshabilitó un módulo, su sync no debería ejecutarse.

### 5. Módulo `apps::sync` (stub)

**Decisión**: No incluir `apps::sync` en la lista — es un stub sin implementación real.

## Risks / Trade-offs

- **[Mantenimiento]** La lista de módulos es manual y puede quedar desactualizada al añadir/quitar módulos. → **Mitigación**: El archivo es pequeño y explícito; fácil de actualizar al crear un módulo nuevo.
- **[Dependencias]** Algunos syncs pueden fallar si directorios de destino no existen. → **Mitigación**: Cada `::sync` individual ya maneja `mkdir -p` o similar. No es responsabilidad del orquestador.
- **[Rendimiento]** 16 rsyncs secuenciales pueden tomar segundos. → **Mitigación**: Aceptable para un comando invocado explícitamente. No es crítico en tiempo. Futura optimización paralela sería posible pero no necesaria hoy.
