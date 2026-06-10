## Context

El pipeline `install.sh` → `run.sh` → `bootstrap.sh` → `functions.sh` ejecuta la instalación de dotfiles post-clone. La auditoría de flujo reveló 4 bugs activos en el pipeline principal y 1 en tools/git-extras:

| ID | Archivo | Problema | Severidad |
|---|---|---|---|
| B1 | `run.sh:11` | `exit 1` en TEST mode (debe ser `exit 0`) | Media |
| B2 | `run.sh:7` | Sin guard si bootstrap.sh falta | Media |
| B3 | `functions.sh:82` | Ruta hardcodeada `~/.dotfiles` en vez de `$PATH_REPO` | Baja |
| B4 | `install.sh:138` | `>>/dev/null` (append) debe ser `>/dev/null` (truncate) | Baja |
| B7 | `tools/git-extras/install.sh:19` | `sudo` rompe curl\|bash | Media |

## Goals / Non-Goals

**Goals:**
- Pipeline principal libre de bugs de shell (exit codes, unbound vars, redirects)
- Instalación via curl\|bash no se bloquea por falta de interacción (sudo)
- Rutas y referencias consistentes entre módulos

**Non-Goals:**
- No se refactoriza la arquitectura general del pipeline
- No se agregan nuevas features al instalador
- No se modifica desktop.sh ni la lógica de detección de OS

## Decisions

### D1: Git-extras — reemplazar sudo por instalación sin privilegios

**Opción A**: `sudo -n` (non-interactive) que falla silenciosamente si no hay password
**Opción B**: Instalar git-extras via `npm` (`npm install -g git-extras`) que no requiere sudo si npm está configurado con prefix local
**Opción C**: Mover git-extras a instalación manual/documentada, quitarlo del pipeline automático

**Decisión**: Opción C — eliminar git-extras de `APPS` en `config/base.sh` y moverlo a instalación manual documentada. El `curl | bash` no puede garantizar `sudo` sin interacción, y `npm -g` requiere configuración previa de npm. Es más honesto no instalarlo automáticamente que instalarlo a medias.

### D2: Guard para bootstrap.sh en run.sh

Si `bootstrap.sh` no es legible, `replace_files()` cascará con unbound variables. Agregar `|| die` temprano con mensaje explícito.

**Decisión**: `[ -r "provision/script/bootstrap.sh" ] || die "bootstrap.sh not found at provision/script/bootstrap.sh"` antes del source.

### D3: Exit code en TEST mode

`initialize()` ejecuta todo el setup. Si `TEST=true`, se testea la inicialización. `exit 1` es incorrecto — debe ser `exit 0`.

**Decisión**: Cambiar `exit 1` a `exit 0` en `run.sh:11`.

## Risks / Trade-offs

- **[B3 → Bajo]**: La ruta hardcodeada `~/.dotfiles` actualmente coincide con `$PATH_REPO`. Si alguien cambia `DOTFILES_NAME` en `install.sh`, rompe `functions.sh`. Fix trivial: usar `${PATH_REPO}`.
- **[B4 → Bajo]**: `>>/dev/null` funciona (append a null device es no-op) pero es incorrecto semánticamente. Fix de 2 caracteres.
- **[B7 → Mitigación completa]**: Sacar git-extras del pipeline automático significa que usuarios que sí quieran git-extras deben instalarlo manualmente. Trade-off aceptable contra romper curl|bash.
