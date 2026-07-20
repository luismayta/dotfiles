{{ range $index, $event := .data.events }}

# Event: {{ $event.title }}

## Metadata
- id: {{ $event.id }}
- start: {{ $event.start }}
- end: {{ $event.end }}
- timezone: {{ $event.timezone }}
- status: {{ $event.status }}
{{- if $event.jira_key }}
- jira_key: {{ $event.jira_key }}
{{- end }}
{{- if $event.attendees }}
- attendees:
{{- range $event.attendees }}
  - {{ . }}
{{- end }}
{{- end }}
{{- if $event.recurrence }}
- recurrence: {{ $event.recurrence }}
{{- end }}

## Description

{{ $event.description }}

## Location

{{ $event.location | default "💻 Home" }}

---

{{ end }}
