## Context

`archlinux.sh` es un script heredado de 45 paquetes que se ejecuta en el bootstrap de Arch/CachyOS vía `provision/script/functions.sh:dotfiles_install_factory`. Sin embargo:

- 10 paquetes ya están cubiertos por `install.sh`, `zsh/core/` o `zsh/modules/`
- 34 paquetes (75%) son completamente huérfanos — no tienen equivalente en ningún módulo
- El script usa `paru -S` directamente, cuando ahora ya tenemos el override pattern en `zsh/core/internal/linux.zsh`
- `install.sh` `setup::linux` instala solo 5 paquetes (git, go, npm, yarn, gcc, rsync) — falta zsh, ksh, fd que el sistema necesita

Los paquetes de `archlinux.sh` se dividen en 3 categorías naturales:
1. **Bootstrap essentials**: git, zsh, ksh, fd, rsync — necesarios antes de que cargue zsh
2. **Core dependencies**: fd, xclip, jq, ripgrep, etc. — auto-instalables desde core
3. **Desktop environment**: i3wm, audio (pulseaudio/jack), GTK themes, fonts, PDF viewers, apps — no pertenecen a zsh

## Goals / Non-Goals

**Goals:**
- Cada paquete de `archlinux.sh` tiene un hogar en la arquitectura del proyecto
- `archlinux.sh` se elimina (ya no hay scripts huérfanos)
- `install.sh` `setup::linux` tiene los bootstraps mínimos para que el sistema funcione
- `zsh/core/` auto-installa `fd` (paquete que core usa)
- Desktop environment se maneja desde `provision/script/desktop.sh` (opcional, fuera del runtime zsh)
- `dotfiles_install_factory` apunta al nuevo script

**Non-Goals:**
- No crear nuevos módulos zsh para desktop environment (no son lógica de shell)
- No modificar el sistema de auto-install para macOS (brew sigue igual)
- No cambiar la estructura de `install.sh` `setup::mac`

## Decisions

### 1. Categorización de paquetes en 3 tiers
- **Decision**: Los paquetes se dividen en: (A) bootstrap → install.sh, (B) core deps → zsh/core auto-install, (C) desktop → provision/script/desktop.sh
- **Rationale**: Cada tier tiene un ciclo de vida distinto. Bootstrap se necesita antes de zsh. Core deps se instalan cuando carga zsh. Desktop es optativo y ajeno al runtime.

### 2. desktop.sh como script de provision, no módulo zsh
- **Decision**: Los paquetes de desktop (i3, audio, fonts, theming, apps) van a `provision/script/desktop.sh`, NO a un módulo zsh
- **Rationale**: Estos paquetes no tienen lógica de shell asociada. Son configuraciones de sistema operativo, no de zsh. Ponerlos en un módulo zsh sería un falso abstracción.
- **Alternative considered**: Crear `zsh/modules/linux-desktop`. Rechazado — meter 30+ paquetes sin funciones zsh asociadas viola la separación de concerns.

### 3. fd como auto-install en core
- **Decision**: `zsh/core/pkg/helper/core.zsh` gana `core::install fd`
- **Rationale**: `fd` es usado por `FZF_CTRL_T_COMMAND` y `fa`/`fo`. Debe existir para que las funciones de core funcionen correctamente. Sigue el patrón existente de auto-installs.

### 4. archlinux.sh se elimina
- **Decision**: Una vez migrados todos los paquetes, `archlinux.sh` se borra
- **Rationale**: Script huérfano. Su función la cubren `install.sh` (bootstrap), `zsh/core` (auto-installs), y `desktop.sh` (provision).

## Risks / Trade-offs

- **Risk**: Usuarios existentes con Arch que dependen de `archlinux.sh` para desktop packages → **Mitigation**: `desktop.sh` tiene exactamente los mismos paquetes, solo cambia el nombre del archivo
- **Risk**: `provision/script/functions.sh` tiene lógica que reference `archlinux.sh` → **Mitigation**: Se actualiza `dotfiles_install_factory` para sourcear `desktop.sh`
- **Trade-off**: Los paquetes desktop (i3, audio, etc.) no tienen auto-install como los de core. El usuario debe ejecutar `desktop.sh` explícitamente o vía provision. Esto es intencional — son optativos.
