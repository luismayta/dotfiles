---
description: Registra un worklog en Jira usando el issue del branch actual y una descripcion basada en commits
---

1. Read input from `{{args}}`
2. If `{{args}}` is provided, use it as the worklog duration when it is a safe Jira-compatible time format; otherwise ask the user for the duration.
3. Load skill: jira-add-worklog `{{args}}`