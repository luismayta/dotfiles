## 1. Preparación

- [x] 1.1 Inventariar los 35 archivos con vars `AI_*` y las ~47 vars únicas a renombrar (baseline del diff)
- [x] 1.2 Verificar el sed disponible y la semántica de `\b` (GNU vs BSD) en la plataforma de ejecución

## 2. Rename del prefijo AI_ → ZSH_AI_

- [x] 2.1 Aplicar `sed -E 's/\bAI_/ZSH_AI_/g'` (o `[[:<:]]AI_` en BSD) a los archivos de `zsh/modules/ai/config/` con `export AI_*` (16)
- [x] 2.2 Aplicar el mismo rename a los consumidores de `zsh/modules/ai/internal/` (15)
- [x] 2.3 Aplicar el mismo rename a los consumidores de `zsh/modules/ai/pkg/` (4)
- [x] 2.4 Confirmar que `ZSH_AI_PATH`, `ZSH_AI_ENABLED` y `__ZSH_AI_LOADED` NO fueron afectados (sin doble prefijo `ZSH_ZSH_AI_`)

## 3. Verificación

- [x] 3.1 Grep residual: `grep -rE '\bAI_[A-Z]' zsh/modules/ai/` → 0 resultados (excluyendo `ZSH_AI_*` y `__ZSH_AI_LOADED`)
- [x] 3.2 `zsh -n` en los 35 archivos modificados
- [x] 3.3 Carga del módulo con entorno mínimo: `ZSH_AI_PATH`, `ZSH_AI_TOOLS` (13 entries), `ZSH_AI_OLLAMA_MODELS` (3), `ZSH_AI_INSTALL_URL_*` resuelven; `AI_TOOLS`/`AI_*` legacy unset
- [x] 3.4 `type ai::packages::install ai::graphify::install ai::sync ai::internal::openclaw::load` → "function" (funciones intactas)
- [x] 3.5 Confirmar que ninguna función `ai::*` fue renombrada (`grep -c 'ai::'` igual pre/post)

## 4. Spec sync y cierre

- [x] 4.1 Sincronizar la spec `ai-config-per-tool` (MODIFIED + REMOVED) a `openspec/specs/ai-config-per-tool/spec.md`
- [x] 4.2 Archivar el change `rename-ai-vars-prefix`
