## Context

El módulo `zsh/modules/pyenv/` se creó como port del plugin externo `luismayta/zsh-pyenv`. Su alcance actual incluye:

- Instalación y carga de `pyenv` (version manager)
- Instalación de versiones Python via `pyenv install`
- Instalación de módulos Python via `pip`/`pipx`
- Instalación de `uv` como paquete del sistema en Linux (`PYENV_SYSTEM_PACKAGES`)
- Variables de entorno como `PYENV_ROOT`, `PYENV_VERSION_GLOBAL`, `PYENV_MODULES`

El ecosistema Python ha evolucionado: `uv` (astral-sh/uv) es ahora el gestor de proyectos/entornos Python predominante en el monorepo (Taskfile.yml, nix/devShell.nix, templates Nix). El nombre `pyenv` ya no refleja el alcance real.

El monorepo tiene 31 módulos en `zsh/modules/` siguiendo una arquitectura canónica de 3 capas: `config/` (settings), `internal/` (privado), `pkg/` (API pública). El loader automático en `zsh/zshrc` itera `modules/*/plugin.zsh` — no requiere registro explícito.

Referencias externas a `pyenv` se encuentran en:
- `zsh/zshenv`: vars `PYENV_ROOT`, `PYENV_VIRTUALENV_DISABLE_PROMPT`
- `zsh/modules/clean/pkg/base.zsh`: funciones `cleanup::pyenv`, `cleanup::pyenv::virtualenvs`
- `openspec/specs/core-messages/spec.md`: referencia a `CORE_MESSAGE_PYENV`
- `zsh/core/config/env.zsh`: potencial `CORE_MESSAGE_PYENV` (nunca se creó en el cambio anterior)
- `zsh/modules/starship/data/starship.toml`: clave `pyenv_version_name` (no cambia — es API de starship, no ref a módulo)
- `provision/script/bootstrap.sh`: `PYENV_NAME` (no relacionado al módulo)

## Goals / Non-Goals

**Goals:**
- Renombrar el módulo de `pyenv` a `python` con toda su estructura de archivos
- Renombrar todas las variables internas (`ZSH_PYENV_*` → `ZSH_PYTHON_*`, `PYENV_*` → `PYTHON_*`)
- Renombrar todas las funciones (`pyenv::*` → `python::*`)
- Elevar `uv` a ciudadano de primera clase dentro del módulo python con variable `PYTHON_UV_ENABLED`
- Añadir toggle `PYTHON_PYENV_ENABLED` para activar/desactivar pyenv independientemente
- Actualizar todas las referencias cruzadas en el monorepo
- Mantener compatibilidad funcional total (mismas capacidades, nuevo nombre)

**Non-Goals:**
- No se cambia la funcionalidad de pyenv (seguimos instalándolo y usándolo)
- No se modifica `zsh/zshrc` (el loader automático sigue funcionando)
- No se toca `provision/script/bootstrap.sh` (variable `PYENV_NAME` no relacionada)
- No se modifica `starship.toml` (clave `pyenv_version_name` es de starship, no del módulo)

## Decisions

### D1: Namespace de variables: `PYTHON_*` en lugar de `PYENV_*`

**Decisión**: Renombrar `PYENV_ROOT` → `PYTHON_ROOT`, `PYENV_ROOT_BIN` → `PYTHON_ROOT_BIN`, etc.

**Razón**: El módulo ahora se llama `python`, no `pyenv`. Las variables deben reflejar el nombre del módulo. `PYTHON_ROOT` es más semántico porque es el root del toolchain Python, no solo de pyenv.

### D2: Namespace de funciones: `python::*` con sub-namespaces

**Decisión**: `pyenv::internal::*` → `python::internal::*`, `pyenv::*` (pkg) → `python::*`.

**Razón**: Consistencia con el nuevo nombre del módulo y con otros módulos (`rust::*`, `fnm::*`, `goenv::*`).

### D3: `uv` como ciudadano de primera clase + toggle `PYTHON_PYENV_ENABLED`

**Decisión**: `uv` vive dentro del módulo `zsh/modules/python/` junto con pyenv. Cada herramienta tiene su propio toggle de activación:
- `PYTHON_PYENV_ENABLED="${PYTHON_PYENV_ENABLED:-true}"` — activa/desactiva pyenv
- `PYTHON_UV_ENABLED="${PYTHON_UV_ENABLED:-true}"` — activa/desactiva uv

La estructura interna usa sub-namespaces para mantener separación:
- `python::internal::pyenv::*` — funciones internas de pyenv
- `python::internal::uv::*` — funciones internas de uv

**Razón**: pyenv y uv son herramientas complementarias del toolchain Python. Un solo módulo evita duplicación de configuración (vars compartidas como `PYTHON_ROOT`) y mantiene la coherencia del ecosistema Python. Los toggles permiten usar pyenv sin uv, uv sin pyenv, o ambos.

### D4: Migrar `PYENV_VIRTUALENV_DISABLE_PROMPT` de `zshenv` al módulo

**Decisión**: Mover `PYENV_VIRTUALENV_DISABLE_PROMPT` (ahora `PYTHON_VIRTUALENV_DISABLE_PROMPT`) desde `zsh/zshenv` al `config/base.zsh` del módulo.

**Razón**: Es una configuración del módulo Python, no del entorno global. Sigue el principio de que cada módulo gestiona sus propias vars.

### D5: `CORE_MESSAGE_PYENV` → `CORE_MESSAGE_PYTHON` (o mantener)

**Decisión**: No renombrar `CORE_MESSAGE_PYENV` — mejor crear `CORE_MESSAGE_PYTHON` apuntando al nuevo path y eliminar/deprecar la anterior si existe. Sin embargo, como `CORE_MESSAGE_PYENV` nunca se creó efectivamente (era un task pendiente del cambio archive `standardize-message-vars`), simplemente creamos `CORE_MESSAGE_PYTHON` si no existe.

**Razón**: La variable de core messages debe reflejar el nombre actual del módulo que referencia.

### D6: Estrategia de rename: mover archivos, no copiar

**Decisión**: `git mv zsh/modules/pyenv/ zsh/modules/python/` y luego editar el contenido de los archivos. No copiar + borrar.

**Razón**: `git mv` preserva el historial de git. Cada archivo editado tendrá cambios internos (s/old/new) pero el historial de git muestra el origen.

## Risks / Trade-offs

- **[Risk] Referencias olvidadas**: Podría haber referencias a `pyenv` en lugares no cubiertos por el grep inicial. → **Mitigación**: grep final de `pyenv` (sin `PYENV_NAME` que es otro contexto) en todo el repo después de implementar.
- **[Risk] Scripts externos**: Usuarios con scripts que hacen `source zsh/modules/pyenv/plugin.zsh` directamente se romperán. → **Mitigación**: Cambio breaking documentado en CHANGELOG; el loader automático de `zshrc` itera `modules/*/plugin.zsh` sin necesidad de registro explícito.
- **[Risk] Confusión `python` como nombre**: Python es un binario del sistema. El módulo se llama `python` pero no interfiere porque los módulos viven en `zsh/modules/python/` y no compiten con namespaces de comandos. → **Mitigación**: El namespace de funciones es `python::*`, no `python`.
- **[Risk] `zshenv` se ejecuta antes que los módulos**: Mover `PYENV_VIRTUALENV_DISABLE_PROMPT` al módulo significa que estará disponible después de cargar `zshenv`. → **Mitigación**: La var solo la necesita el módulo mismo, y el módulo la define antes de usarla.
