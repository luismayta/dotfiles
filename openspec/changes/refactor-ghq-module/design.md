## Context

El módulo `zsh/modules/ghq/` es un port de `hadenlabs/zsh-ghq` que conserva la arquitectura 3 capas (config/internal/pkg) pero no fue migrado a las convenciones actuales del repo. La auditoría contra `docs/guides/create-module.md` encontró: 7/9 env vars con prefijo legacy `GHQ_` (Sección 8 exige `ZSH_<NAME>_`), `GITHUB_USER` global sin prefijo, dispatch manual por plataforma en `internal/base.zsh` que reimplementa `core::install`, patrón manual `exists+install` en vez de `core::ensure`, ausencia de `data/` (templates viven en `resources/data.json`), `pkg/helper.zsh` vacío (sin `setup`/`sync`), y naming interno `ghq::internal::ghq::install` con "ghq" redundante. El módulo de referencia es `zsh/modules/zed/` (patrón limpio) y el core `zsh/system/core/` provee `message_*`, `core::exists`, `core::ensure`, `core::install`.

## Goals / Non-Goals

**Goals:**
- Migrar el naming de variables a `ZSH_GHQ_*` con aliases backward-compat `GHQ_*` (patrón herdr, Sección 8).
- Eliminar toda reimplementación de instalación por plataforma usando `core::ensure` / `core::install`.
- Establecer `data/` como home de templates (mover `resources/data.json`), alineado con la Sección 1.
- Completar el contrato público: `ghq::install`, `ghq::sync`, `ghq::setup`.
- Sanear naming interno (`ghq::internal::install`, no `ghq::internal::ghq::install`) e interpolar `${ZSH_GHQ_PACKAGE_NAME}`.

**Non-Goals:**
- No reescribir la funcionalidad de cookiecutter (selector fzf, templates) — solo reubicar datos y sanear.
- No migrar `keybindings.zsh` fuera del módulo — solo documentarlo como extensión opcional.
- No cambiar la API pública de comandos (funciones `ghq::*` existentes se conservan).
- No introducir `core::pip` (no existe) — el install de cookiecutter vía pip se mantiene con su chequeo, pero usando convenciones de mensajería del core.

## Decisions

1. **Rename de variables con aliases backward-compat (no breaking).**
   En `config/base.zsh`, definir canónicos `ZSH_GHQ_*` y aliasar los legacy: `GHQ_PACKAGE_NAME="${ZSH_GHQ_PACKAGE_NAME}"`, etc. `GITHUB_USER` → `ZSH_GHQ_GITHUB_USER` con alias. Alternativa considerada: rename limpio sin alias — descartada porque rompe shells con la var ya expandida en funciones cargadas (razón documentada en la guía Sección 8).
   Alias removibles en el próximo ciclo de cleanup.

2. **Delegar instalación al core.**
   `internal/base.zsh` elimina el `case` brew/paru y llama `core::install "${ZSH_GHQ_PACKAGE_NAME}"` (core resuelve plataforma, guía línea 79). `internal/main.zsh` usa `core::ensure rsync` y `core::ensure "${ZSH_GHQ_PACKAGE_NAME}"` (one-liner idiomático, guía línea 78). Alternativa: mantener dispatch propio — descartada (viola Checklist "Never", línea 771).

3. **`data/` como fuente única de templates.**
   Mover `resources/data.json` → `data/data.json` y eliminar `resources/`. `ZSH_GHQ_DATA_PATH="${ZSH_GHQ_PATH}/data"` en `config/base.zsh`. `cookiecutter/` vacía se elimina. Alternativa: conservar `resources/` — descartada (fuera del scaffold de la guía, Sección 1).

4. **Contrato público completo en pkg/.**
   `pkg/helper.zsh` gana `ghq::setup` (orchestrator: ensure → install si falta → mensajes). `pkg/base.zsh` gana `ghq::sync` (placeholder que reporta no-sync de config, o sync real si aplica). Alternativa: helper vacío como hoy — descartada (la guía Sección 5 exige setup en helper.zsh).

5. **Naming interno sin área ficticia.**
   `ghq::internal::ghq::install` → `ghq::internal::install`. `ghq::internal::cookiecutter::install` se conserva (área real). Alternativa: mantener doble ghq — descartada (viola Sección 8).

6. **`plugin.zsh` alineado al template.**
   `message_info "Loading module: ${ZSH_GHQ_PACKAGE_NAME}"` (interpolación, checklist línea 761). `ZSH_GHQ_PATH="${0:A:h}"` (la guía lo prefiere sobre dirname; se alinea con el template aunque zed use dirname). `keybindings.zsh` se documenta como extensión opcional en comentario de cabecera del archivo.

7. **Saneamiento menor de shell.**
   `echo -e` → `printf '%b'` en `pkg/cookiecutter.zsh:29`. El resto de `echo` en pkg/base.zsh son plumbing de valores de retorno — se conservan (no son mensajes al usuario).

## Risks / Trade-offs

- [Alias legacy pueden quedar olvidados] → Mitigación: comentario "remove in next cleanup cycle" en cada alias, y tarea en tasks.md para auditar referencias en el siguiente ciclo.
- [`GHQ_ROOT` calculado al load con `ghq root` antes del ensure] → Mitigación: mover el cálculo a función lazy o re-evaluar tras `core::ensure` en `internal/main.zsh`; la decisión final la toma el implementador según si `ghq root` es estable.
- [Mover `resources/data.json` rompe refs externas] → Mitigación: grep previo de `GHQ_FILE_COOKIECUTTER` / `resources/data.json` en el repo; el cambio actualiza todas las refs internas.
- [Instalación de cookiecutter vía pip queda fuera del core] → Aceptado: no existe `core::pip`; se mantiene con chequeo de `core::exists` y `message_warning`.
