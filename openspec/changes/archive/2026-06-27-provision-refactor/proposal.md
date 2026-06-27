## Why

El sistema de provisioning actual tiene código duplicado entre `install.sh` y `provision/script/` — `detect::os`, `program_exists`, y messaging existen en ambos lados con implementaciones que divergen. El handoff entre fases usa 4 niveles de sourcing implícito sin interfaz clara. No hay un archivo declarativo de paquetes; todo está hardcodeado en funciones. Esto hace que añadir un nuevo paquete, herramienta, o sistema operativo sea propenso a errores y requiera cambios en múltiples lugares.

Ahora que el refactor de `install.sh` está completo (SKIP_NIX, batch paru, shared packages), es el momento de consolidar la arquitectura completa antes de seguir añadiendo funcionalidad.

## What Changes

- **Crear `lib/` con funciones compartidas**: `common.sh` (detect::os, program_exists, change_shell), `messages.sh` (unificado msg::info/success/error), `colors.sh` (constantes ANSI). Ambas fases (bootstrap y provision) sourcedesde el mismo lugar.
- **Eliminar duplicación**: Remover `detect::os`, `program_exists`, y funciones de mensajería de `install.sh` y `provision/script/messages.sh`/`functions.sh`. Una sola fuente de verdad.
- **Hacer declarativa la lista de paquetes**: Extraer `PACKAGES_COMMON`, `PACKAGES_MAC`, `PACKAGES_LINUX` a `config/packages.sh`. Las funciones de instalación iteran arrays en lugar de tenerlos hardcodeados.
- **Robustecer el sourcing**: Reemplazar `source run.sh` por `exec bash run.sh` con contexto explícito vía env vars. Usar `BASH_SOURCE[0]` para rutas estructurales en lugar de `pwd`. Fail loud si un archivo crítico no existe.
- **Split de `initialize()`**: Separar en `initialize_prereqs()`, `install_apps()`, `deploy_configs()`, `sync_extras()`.
- **Eliminar código muerto**: `die()` in functions.sh nunca se llama. `export HOME=~` redundante.
- **Fix seguridad**: Mover `ZSH_PATH` después de installar paquetes. Fix `printf` format strings. Fix `>>/dev/null` → `>/dev/null`.

## Capabilities

### New Capabilities

- `shared-library`: Librería común (`lib/common.sh`, `lib/messages.sh`, `lib/colors.sh`) con detect::os, program_exists, change_shell, y mensajería unificada, sourceable desde cualquier script del proyecto.
- `declarative-packages`: Paquetes definidos en `config/packages.sh` como arrays (`PACKAGES_COMMON`, `PACKAGES_MAC`, `PACKAGES_LINUX`), instalados via función genérica que itera según el OS detectado.
- `robust-bootstrap`: Handoff entre bootstrap y provision vía `exec bash` con contexto explícito. Rutas derivadas de `BASH_SOURCE[0]`. Sourcing con verificación explícita y fail loud.

### Modified Capabilities

- *(ninguna — no hay specs existentes que modificar)*

## Impact

- **`install.sh`**: Remover funciones duplicadas, sourcear `lib/` en su lugar. Mover `ZSH_PATH` a después de `setup::packages::common`. Extraer `change_shell`.
- **`provision/script/bootstrap.sh`**: Remover `detect::os`, remover `export HOME=~`. Usar `BASH_SOURCE[0]` para paths.
- **`provision/script/functions.sh`**: Remover `program_exists`, remover `die()`. Split `initialize()`. Fix `>>/dev/null`.
- **`provision/script/messages.sh`**: Reemplazar por `lib/messages.sh`. Namespace `msg::`.
- **`provision/script/run.sh`**: Cambiar `source bootstrap.sh` por `exec bash` handoff.
- **`config/packages.sh`**: Nuevo archivo con arrays de paquetes.
- **`lib/`**: Nuevo directorio con 3 archivos.
- **`provision/script/test.sh`**: Usar `BASH_SOURCE[0]` para rutas relativas.
