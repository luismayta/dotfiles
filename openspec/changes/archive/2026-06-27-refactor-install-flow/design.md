## Context

`install.sh` tiene 193 líneas con funciones `setup::mac` y `setup::linux` que duplican lógica (instalación de paquetes comunes como `zsh`, `git`, `rsync`, `ksh`, `fd`; llamado a `setup::nix`; `chsh`). En Linux se itera sobre paquetes uno por uno con `paru -S` en lugar de pasar el array completo. No hay forma de saltar Nix. `chsh` siempre corre con sudo aunque el shell ya sea zsh.

El script se ejecuta en entornos fresh (nueva máquina) y en re-ejecuciones (upgrade). Debe mantenerse compatible con macOS (Darwin) y Arch Linux (incluyendo CachyOS).

## Goals / Non-Goals

**Goals:**
- Eliminar duplicación de paquetes comunes entre macOS y Linux
- Reducir tiempo de instalación en Linux (batch paru)
- Hacer `chsh` idempotente
- Permitir `SKIP_NIX=true` para omitir Nix
- Renombrar `upgrade_repo` → `update_repo` para claridad
- Mejorar mensajes de error con contexto (timestamp + línea)
- Definir `ZSH_PATH` dinámico al inicio

**Non-Goals:**
- No cambiar el flujo general (setup OS → packages → nix → chsh → clone → provision)
- No añadir soporte para otras distros Linux
- No modificar `provision/script/run.sh`
- No cambiar el contrato de las variables de entorno existentes

## Decisions

- **Batch paru**: Usar `paru -S --noconfirm "${packages[@]}"` en lugar del loop. Más rápido, igual de seguro.
- **`ZSH_PATH` dinámico**: `readonly ZSH_PATH=$(command -v zsh)` al inicio, luego `sudo chsh -s "$ZSH_PATH" "$USER"`. Elimina paths hardcodeados.
- **`SKIP_NIX` como flag de entorno**: `[[ -n "${SKIP_NIX:-}" ]] && return 0` al inicio de `setup::nix`. Simple, sin dependencies.
- **`update_repo`**: Solo renombrar la función y sus 2 call sites. Nombre más preciso para lo que hace (git pull).
- **`setup::packages::common`**: Nueva función con paquetes comunes, llamada desde `setup::mac` y `setup::linux` después de los específicos de cada OS.
- **Trap mejorado**: Cambiar a `trap 'message::error "bootstrap failed at $(date) line $LINENO"' ERR`.

## Risks / Trade-offs

- **Batch paru rompe si un package falla**: `set -euo pipefail` ya trata todos los errores como fatales. El batch falla igual que el loop si algo falla — mismo comportamiento, menos overhead.
- **`SKIP_NIX` deshabilita Nix para Devbox**: Devbox requiere Nix. Si el usuario salta Nix y luego corre Devbox, Devbox lo instalará automáticamente (lento ~300MB). Es decisión del usuario.
- **`ZSH_PATH` puede fallar si zsh no está instalado**: Pero `program_exists` corre después y verifica zsh. Si no existe, el script falla con mensaje claro.
