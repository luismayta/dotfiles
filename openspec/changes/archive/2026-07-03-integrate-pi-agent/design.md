## Context

El módulo `zsh/modules/ai/` actualmente gestiona 10 herramientas AI (opencode, fabric, ollama, shimmy, hf, openclaw, codegraph, tmuxai, rtk, hunk) con una arquitectura consistente: definición de rutas en `config/base.zsh`, PATH loading en `internal/base.zsh`, instalación batch vía `ai::internal::packages::install`, y wrappers públicos en `pkg/helper.zsh`. Pi (pi.dev) sigue el mismo patrón de instalación vía `curl | sh` que herramientas como `opencode`, `fabric` y `ollama`, por lo que se integra naturalmente sin necesidad de nuevo infraestructura.

Pi ofrece ademas un sistema de configuración basado en JSON con dos niveles (global `~/.pi/agent/` y por proyecto `.pi/`), con merge automático. El usuario usa OpenCode Zen como proveedor LLM principal (modelos `opencode/big-pickle` y afines), por lo que la configuración de Pi debe reflejar ese provider.

## Goals / Non-Goals

**Goals:**
- Agregar `pi` como herramienta instalable y cargable en el módulo AI
- Seguir el mismo patrón de integración que las herramientas existentes (PATH, install, batch)
- Permitir instalación individual (`ai::pi::install`) y batch (`ai::install`)
- Carga automática en PATH al iniciar el shell
- Proveer configuración base de Pi con OpenCode Zen como provider
- Sincronizar configuración via `ai::sync` (mismo patrón que opencode y hunk)

**Non-Goals:**
- NO incluye extensiones MCP adicionales — Pi las soporta nativamente pero se configuran aparte
- NO incluye comandos personalizados tipo `hadx-*` para Pi
- NO incluye configuración por proyecto — eso se maneja manualmente con `.pi/settings.json`

## Decisions

| Decisión | Opción Elegida | Alternativas | Razón |
|---|---|---|---|
| **URL de instalación** | `https://pi.dev/install.sh` | brew, npm, go install | Consistente con opencode, fabric y ollama que usan `curl \| sh`. El install script oficial de Pi es el método recomendado |
| **PATH location** | `~/.local/bin/pi` | `~/.pi/bin/pi` | Consistente con shimmy, openclaw, codegraph, rtk y hunk que también usan `~/.local/bin` |
| **Carga en PATH** | `ai::internal::pi::load` como función separada | Inline en main.zsh | Sigue exactamente el mismo patrón que todas las otras herramientas del módulo |
| **Wrapper público** | `ai::pi::install` | Sin wrapper | Consistencia con el resto de la API pública del módulo |
| **Provider default** | OpenCode Zen via API compatible OpenAI | Ollama, Anthropic directo | El usuario ya usa OpenCode Zen como su proveedor principal |
| **Modelos preconfigurados** | `opencode/big-pickle` como default | Solo provider sin modelos | El usuario explicitó que usa modelos OpenCode Zen como `big-pickle` |
| **Formato de config sync** | rsync desde `data/pi/` a `~/.pi/agent/` | cp, symlink | Mismo patrón exacto que opencode y hunk |
| **API key** | Variable de entorno `OPENCODE_ZEN_API_KEY` | Hardcoded en JSON | Seguridad — las credenciales nunca van en dotfiles |

## Risks / Trade-offs

- **[Bajo] Script de instalación externo**: La URL `https://pi.dev/install.sh` es un punto único de falla. Mitigación: mismo patrón usado por opencode, fabric y ollama — si falla, el usuario puede instalar manualmente.
- **[Bajo] Conflicto de nombres**: `pi` es un comando corto que podría colisionar. Mitigación: Raspberry Pi usa `raspberrypi`, el número π no tiene comando. Pi framework es el único `pi` común en terminales de desarrollo.
- **[Medio] Sin pin de versión**: El install.sh siempre instala la última versión. Mitigación: consistente con el resto del módulo que tampoco versiona herramientas.
- **[Bajo] API key expuesta en variable de entorno**: `OPENCODE_ZEN_API_KEY` queda en el entorno del shell. Mitigación: mismo patrón que `OPENAI_API_KEY` o `ANTHROPIC_API_KEY` — el usuario ya maneja estas variables.
