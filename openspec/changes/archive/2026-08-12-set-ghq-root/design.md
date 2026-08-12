## Context

El módulo `zsh/modules/ghq/` define todas sus variables en `config/base.zsh`. Hoy `ZSH_GHQ_ROOT` (L8-9) se calcula ejecutando `ghq root` al cargar, con fallback `${PROJECTS:-${HOME}/projects}`; el alias `GHQ_ROOT` (L23) apunta al canónico. `pkg/base.zsh` usa `ZSH_GHQ_ROOT` (L145/147) para construir rutas, y en `ghq::post_install` hace `git config --global ghq.root` con el mismo fallback genérico (L20). Ver proposal.md — Why.

El problema: si `ghq` no está instalado en el primer arranque, el cálculo cae al fallback genérico `~/projects` (minúscula) que no coincide con el workspace real `$HOME/Projects/src` (`PROJECTS` en `zsh/zshenv:9-12`), y nunca se recalcula.

## Goals / Non-Goals

**Goals:**
- Default determinista: `ZSH_GHQ_ROOT` = `${HOME}/Projects/src` sin depender de la ejecución de `ghq root`.
- Respetar override explícito del usuario (patrón `${VAR:-default}`).
- Mantener el contrato de la spec: prefijo `ZSH_GHQ_` canónico + alias `GHQ_*`.

**Non-Goals:**
- No cambiar la API pública (`ghq::install`, `ghq::sync`, `ghq::setup`).
- No modificar el mecanismo de instalación delegada al core.
- No migrar `PROJECTS` ni tocar `zsh/zshenv`.

## Decisions

**D1: Default literal `${HOME}/Projects/src` en `config/base.zsh`**
Reemplazar la línea 8:
```zsh
ZSH_GHQ_ROOT="$(ghq root 2>/dev/null || echo "${PROJECTS:-${HOME}/projects}")"
```
por:
```zsh
ZSH_GHQ_ROOT="${ZSH_GHQ_ROOT:-${GHQ_ROOT:-${HOME}/Projects/src}}"
export ZSH_GHQ_ROOT
```
- **Racional**: elimina la dependencia de `ghq root` en tiempo de carga (frágil en primer arranque) y fija el valor pedido. El doble fallback `ZSH_GHQ_ROOT` → `GHQ_ROOT` → default permite que el usuario overridee con cualquiera de los dos nombres; el alias `GHQ_ROOT` (L23) ya apunta al canónico después, garantizando consistencia.
- **Alternativas**: (a) seguir usando `PROJECTS` como fuente — descartado porque `PROJECTS` podría redefinirse en otros contextos y el usuario pidió explícitamente `$HOME/Projects/src`; (b) conservar `ghq root` como fallback final — descartado por la fragilidad que motivó el cambio.

**D2: Alinear `ghq::post_install` en `pkg/base.zsh`**
Si `pkg/base.zsh:20` escribe `git config --global ghq.root "${PROJECTS:-${HOME}/projects}"`, cambiar a `"${ZSH_GHQ_ROOT}"` para que el config global de git quede consistente con la variable exportada.
- **Racional**: evita que el post-install regrese a la ruta genérica inconsistente con `ZSH_GHQ_ROOT`.

**D3: Documentar el default**
Actualizar `README.yaml` (fuente) si documenta `GHQ_ROOT`; regenerar `README.md` con `task readme`.

## Risks / Trade-offs

- [Usuarios que dependían del `ghq root` dinámico (por ejemplo con `ghq.root` global distinto) verán cambiar el root] → Mitigación: el override del usuario (variable seteada) siempre gana; se documenta en README que para usar la ruta de `ghq root` basta exportar `GHQ_ROOT` explícitamente.
- [`ghq root` real puede divergir de `$HOME/Projects/src` si el usuario clona en otro sitio] → Mitigación: mismo mecanismo de override; el cambio solo altera el default, no el comportamiento cuando hay configuración explícita.
- [Doble fallback `ZSH_GHQ_ROOT` → `GHQ_ROOT` introduce orden de precedencia sutil] → Mitigación: ambos nombres son del mismo usuario; si ambos están seteados, gana `ZSH_GHQ_ROOT` (el canónico), que es el comportamiento esperado.

## Migration Plan

1. Aplicar D1 en `config/base.zsh` (default determinista).
2. Aplicar D2 en `pkg/base.zsh` si aplica (post-install alineado).
3. Aplicar D3 en `README.yaml` + regenerar `README.md`.
4. Verificar en shell nueva: `echo $ZSH_GHQ_ROOT` y `echo $GHQ_ROOT` → `${HOME}/Projects/src`; con `GHQ_ROOT=/tmp/x` precargado → `/tmp/x`.
5. Rollback: revertir el commit del change; el comportamiento anterior se restaura (default derivado de `ghq root`).

## Open Questions

Ninguna. El comportamiento y la precedencia están resueltos en el design; la implementación puede proceder sin más decisiones.
