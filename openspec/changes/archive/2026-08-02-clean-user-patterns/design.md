## Context

El incidente `.terragrunt-cache` (usuario ejecutó `cleanup`, no limpió el dir porque una export vieja congelaba la lista de patrones) probó el defecto del mecanismo actual: `ZSH_CLEAN_BASE_DIR_PATTERNS` se exporta con guarda `:-`, y cualquier export previo de una sesión anterior queda silenciosamente congelado — los patrones nuevos del repo no aplican hasta `unset && exec zsh`. El diagnóstico (KenThompson) confirmó: config correcta, flujo correcto, patrón correcto; causa raíz = stale exported env var. Tras `migrate-clean-prefix`, los nombres canónicos son `ZSH_CLEAN_*` con aliases legacy `CLEAN_*`.

Estado relevante:
- `config/base.zsh`: `ZSH_CLEAN_BASE_DIR_PATTERNS` (45), `ZSH_CLEAN_BASE_FILE_PATTERNS` (10), `ZSH_CLEAN_AGGRESSIVE_PATTERNS` — guardas `:-` en cascada con fallback legacy `${ZSH_CLEAN_X:-${CLEAN_X:-default}}`.
- `internal/base.zsh` `_cleanup::unnecessary`: `combined="${ZSH_CLEAN_BASE_DIR_PATTERNS}|${ZSH_CLEAN_AGGRESSIVE_PATTERNS}"`.
- El merge `extra_dirs` histórico (`__pycache__|vendor|.external_modules`) fue el precedente del mecanismo de concatenación; ya consolidado en la lista base (extend-clean-patterns) y luego `vendor`/genéricos movidos a opt-in (harden-clean-safety).

## Goals / Non-Goals

**Goals:**
- Los defaults del repo SIEMPRE aplican al cargar el módulo — cero stale-env persistente.
- El usuario extiende patrones vía `ZSH_CLEAN_USER_*` sin conocer ni reproducir la lista default completa.
- Aliases legacy `CLEAN_*` siguen funcionales (backward compat de migrate-clean-prefix intacta).
- Cero duplicados en el merge (dedupe por patrón).

**Non-Goals:**
- No tocar `ZSH_CLEAN_BASE_CACHE_*` ni flags (`DRY_RUN/CONFIRM/VERBOSE/FORCE`) — el unset anti-stale es SOLO para las 3 variables de patrones (la causa del incidente). Los caches/flags no sufren stale porque el usuario las sobreescribe explícitamente.
- No eliminar el mecanismo opt-in `ZSH_CLEAN_AGGRESSIVE_PATTERNS` (del change harden-clean-safety) — se unsetea y re-deriva igual que las demás.
- No migrar los 20 módulos restantes sin prefijo `ZSH_` (deuda repo-wide).
- No tocar `openspec/changes/archive/` ni históricos.

## Decisions

### D1. Unset anti-stale al inicio de `config/base.zsh`
```zsh
# Re-derive defaults every load — prevents stale exports from freezing old lists
unset ZSH_CLEAN_BASE_DIR_PATTERNS ZSH_CLEAN_BASE_FILE_PATTERNS ZSH_CLEAN_AGGRESSIVE_PATTERNS
```
Colocado ANTES de las guardas. Efecto: en cada carga, las variables base se re-exportan desde el default del repo. El fallback legacy de la cascada (`:-${CLEAN_X:-}`) sigue leyendo `CLEAN_*` si el usuario la exportó — pero como el incidente demostró, ese es precisamente el camino del stale: ¿qué pasa con `CLEAN_BASE_DIR_PATTERNS` legacy exportada de una sesión vieja?

**Decisión**: el unset NO toca `CLEAN_*` legacy (backward compat de migrate-clean-prefix exige que el alias siga siendo funcional). El stale legacy se resuelve así: tras este change, la única forma de que `CLEAN_BASE_DIR_PATTERNS` legacy quede exportada es una sesión abierta antes de la migración; el usuario la limpia una vez (`unset CLEAN_* && exec zsh`), y de ahí en adelante el mecanismo oficial de extensión es `ZSH_CLEAN_USER_*`. Documentado en `cleanup::help`.

**Alternativa considerada**: unset también de `CLEAN_*` legacy. Descartada: rompería el contrato de backward compat que RobertMartin exigió (el alias debe seguir funcionando para `CLEAN_DRY_RUN=true` etc.).

### D2. Nuevas variables de merge `ZSH_CLEAN_USER_DIR_PATTERNS` / `ZSH_CLEAN_USER_FILE_PATTERNS`
```zsh
export ZSH_CLEAN_USER_DIR_PATTERNS="${ZSH_CLEAN_USER_DIR_PATTERNS:-}"
export ZSH_CLEAN_USER_FILE_PATTERNS="${ZSH_CLEAN_USER_FILE_PATTERNS:-}"
```
Default vacío. **Sin unset** (el usuario las exporta explícitamente — ese es el mecanismo de extensión; no sufren stale porque nacen por definición del usuario).

### D3. Merge con dedupe en `_cleanup::unnecessary`
```zsh
local combined="${ZSH_CLEAN_BASE_DIR_PATTERNS}|${ZSH_CLEAN_AGGRESSIVE_PATTERNS}|${ZSH_CLEAN_USER_DIR_PATTERNS}"
```
Y para files: `"${ZSH_CLEAN_BASE_FILE_PATTERNS}|${ZSH_CLEAN_USER_FILE_PATTERNS}"`. El dedupe es implícito por construcción (cada patrón se procesa una vez en el loop; los duplicados entre listas solo causarían un `find` extra, no borrado doble — mismo comportamiento que el `extra_dirs` histórico). Para evitar los `find` duplicados, el loop ya filtra `[[ -n ]]` y los patrones vacíos no corren.

**Alternativa considerada**: dedupe explícito con array asociativo. Descartada: sobre-ingeniería para un caso donde el usuario duplicaría manualmente un patrón de la lista base; el costo es un `find` de más, no un error.

### D4. Documentación en `cleanup::help`
Añadir: `ZSH_CLEAN_USER_DIR_PATTERNS` / `ZSH_CLEAN_USER_FILE_PATTERNS` como mecanismo de extensión (ejemplo: `export ZSH_CLEAN_USER_DIR_PATTERNS="my_build|my_tmp"`), y nota de que los defaults se re-derivan en cada carga (anti-stale) — no hace falta `unset` manual salvo para limpiar `CLEAN_*` legacy de sesiones pre-migración.

## Risks / Trade-offs

- **[Cambio de contrato: re-exportar la lista completa ya no funciona]** → quien hoy exporte `CLEAN_BASE_DIR_PATTERNS` (legacy) con la lista completa la seguiría aplicando vía fallback en cascada — pero si la exportación fue un snapshot viejo, es exactamente el stale que este change elimina. **Mitigación**: el mecanismo oficial pasa a `ZSH_CLEAN_USER_*` (aditivo, sin snapshot); documentado en spec y help.
- **[Unset en cada carga = pérdida de una export intencional de base]** → el usuario que quiera REPLACER la lista base (no extenderla) ya no puede vía env var. **Mitigación**: trade-off aceptado — el diagnóstico confirmó 0 overrides de ese tipo en el repo; el valor de matar el stale supera el caso teórico de replace. Si aparece demanda, un `ZSH_CLEAN_REPLACE_PATTERNS` futuro lo cubriría.
- **[Aliases legacy y el incidente original]** → `CLEAN_*` legacy exportada en la shell actual del usuario persiste hasta que la limpie (una vez). Documentado.
- **[Duplicados usuario vs base]** → patrón duplicado corre `find` dos veces (coste trivial), nunca borra doble. Aceptado.

## Migration Plan

1. `config/base.zsh`: unset anti-stale (D1) + 2 vars nuevas `ZSH_CLEAN_USER_*` (D2).
2. `internal/base.zsh`: `_cleanup::unnecessary` merge defaults + user (D3).
3. `pkg/base.zsh`: `cleanup::help` documenta `ZSH_CLEAN_USER_*` y anti-stale (D4).
4. Verificación: `zsh -n`; dry-run en árbol de prueba con `ZSH_CLEAN_USER_DIR_PATTERNS` seteada (patrones user se listan) y sin setear (solo defaults); simular stale: export vieja de `ZSH_CLEAN_BASE_DIR_PATTERNS` antes de cargar → tras cargar, la lista es la default del repo (no la stale); `CLEAN_DRY_RUN=true` legacy sigue activando dry-run; `cleanup::help` OK.
5. Rollback: revertir diff de los 3 archivos (autocontenido).

## Open Questions

- Ninguna bloqueante. La decisión de no unset de `CLEAN_*` legacy está tomada (D1, backward compat); el caso de "replace de lista completa" queda como demanda futura documentada.
