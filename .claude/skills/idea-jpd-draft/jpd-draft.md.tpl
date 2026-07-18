---
type: jpd-draft
status: enriched
created: {{ .idea.created }}
source_draft: {{ .idea.source_draft }}
---

# {{ .idea.title }}

## Idea

{{ .idea.one_liner }}

## Descripción

{{ .idea.description }}

## Insights clave
{{ range .idea.insights }}
### {{ .title }}
{{ .detail }}
{{ end }}
## Valor para el equipo

| Antes | Después |
|---|---|
{{ range .idea.value }}| {{ .before }} | {{ .after }} |
{{ end }}
## Segmento objetivo
{{ range .idea.segments }}
- {{ . }}
{{ end }}

## Posibles riesgos
{{ range .idea.risks }}
- {{ . }}
{{ end }}

## Tareas potenciales
{{ if .idea.tasks_intro }}
{{ .idea.tasks_intro }}
{{ end }}
{{ range $i, $task := .idea.tasks }}
### {{ add $i 1 }}. {{ $task.title }}
{{ $task.detail }}
{{ end }}
