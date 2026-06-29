## Context

El módulo `zsh/modules/git/` define sus aliases de git en `pkg/alias.zsh`, siguiendo el patrón de prefijo `g` para comandos de git (ej: `gl` → `git pull`, `gp` → `git push`, `gc` → `git commit`). Actualmente no existe un alias para `git remote`.

## Goals / Non-Goals

**Goals:**
- Agregar el alias `gr='git remote'` en `pkg/alias.zsh`
- Mantener consistencia con la convención existente de aliases

**Non-Goals:**
- No se crean nuevos comandos ni funciones wrapper
- No se modifica la configuración global de git
- No se añade lógica OS-specific

## Decisions

| Decisión | Opción elegida | Alternativas |
|---|---|---|
| Nombre del alias | `gr` → `git remote` | Podría ser `grmt` pero `gr` sigue el patrón de 2-letras (gl, gp, gc, gb, gco) |
| Implementación | Simple `alias` en `pkg/alias.zsh` | No necesita función wrapper; el comando git remote es suficiente |

## Risks / Trade-offs

- Ningún riesgo identificado. Es un alias directo sin side effects.
