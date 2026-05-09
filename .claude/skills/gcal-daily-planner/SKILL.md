---
name: gcal-daily-planner
description: Generate a daily planning Markdown file combining Google Calendar events and Jira tasks. Creates an executable daily agenda with configurable parameters, dynamic emoji detection, and timezone support.
metadata:
  author: "hadenlabs"
  version: "0.1.0"
  generatedBy: "openspec"
  opencode:
    emoji: 📋
    tags:
      - google-calendar
      - jira
      - planning
      - daily
      - workflow
    mcp:
      - preferredServer: google-calendar
      - preferredServer: jira-calendar
---

# Google Calendar Daily Planner

Generate a daily planning file by combining:

- Google Calendar events (source of truth)
- Jira tasks (work to schedule)

The output is rendered using a deterministic gomplate template.

---

# Objective

Create a daily planning file at:

```
00-Calendar/Events/YYYY/YYYY-MM-DD.md
```

---

# Key Design

## Deterministic Output

- Markdown format is controlled by:
  `<skill_root>/event.md.tpl`
- The LLM does NOT generate Markdown
- The LLM ONLY enriches text fields

---

# Data Model

The LLM must return ONLY valid JSON:

```json
{
  "date": "YYYY-MM-DD",
  "events": [
    {
      "title": "string",
      "id": "string | null",
      "start": "YYYY-MM-DDTHH:MM:SS",
      "end": "YYYY-MM-DDTHH:MM:SS",
      "timezone": "string",
      "attendees": ["string"],
      "recurrence": "string",
      "description": "string",
      "location": "string"
    }
  ]
}
```

---

# Rules

- Return ONLY JSON (no explanations)
- Do NOT change field names
- Do NOT omit fields
- Datetimes MUST be ISO8601
- If id is unknown → null
- Description ≤ 200 characters
- Description MUST be plain text (no markdown)
- Location may be empty (template applies default)
- JQL query MUST NOT be modified
- If LLM output is invalid:

  - MUST be rejected
  - MUST be regenerated

---

# Responsibilities

## System (deterministic)

- Fetch calendar events
- Fetch Jira tasks
- Scheduling (time slots, conflicts, buffers)
- start / end times
- timezone
- id (from Google Calendar or null)
- Title construction (emoji + type)
- Initial location detection
- date (YYYY-MM-DD)

### Timezone Rules

- MUST use timezone from `google-calendar_get-current-time`
- ALL events MUST be normalized to this timezone before scheduling

---

## LLM (strictly limited)

The LLM MUST NOT modify:

- title
- id
- start
- end
- timezone
- attendees
- recurrence

The LLM may ONLY modify:

- description
- location

---

## Description Rules (STRICT)

The description MUST follow EXACTLY this format:

```
[summary of the work]
Objetivo: [purpose of the work]
```

Constraints:

- EXACTLY 2 lines
- First line: clear summary of the work performed
- Second line: MUST start with `Objetivo:`
- Max 200 characters total
- No markdown, no symbols (#, *, etc.)
- Must be understandable without external context

If description is invalid:

- MUST be regenerated

---

# Title & Location Construction (Deterministic)

## Emoji & Type Detection (Jira tasks)

Apply first match:

| Keywords               | Emoji | Type        |
| ---------------------- | ----- | ----------- |
| focus, deep work       | 🎯    | Deep Focus  |
| meeting, standup, sync | 📅    | Meeting     |
| review                 | 👀    | Code Review |
| deploy, release        | 🚀    | Deploy      |
| bug, fix               | 🐛    | Bug Fix     |
| docs                   | 📚    | Docs        |
| refactor               | ♻️    | Refactor    |
| test                   | 🧪    | Testing     |
| default                | 📋    | Task        |

## Title Construction

- Calendar events → original title
- Jira tasks → `<emoji> <type>: <key> - <summary>`

---

## Location Detection

| Keywords | Result    |
| -------- | --------- |
| home     | 💻 Home   |
| office   | 🏢 Office |
| default  | empty     |

Rule:

- First match wins
- If no match → empty string

---

# Operational Flow

## Step 1: Get Current Time

Call:

- google-calendar_get-current-time

---

## Step 2: Fetch Calendar Events

Call:

- google-calendar_list-events

---

## Step 3: Fetch Jira Tasks

Call:

- jira_searchJiraIssuesUsingJql

With JQL:

```jql
assignee = currentUser()
AND status IN ("Do Today", "In Progress")
AND issuetype = Task
ORDER BY priority DESC, updated DESC
```

---

## Step 4: Sort Tasks

1. In Progress
2. Do Today

---

## Step 5: Scheduling

- Start at max(currentTime, workStart)
- Respect work window
- Avoid conflicts
- Assign taskDuration
- Add bufferTime
- Overflow → assign to workEnd
- end = start + taskDuration

---

## Step 6: Build JSON

- Merge calendar + Jira
- Apply deterministic titles
- Apply location detection

### LLM Enrichment

- The LLM MUST receive fully constructed events
- The LLM MUST NOT infer scheduling or modify structure
- Only enrich description and location

---

## Step 7: Persist JSON

Save to:

```
.jasper/build/skills/gcal-daily-planner/YYYY-MM-DD.json
```

Rules:

- Filename MUST match planner date
- MUST overwrite if exists

---

## Step 8: Render Markdown

```
gomplate -f <skill_root>/event.md.tpl -d data=<json-file>
```

- Template is the ONLY formatting source
- If gomplate fails → FAIL HARD
- Do NOT fallback to LLM

---

## Step 9: Write Output

```
00-Calendar/Events/YYYY/YYYY-MM-DD.md
```

---

# Idempotency

- No duplicates

Identity:

- id (if present)
- else (start + title)

---

# Parameters

| Parameter    | Default |
| ------------ | ------- |
| taskDuration | 2h      |
| bufferTime   | 10m     |
| workStart    | 09:00   |
| workEnd      | 18:00   |

---

# Notes

- Template handles defaults:
  `{{ .location | default "💻 Home" }}`
- LLM NEVER outputs Markdown