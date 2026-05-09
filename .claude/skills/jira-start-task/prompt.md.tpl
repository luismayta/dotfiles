# {{issue.title}}

## Contexto del Issue

- Key: {{issue.key}}
- Title: {{issue.title}}

---

## Contenido Fuente

### Scenario

{{content.scenario}}

### Acceptance Tests

{{#each content.acceptance_tests}}
- {{this}}
{{/each}}

### Sources

{{#each content.sources}}
- {{this}}
{{/each}}

{{#if content.context_queries}}
### Context Queries

{{#each content.context_queries}}
- {{this}}
{{/each}}
{{/if}}

---

## Contexto Relevante (Enrichment)

{{#if enrichment.status}}

Status: {{enrichment.status}}

{{#each enrichment.mcp}}

### Contexto derivado de: {{this.query}}

{{#if this.result}}
{{this.result}}
{{/if}}

{{#if this.error}}
Error: {{this.error}}
{{/if}}

{{/each}}

{{/if}}

---

## Instrucción

Generar una especificación OpenSpec usando ÚNICAMENTE el contenido proporcionado.

---

## Reglas

- Usar SOLO la información proporcionada
- NO inventar información
- Convertir acceptance tests en requerimientos
- Usar:
  - MUST
  - SHOULD
  - MAY

---

## Salida

- Especificación en markdown
- Requerimientos en inglés
- Trazabilidad con {{issue.key}}

---

## Artifacts

### tasks.md

Debe incluir:

```bash
task validate
```
