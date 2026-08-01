## 1. Pre-flight

- [x] 1.1 Verificar en `zsh/modules/ai/internal/tools.zsh` cómo `packages::install` resuelve URLs por entry del registry (resuelve Open Question O1)
- [x] 1.2 Confirmar si `config/openspec.zsh` recibe vars reales o permanece reservado (resuelve O2)

## 2. Split de tools.zsh en archivos por tool

- [x] 2.1 Crear `config/shimmy.zsh` con `AI_SHIMMY_BIN_PATH`
- [x] 2.2 Crear `config/openclaw.zsh` con `AI_OPENCLAW_BIN_PATH`
- [x] 2.3 Crear `config/codegraph.zsh` con `AI_CODEGRAPH_BIN_PATH`
- [x] 2.4 Crear `config/rtk.zsh` con `AI_RTK_BIN_PATH`, `AI_RTK_CONFIG_PATH`, `AI_RTK_CONFIG_SOURCE_PATH`
- [x] 2.5 Crear `config/hunk.zsh` con `AI_HUNK_BIN_PATH`, `AI_HUNK_CONFIG_PATH`
- [x] 2.6 Crear `config/pi.zsh` con `AI_PI_BIN_PATH`, `AI_PI_CONFIG_PATH`, `AI_PI_CONFIG_SOURCE_PATH`

## 3. Migración de URLs de instalación

- [x] 3.1 Mover `AI_INSTALL_URL_OPENCODE` → `config/opencode.zsh`
- [x] 3.2 Mover `AI_INSTALL_URL_FABRIC` → `config/fabric.zsh`
- [x] 3.3 Mover `AI_INSTALL_URL_OLLAMA` → `config/ollama.zsh`
- [x] 3.4 Mover `AI_INSTALL_URL_SHIMMY` → eliminar de base (vive en plataforma); conservar en `linux.zsh`/`osx.zsh` sin definición genérica en base
- [x] 3.5 Mover `AI_INSTALL_URL_HF` → nuevo `config/hf.zsh`
- [x] 3.6 Mover `AI_INSTALL_URL_OPENCLAW` → `config/openclaw.zsh`
- [x] 3.7 Mover `AI_INSTALL_URL_CODEGRAPH` → `config/codegraph.zsh` (o renombrar según 1.1)
- [x] 3.8 Mover `AI_INSTALL_URL_TMUXAI` → nuevo `config/tmuxai.zsh`
- [x] 3.9 Mover `AI_INSTALL_URL_RTK` → `config/rtk.zsh`
- [x] 3.10 Mover `AI_INSTALL_URL_PI` → `config/pi.zsh`
- [x] 3.11 Mover `AI_INSTALL_URL_SKILLS` → `config/skills.zsh`

## 4. Agrupación de modelos ollama

- [x] 4.1 Mover `AI_OLLAMA_MODELS` de `base.zsh` → `config/ollama.zsh` (junto a `AI_OLLAMA_MODELS_PATH`)

## 5. Adelgazamiento de base.zsh

- [x] 5.1 Eliminar los `AI_INSTALL_URL_*` de `config/base.zsh`
- [x] 5.2 Eliminar `AI_OLLAMA_MODELS` de `config/base.zsh`
- [x] 5.3 Actualizar la lista de `source` de `config/base.zsh`: añadir los nuevos archivos por tool y eliminar `tools.zsh`
- [x] 5.4 Conservar en `base.zsh` solo: `ZSH_AI_ENABLED`, `ARCH_NAME`, `AI_PACKAGE_NAME`, `AI_TOOLS`

## 6. Limpieza

- [x] 6.1 Eliminar `config/tools.zsh`
- [x] 6.2 Unificar naming graphify/codegraph según resolución de 1.1 (entry `AI_TOOLS`, vars, URL y archivo consistentes)

## 7. Verificación

- [x] 7.1 Ejecutar `zsh -n` en cada archivo de `config/` modificado o creado
- [x] 7.2 Grep de cada variable migrada para confirmar que ninguna referencia quedó huérfana en `internal/` o `pkg/`
- [x] 7.3 Cargar el módulo: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` sin errores
- [x] 7.4 Verificar `printenv AI_OPENCODE_* AI_OLLAMA_MODELS AI_INSTALL_URL_SKILLS` y `type ai::*` para confirmar disponibilidad
- [x] 7.5 Confirmar que `base.zsh` no exporta ninguna `AI_INSTALL_URL_*` ni `AI_<TOOL>_*`

## 8. Split de internal/tools.zsh por tool

- [x] 8.1 Crear `internal/shimmy.zsh` con `shimmy::load` + `shimmy::install`
- [x] 8.2 Crear `internal/openclaw.zsh` con `openclaw::load` + `openclaw::install`
- [x] 8.3 Crear `internal/codegraph.zsh` con `codegraph::{load,install,init,setup,update,upgrade}`
- [x] 8.4 Crear `internal/rtk.zsh` con `rtk::{load,install,config::sync}`
- [x] 8.5 Crear `internal/hunk.zsh` con `hunk::load` + `hunk::install`
- [x] 8.6 Crear `internal/pi.zsh` con `pi::{load,install,config::sync}`
- [x] 8.7 Crear `internal/hf.zsh` con `hf::install`
- [x] 8.8 Crear `internal/tmuxai.zsh` con `tmuxai::install`
- [x] 8.9 Reducir `internal/tools.zsh` a solo `packages::install` (dispatcher batch del registry)
- [x] 8.10 Actualizar `internal/main.zsh`: sources de los 8 nuevos archivos + invocar `ai::internal::openclaw::load` (fix H4)

## 9. Split de pkg/tools.zsh por tool

- [x] 9.1 Crear `pkg/shimmy.zsh`, `pkg/hf.zsh`, `pkg/openclaw.zsh`, `pkg/codegraph.zsh`, `pkg/tmuxai.zsh`, `pkg/rtk.zsh`, `pkg/pi.zsh` con sus wrappers
- [x] 9.2 Migrar `ai::sync` de `pkg/tools.zsh` → `pkg/base.zsh`
- [x] 9.3 Eliminar `pkg/tools.zsh`
- [x] 9.4 Actualizar `pkg/main.zsh`: sources de los 7 nuevos archivos, eliminar `tools.zsh`

## 10. Coordinación y verificación final

- [x] 10.1 Confirmar no-conflicto con change `standardize-ai-tools` (también toca `internal/tools.zsh` y `pkg/tools.zsh`) — documentar secuencia de merge. Nota: se documenta en el reporte final; `pkg/tools.zsh` ya no existe (su contenido migró a per-tool y `pkg/base.zsh`), y `internal/tools.zsh` sigue existiendo como dispatcher. Si `standardize-ai-tools` modifica branches del case o añade tools, el merge deberá re-aplicarse sobre el dispatcher resultante.
- [x] 10.2 Ejecutar `zsh -n` en todos los archivos de `internal/` y `pkg/` creados o modificados
- [x] 10.3 Grep de `ai::internal::*` y `ai::*` — ninguna referencia rota tras el split
- [x] 10.4 Cargar el módulo: `source zsh/system/core/main.zsh && source zsh/modules/ai/plugin.zsh` sin errores
- [x] 10.5 Verificar `type ai::shimmy::install ai::hf::install ai::openclaw::install ai::codegraph::install ai::tmuxai::install ai::rtk::install ai::pi::install ai::graphify::install` y `type ai::sync`
