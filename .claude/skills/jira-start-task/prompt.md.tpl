# {{issue.key}}: {{issue.title}}

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

## Enriquecimiento

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

{{#if codegraph_enrichment.status}}

### CodeGraph Enrichment
Status: {{codegraph_enrichment.status}}
{{#each codegraph_enrichment.mcp}}

#### {{this.tool}}: `{{this.query}}`
{{#if this.result}}
```{{#if this.language}}{{this.language}}{{/if}}
{{this.result}}
```
{{/if}}
{{#if this.error}}Error: {{this.error}}{{/if}}
{{/each}}
{{/if}}

---

## Instrucciones

Genera una especificación OpenSpec en markdown, en inglés, con trazabilidad a {{issue.key}}.

Rules:
- Usa SOLO la información proporcionada — NO inventes información
- Convierte acceptance tests en requerimientos usando MUST / SHOULD / MAY
- Incluye file paths del enrichment como contexto de código relevante
