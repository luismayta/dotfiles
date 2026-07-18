---
type: research
status: {{ .status }}
source: {{ .source }}
captured_at: "{{ .captured_at }}"
destination: {{ .destination }}
tags:
{{ range (splitList "," .tags) }}
  - {{ . }}
{{ end }}
---

# {{ .titulo }}

## Hallazgos

{{ .findings }}

## Fuentes

{{ .sources }}
