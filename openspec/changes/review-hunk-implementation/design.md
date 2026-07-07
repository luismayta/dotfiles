## Context

El módulo `zsh/modules/ai/` gestiona 11 herramientas AI con una arquitectura de 3 capas consistente: `config/` (variables de entorno), `internal/` (instalación, PATH loading, dispatch por SO), `pkg/` (API pública, helpers, aliases). Hunk se integró en este módulo pero con algunas desviaciones del patrón establecido y omisiones de funcionalidades clave del upstream.

### Estado actual de hunk en el módulo AI

| Capa | Archivo | Estado |
|---|---|---|
| Config | `config/base.zsh` | ✅ Variables AI_HUNK_BIN_PATH, AI_HUNK_CONFIG_PATH |
| Config | `config/base.zsh` | ✅ URL de instalación npm, listado en AI_TOOLS |
| Internal | `internal/base.zsh` | ✅ `ai::internal::hunk::load` (PATH) |
| Internal | `internal/base.zsh` | ✅ `ai::internal::hunk::install` (npm) |
| Internal | `internal/main.zsh` | ✅ Carga de hunk::load en orden |
| Internal | `internal/base.zsh` | ✅ Case hunk en batch install |
| Public | `pkg/helper.zsh` | ✅ `ai::hunk::install`, `ai::hunk::review`, `ai::hunk::show` |
| Public | `pkg/helper.zsh` | ✅ `ai::hunk::daemon::start` |
| Public | `pkg/helper.zsh` | ✅ `ai::hunk::config::sync` (usa `cp`) |
| Public | `pkg/alias.zsh` | ✅ Aliases hunk-review, hunk-show, hunk-watch |
| Data | `data/hunk/config.toml` | ⚠️ Incompleto (faltan campos mode, vcs, watch, exclude_untracked) |
| Commands | `data/opencode/commands/hadx-review.md` | ⚠️ Sin manejo de errores ni ciclo de vida del daemon |
| Zed | `data/keymap.json` | ⚠️ Comentario engañoso ("Git Hunks" no es el CLI hunk) |

### Inconsistencias identificadas

1. **Config sync usa `cp` vs `rsync`**: opencode, pi, rtk usan `rsync -a` para sincronizar config. Hunk usa `cp` de un solo archivo.
2. **No hay `ai::internal::hunk::config::sync`**: rtk tiene función internal + public simétricas. Hunk solo tiene la public.
3. **Daemon incompleto**: Solo `start`, sin `stop`, `status`, `restart`, ni `session::list`.
4. **Sin integración de skill de agente**: `hunk skill path` devuelve un skill file para AI agents, no está integrado.
5. **Sin git pager/difftool**: hunk puede usarse como `core.pager` y `diff.tool` de git.
6. **Config template desactualizado**: Falta `mode`, `vcs`, `watch`, `exclude_untracked` y otros campos que hunk soporta.

## Goals / Non-Goals

**Goals:**
- Uniformar `ai::hunk::config::sync` al patrón rsync del resto del módulo (con `ai::internal::hunk::config::sync`)
- Completar la gestión del daemon: stop, status, restart, session list
- Integrar `hunk skill path` como función pública y en el comando hadx-review
- Actualizar `data/hunk/config.toml` con todos los campos que hunk soporta
- Agregar `ai::hunk::daemon::stop` con manejo de PID
- Corregir comentarios engañosos en Zed keymap.json
- Mejorar `hadx-review` con manejo de errores y ciclo de vida del daemon

**Non-Goals:**
- NO cambiar la lógica de instalación (`ai::internal::hunk::install`) — npm install funciona correctamente
- NO agregar auto-arranque del daemon en shell load (es on-demand, como las otras herramientas)
- NO convertir hunk en el pager/difftool default de git global (solo funciones para uso explícito y documentación comentada en .gitconfig)
- NO modificar la estructura del módulo AI ni sus dependencias

## Decisions

### 1. Sincronización de config: rsync con un solo archivo (no directorio completo)

**Decisión**: Migrar a `rsync` pero preservando la semántica de archivo único (`rsync -a "$src" "$dst"` en lugar de `rsync -a "$src/" "$dst/"`).

**Rationale**: A diferencia de opencode (directorio completo de config) y pi (directorio completo), hunk solo tiene un archivo `config.toml`. Usar `rsync -a` con paths de archivo individual es más limpio que `cp` y consistente con la herramienta (rsync ya es dependencia del módulo). Si en el futuro hunk agregara más archivos, se migra a patrón de directorio.

**Alternativa considerada**: Mantener `cp` — más simple pero inconsistente con el ecosistema y sin el guard `core::exists rsync`.

### 2. Gestión del daemon: variable de entorno para PID

**Decisión**: Almacenar el PID del daemon en `AI_HUNK_DAEMON_PID` (archivo `/tmp/hunk-daemon.pid`) y usarlo para stop/status/restart. `ai::hunk::daemon::start` persiste el PID automáticamente.

**Rationale**: El daemon de hunk corre en background (`&`). Sin PID tracking, no hay forma de detenerlo o verificar su estado sin `pgrep`. Este patrón es común en tools que corren daemons.

**Alternativa considerada**: Usar `pgrep hunk` cada vez — funcional pero menos preciso (podría matar procesos equivocados si hay múltiples instancias).

### 3. Skill de agente: función wrapper + documentación

**Decisión**: `ai::hunk::skill::path` ejecuta `hunk skill path` y retorna el path. `ai::hunk::skill::load` copia el skill al directorio de skills del agente activo (opencode).

**Rationale**: `hunk skill path` es un comando que retorna un path absoluto al skill file. La función wrapper permite usarlo programáticamente desde shell scripts o desde el flujo del módulo AI.

### 4. Config template completo pero conservador

**Decisión**: Agregar campos `mode`, `vcs`, `watch`, `exclude_untracked` al `config.toml` con valores por defecto sensibles. No agregar config experimental o de debugging.

**Rationale**: Los campos que hunk expone como "common" en su documentación son los que tienen más probabilidad de ser útiles para el usuario. Catppuccin Macchiato se mantiene como tema por defecto (consistente con el ecosistema).

### 5. Integración con módulo git: funciones específicas no reemplazo de delta

**Decisión**: Agregar funciones `git::hunk::diff` y `git::hunk::show` en `pkg/base.zsh` del módulo git, con alias `ghd`/`ghs`. No modificar `core.pager` ni `diff.tool` del `.gitconfig`. Agregar sección comentada en `.gitconfig` documentando `core.pager = "hunk pager"` como alternativa.

**Rationale**: Delta ya es el pager por defecto con configuración completa (colores, navigate, diffFilter). Reemplazarlo por hunk rompería la experiencia existente. En cambio, las funciones específicas permiten usar hunk cuando se necesita revisión asistida por AI, sin afectar el flujo diario de git. El alias `ghd` es rápido de escribir y semánticamente claro.

**Alternativa considerada**: Configurar hunk como difftool (`git config --global diff.tool hunk`) — hunk no tiene interfaz de difftool estándar, usa `hunk diff` directamente.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `rsync` no instalado | Guarded por `core::exists rsync` en la función de sync (mismo patrón que opencode) |
| PID file stale si el daemon crashea | `ai::hunk::daemon::status` verifica que el PID exista y el proceso esté corriendo antes de reportar OK |
| Breaking change en API pública si se renombra `ai::hunk::config::sync` | No se renombra — se mantiene la función pública y se agrega `ai::internal::hunk::config::sync` como backend |
| Hunk cambia su formato de skill file | La integración es un wrapper (`hunk skill path`) que delega en el CLI de hunk — cualquier cambio upstream se refleja automáticamente |
