## Why

El módulo `zsh/modules/ghq/` es un port directo de `hadenlabs/zsh-ghq` que no fue migrado a la arquitectura de módulos del repo: 7/9 variables de entorno usan el prefijo legacy `GHQ_` (viola la convención `ZSH_<NAME>_` de la Sección 8 de `docs/guides/create-module.md`), `GITHUB_USER` es una variable global sin prefijo con riesgo de colisión, el install por plataforma reimplementa lo que `zsh/system/core/` ya resuelve, y el módulo carece de `data/` y del contrato `helper.zsh` (`setup`/`sync`).

## What Changes

- **BREAKING (con aliases backward-compat):** renombrar variables legacy `GHQ_*` → `ZSH_GHQ_*` en `config/base.zsh`, manteniendo `GHQ_*="${ZSH_GHQ_*}"` como alias temporal (patrón herdr de la Sección 8). `GITHUB_USER` → `ZSH_GHQ_GITHUB_USER`.
- Reemplazar el dispatch manual por plataforma (`brew`/`paru`) en `internal/base.zsh` por `core::install` / `core::ensure`, y el patrón manual `if ! core::exists X; then core::install X; fi` en `internal/main.zsh` por el one-liner idiomático `core::ensure`.
- Crear `data/` y mover los templates de `resources/data.json` ahí (la guía exige `data/` para rsync/gomplate; `resources/` es ubicación legacy).
- Renombrar `ghq::internal::ghq::install` → `ghq::internal::install` (el `ghq` extra viola el patrón `<name>::internal::<verb>`).
- Implementar el contrato `pkg/helper.zsh`: `ghq::setup` (orchestrator) y `ghq::sync` (falta en `pkg/base.zsh`).
- Interpolar `${ZSH_GHQ_PACKAGE_NAME}` en `plugin.zsh:17` (hoy `"ghq"` hardcodeado).
- Documentar `keybindings.zsh` como extensión opcional del módulo (fuera del scaffold de la guía).
- `echo -e` → `printf` en `pkg/cookiecutter.zsh:29`.
- Eliminar `cookiecutter/` vacía (solo `.gitkeep`, legacy leftover).

## Capabilities

### New Capabilities

- `ghq-module`: contrato del módulo zsh ghq alineado con la arquitectura 3 capas — naming `ZSH_GHQ_*`, core reuse (`core::ensure`/`core::install`), `data/` para templates, y API pública `ghq::install`/`ghq::sync`/`ghq::setup`.

### Modified Capabilities

<!-- Ninguno: no existe spec previo de ghq; los specs existentes en openspec/specs/ no cambian sus REQUIREMENTS. -->

## Impact

- Código: `zsh/modules/ghq/` — `plugin.zsh`, `config/base.zsh`, `internal/base.zsh`, `internal/main.zsh`, `pkg/base.zsh`, `pkg/helper.zsh`, `pkg/cookiecutter.zsh`, `keybindings.zsh`, `resources/data.json` → `data/`.
- Usuarios: shells con `GHQ_*` ya expandidas en funciones cargadas — mitigado por los aliases backward-compat.
- Docs: `docs/guides/create-module.md` se mantiene como referencia; no cambia.
