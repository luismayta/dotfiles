---
type: research
status: draft
source: web,github
captured_at: "2026-09-06"
destination: .codi/inbox/research
tags:
  - omp
  - oh-my-pi
  - coding-agent
  - ai
  - terminal
---

# omp (oh-my-pi) — Coding Agent

## Hallazgos

omp (oh-my-pi) es un coding agent de terminal escrito por can1357 (Can Bölük), fork de Pi de Mario Zechner (pi-mono). Repo: github.com/can1357/oh-my-pi, landing: omp.sh, paquete npm: @oh-my-pi/pi-coding-agent.

Núcleo Rust nativo (~80k líneas), 60+ providers, 31 tools built-in, 14 LSP ops, 28 DAP ops. Windows-native (sin WSL), también macOS y Linux.

Características distintivas:
- Code execution con tool-calling: Python persistente + Bun worker con bridge loopback.
- LSP wired en cada write: renames via workspace/willRenameFiles, actualiza re-exports e imports.
- DAP (debugging): 28 operaciones de debug.
- Time-traveling stream rules: reglas que se inyectan solo cuando el modelo se desvía.
- web_search con 23 providers rankeados: lee PDFs de arxiv, GitHub pages, Stack Overflow como markdown.
- Nativo: ripgrep, glob, find in-process; brush como bash con 58 utilidades CLI.
- Code review con prioridades P0-P3 y veredicto.
- ask tool: option picker estructurado para ambigüedad.
- SDK embebible en Node: expone ModelRegistry, SessionManager, createAgentSession.

Configuración:
- ~/.omp/agent/config.yml — settings globales + roles de modelo
- ~/.omp/agent/models.yml — registro de providers y modelos custom
- ~/.omp/agent/sessions/ — sesiones como JSONL
- Memory backends: local, hindsight, mnemopi

Instalación:
- curl -fsSL https://omp.sh/install | sh
- brew install can1357/tap/omp
- bun install -g @oh-my-pi/pi-coding-agent (recomendado)
- nix run github:can1357/oh-my-pi

Relación con el codebase: omp ya está integrado en zsh/modules/ai/ (config/omp.zsh, internal/omp.zsh, pkg/omp.zsh) con ZSH_AI_OMP_CONFIG_PATH=~/.omp/agent.


## Fuentes

- https://github.com/can1357/oh-my-pi
- https://omp.sh/
- https://www.npmjs.com/package/@oh-my-pi/pi-coding-agent
- https://acchapm1.github.io/tutorials/Oh-My-Pi/omp-beginner-guide

