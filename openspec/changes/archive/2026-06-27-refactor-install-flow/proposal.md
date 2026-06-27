## Why

`install.sh` es el punto de entrada del bootstrap de dotfiles, pero acumula código duplicado entre plataformas, usa loops ineficientes, no es idempotente en varios pasos, y carece de opciones para saltar pasos opcionales. Con la adición reciente de Nix y la madurez del proyecto, es momento de limpiar y consolidar.

## What Changes

- **Extraer funciones OS-agnósticas**: Consolidar paquetes comunes (`zsh`, `git`, `rsync`, `ksh`, `fd`) en una función compartida para evitar duplicación entre `setup::mac` y `setup::linux`
- **Batch install en Linux**: Reemplazar loop `for package ... paru -S` con un solo `paru -S --noconfirm "${packages[@]}"`
- **`chsh` idempotente**: Verificar si el shell actual ya es zsh antes de ejecutar `sudo chsh`
- **Renombrar `upgrade_repo`** a `update_repo` — nombre más preciso
- **Flag para saltar Nix**: Añadir variable `SKIP_NIX=true` para omitir instalación de Nix
- **Mejorar mensajes de error trap**: Incluir timestamp y comando fallido
- **Consolidar constantes de shell path**: Definir `ZSH_PATH` al inicio según OS para evitar hardcode en funciones

## Capabilities

### New Capabilities
- `skip-nix`: Mecanismo para omitir instalación de Nix durante bootstrap
- `shared-packages`: Catálogo de paquetes comunes entre macOS y Linux instalados por el core

### Modified Capabilities
- Ninguna — no hay specs existentes que modificar

## Impact

- `install.sh`: Refactor completo manteniendo misma semántica externa
- Ninguna API o dependencia externa cambia
- Provision scripts (`provision/script/run.sh`) no se ven afectados
