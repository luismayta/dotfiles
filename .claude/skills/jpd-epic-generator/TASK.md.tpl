# Task: {{.TASK_TITLE}}

## Issue Metadata

- projectKey: {{.PROJECT_KEY}}
- issueType: Task
- summary: {{.TASK_SUMMARY}}
- component: {{.COMPONENT}}
- labels: [{{.LABELS}}]
- parentEpic: {{.PARENT_EPIC}}
- issueKey:
{{- if gt (len .TASK_SUMMARY) 120 }}
{{- fail (printf "TASK_SUMMARY must be 120 characters or less (got %d)" (len .TASK_SUMMARY)) }}
{{- end }}

## Scenario

{{.TASK_SCENARIO}}

### Acceptance Tests

{{.TASK_ACCEPTANCE_TESTS}}

### Sources:

{{.TASK_SOURCES}}
