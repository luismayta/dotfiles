# Reporte: Skill research-capture

> Reporte técnico del skill `research-capture` — flujo, configuración y pipeline.
> Issue: RD-155 · Fecha: 2026-09-06

## 1. Metadatos del Skill

| Campo | Valor |
|---|---|
| **Nombre** | `research-capture` |
| **Descripción** | Investigate a topic using web search, codegraph, and codebase analysis — shows findings, classifies by PARA destination, saves with metadata for downstream consumption. When invoked without input, lists existing researched drafts for review and promotion. |
| **Ubicación** | `.opencode/skills/research-capture/` |
| **Categoría** | `research` |
| **Versión** | `0.1.0` |
| **Autor** | `codiplab` |
| **Emoji** | 🔍 |
| **Licencia** | Proprietary |

**Triggers**: `investigar`, `research`, `buscar`, `investiga esto`, `buscar sobre`, `investigados`, `researched`, `listar investigados`, `mostrar investigados`, `drafts investigados`, `pick draft`, `elegir draft`, `promover draft`, `validar draft`

**MCPs opcionales**: `graphify`, `context7`, `codegraph`

## 2. Los DOS Modos del Skill

### Decisión de modo (branch determinista)

```
Si hay input (tema, URL, texto) → Modo INVESTIGAR
Si no hay input → Modo BROWSE
```

### MODO 1 — INVESTIGAR (con input) — 11 pasos

1. **Recibir input** — el usuario provee tema, URL, texto o idea conceptual.
2. **Detectar contenido existente con Graphify** — `graphify_query_graph(question: "<tema>", depth: 2)`. Si hay nodos relevantes, preguntar: Enriquecer / Crear nuevo / Cancelar.
3. **Investigar en paralelo** (6 fuentes): Web search, GitHub Search, Codegraph, Codebase, Graphify, Context7.
4. **Mostrar hallazgos** — resumen estructurado con hallazgos, fuentes y relación con codebase.
5. **Definir destino final** (opcional) — categoría (01-Projects/02-Areas/03-Resources) + tenant (codip/hadenlabs/Me) + subpath.
6. **Definir estado** — draft / researched (default) / validated.
7. **Preparar variables YAML** — crear `/tmp/research-capture-vars.yaml` con block scalar `|` para findings y sources.
8. **Preview del draft** — mostrar preview y preguntar `¿Confirmas la escritura? (s/n/editar)`.
9. **Renderizar con gomplate** — `mkdir -p` + comando gomplate con `--missing-key zero`.
10. **Confirmar y verificar** — mostrar resumen y confirmar.
11. **Post-guardado** — consumible por research-draft → idea-jpd-create / jpd-epic-generator.

### MODO 2 — BROWSE (sin input) — 6 pasos

1. **Escanear drafts** — bajo `$RESEARCH_ROOT/{draft,researched,validated}/*.md` (NO archived/).
2. **Mostrar resumen** — agrupado por destination.
3. **Seleccionar draft** — por número o nombre.
4. **Mostrar contenido** — desplegar contenido completo.
5. **Decidir acción** — Agregar contenido / Promover a validated / Volver a draft / Salir.
6. **Post-acción** — según la acción tomada.

## 3. Variables y Configuración

```
RESEARCH_ROOT=".codi/inbox/research"
```

### Estructura de carpetas
```
.codi/inbox/research/
├── draft/          ← drafts sin procesar
├── researched/     ← drafts revisados (default)
├── validated/      ← drafts confirmados
└── archived/       ← archivados (NO escaneados en browse)
```

### Formato de filename
```
<FECHA>-<SLUG>.md
```
Ejemplo: `2026-09-06-vibe-coding-guide.md`

### Regla de slug
1. Convertir a minúsculas
2. Reemplazar espacios y caracteres no alfanuméricos por guiones (`-`)
3. Colapsar guiones duplicados
4. Eliminar guiones iniciales y finales

## 4. El Template `research-draft.md.tpl`

### Frontmatter
```yaml
---
type: research
status: {{ (ds "config").status }}
source: {{ (ds "config").source }}
captured_at: "{{ (ds "config").captured_at }}"
destination: {{ (ds "config").destination }}
{{- if (ds "config").validated_at }}
validated_at: "{{ (ds "config").validated_at }}"
{{- end }}
{{- if (ds "config").validated_by }}
validated_by: {{ (ds "config").validated_by }}
{{- end }}
{{- if (ds "config").promoted_at }}
promoted_at: "{{ (ds "config").promoted_at }}"
{{- end }}
{{- if (ds "config").promoted_by }}
promoted_by: {{ (ds "config").promoted_by }}
{{- end }}
{{- if (ds "config").related_docs }}
related_docs:
{{- range (strings.Split "," ((ds "config").related_docs)) }}
  - {{ . }}
{{- end }}
{{- end }}
tags:
{{- range (strings.Split "," ((ds "config").tags)) }}
  - {{ . }}
{{- end }}
---
```

### Campos del frontmatter
| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `type` | string literal | Sí (hardcoded `research`) | Tipo de documento |
| `status` | string | Sí | `draft` / `researched` / `validated` |
| `source` | string | Sí | Fuente original (URL, "web", etc.) |
| `captured_at` | datetime string | Sí | Fecha de captura original |
| `destination` | string | Sí | Ruta PARA destino final |
| `validated_at` | datetime string | No (condicional) | Fecha de validación |
| `validated_by` | string | No (condicional) | Quién validó (hardcoded `Luchex`) |
| `promoted_at` | datetime string | No (condicional) | Fecha de promoción |
| `promoted_by` | string | No (condicional) | Quién promovió |
| `related_docs` | comma-separated → array | No (condicional) | Docs relacionados |
| `tags` | comma-separated → array | Sí | Tags |

### Cuerpo
```markdown
# {{ (ds "config").title }}

## Hallazgos

{{ (ds "config").findings }}

## Fuentes

{{ (ds "config").sources }}
```

## 5. Renderizado con gomplate

```bash
mkdir -p "$RESEARCH_ROOT/${ESTADO}"

gomplate \
  --missing-key zero \
  -d config=/tmp/research-capture-vars.yaml \
  -f <skill_root>/research-draft.md.tpl \
  -o "$RESEARCH_ROOT/${ESTADO}/${FECHA}-${SLUG}.md"
```

**Flags clave**:
- `--missing-key zero`: si falta una variable, usa valor vacío en vez de fallar
- `-d config=...`: inyecta el YAML como dataset "config"
- `-f ...tpl`: el template
- `-o ...`: archivo de salida

## 6. Sub-flujo de Promoción

Se activa desde Modo BROWSE → "Promover a validated".

1. **Preguntar categoría**: 01-Projects / 02-Areas / 03-Resources
2. **Preguntar tenant**: codip / hadenlabs / Me
3. **Preguntar subpath** específico
4. **Construir destino**: `{Categoría}/{Tenant}/{subpath}`
5. **Mover archivo**:
   ```bash
   mkdir -p "$RESEARCH_ROOT/validated"
   mkdir -p "{DESTINO}"
   mv "$RESEARCH_ROOT/validated/{FECHA}-{SLUG}.md" "{DESTINO}/{SLUG}.md"
   ```
6. **Actualizar frontmatter**: `status: validated`, `destination`, `promoted_at`, `promoted_by`
7. **Confirmar** — siguiente paso: research-draft / markdown-to-jira

**Reglas**: solo desde `validated`; el filename pierde el prefijo de fecha al salir de `$RESEARCH_ROOT`; la fecha queda en frontmatter.

## 7. Post-procesamiento

```
Upstream: (ninguno — entry point del pipeline)
Downstream: research-draft → idea-jpd-create → idea-jpd-import / jpd-epic-generator
```

| Estado del draft | Consumidor |
|---|---|
| `researched` | Disponible para otro `research-capture` (modo browse) |
| `validated` | `research-draft` → `idea-jpd-create` → `idea-jpd-import` / `jpd-epic-generator` |
| `validated` (alternativo) | `markdown-to-jira` para crear issues directamente |
| `draft` (degradado) | Necesita pasar por `idea-research` (modo investigación) de nuevo |

## 8. Resumen del Flujo Completo

```
┌─────────────────────────────────────────────────────────┐
│                    ENTRADA                              │
│  ¿Hay input?                                            │
│  ├── SÍ → MODO INVESTIGAR (11 pasos)                   │
│  └── NO → MODO BROWSE (6 pasos)                        │
└───────────────────────┬─────────────────────────────────┘
                        │
    ┌───────────────────┴───────────────────┐
    │                                       │
    ▼                                       ▼
┌─────────────────────┐          ┌─────────────────────┐
│ MODO INVESTIGAR     │          │ MODO BROWSE         │
│ 1. Recibir input    │          │ 1. Escanear drafts  │
│ 2. Graphify dedup   │          │ 2. Mostrar listado  │
│ 3. Investigar (×6)  │          │ 3. Seleccionar      │
│ 4. Mostrar hallazgos│          │ 4. Mostrar contenido│
│ 5. Definir destino  │          │ 5. Decidir acción   │
│ 6. Definir estado   │          │ 6. Post-acción      │
│ 7. Vars YAML→tmp   │          └─────────────────────┘
│ 8. Preview          │
│ 9. gomplate render  │
│ 10. Confirmar       │
│ 11. Post-guardado   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ .codi/inbox/research │
│ ├── draft/           │
│ ├── researched/      │
│ ├── validated/       │
│ └── archived/        │
└─────────┬───────────┘
          │ (desde validated)
          ▼
┌─────────────────────────────┐
│ SUB-FLUJO DE PROMOCIÓN      │
│ 1. Categoría (01/02/03)    │
│ 2. Tenant (codip/hadenlabs/Me)│
│ 3. Subpath                  │
│ 4. mkdir + mv               │
│ 5. Actualizar frontmatter   │
│ 6. Confirmar                │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────────┐
│ DESTINO FINAL                   │
│ {Categoría}/{Tenant}/{subpath}/ │
│   {slug}.md                     │
│ Downstream: research-draft →    │
│ idea-jpd-create → jpd-epic-     │
│ generator / markdown-to-jira    │
└─────────────────────────────────┘
```
