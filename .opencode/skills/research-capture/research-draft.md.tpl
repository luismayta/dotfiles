---
type: research
status: {{ (ds "config").status }}
source: {{ (ds "config").source }}
captured_at: "{{ (ds "config").captured_at }}"
{{- if (ds "config").validated_at }}
validated_at: "{{ (ds "config").validated_at }}"
{{- end }}
{{- if (ds "config").validated_by }}
validated_by: {{ (ds "config").validated_by }}
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

# {{ (ds "config").title }}

## Hallazgos

{{ (ds "config").findings }}

## Fuentes

{{ (ds "config").sources }}
