# Epic: {{.EPIC_TITLE}}

## Issue Metadata

- projectKey: {{.PROJECT_KEY}}
- issueKey:
- summary: {{.SUMMARY}}
- issueType: Epic
- component: {{.COMPONENT}}
- labels: [{{.LABELS}}]
- jpdSource: {{.JPD_ISSUE_KEY}}
{{- if gt (len .SUMMARY) 120 }}
{{- fail (printf "SUMMARY must be 120 characters or less (got %d)" (len .SUMMARY)) }}
{{- end }}

## Scenario

{{.SCENARIO}}

### Acceptance Tests

{{.ACCEPTANCE_TESTS}}

### Sources:

{{.SOURCES}}

---

{{.TASKS}}
