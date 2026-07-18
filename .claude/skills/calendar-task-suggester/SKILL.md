---
name: calendar-task-suggester
description: Read Google Calendar event notes and suggest actionable project tasks with contextual reasoning.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.1.0"
  opencode:
    emoji: "📅"
    triggers:
      - "calendar notes"
      - "suggest tasks"
      - "read my calendar"
      - "calendar tasks"
      - "sugerir tareas desde calendario"
      - "leer notas del calendario"
      - "task suggestions from calendar"
    tags:
      - google-calendar
      - task-suggestion
      - planning
      - productivity
    mcp:
      preferredServer:
        - google-calendar
---

# calendar-task-suggester

Skill that reads notes/descriptions from Google Calendar events, analyzes their content, and suggests implementable project tasks ranked by relevance.

> **Output is advisory** — the user validates and acts on suggestions. No Jira issues are created automatically.

---

## Purpose

- Bridge calendar-based planning (meeting notes, daily logs, brainstorming) with the project's actionable task backlog
- Surface task ideas recorded as calendar event descriptions that might otherwise be forgotten
- Rank suggestions by estimated relevance so the user focuses on the most promising items first

---

## Flow

1. **Retrieve events** — calls `google-calendar_list-events` with the specified date range (default: last 7 days)
2. **Filter** — removes events with empty or short descriptions (<20 non-whitespace characters)
3. **Analyze** — for each remaining event, interprets the note content to identify:
   - Actionable language ("we need to", "fix", "implement", "discussed", "TODO")
   - Keywords referencing project areas (api, auth, database, ui, deployment, etc.)
   - Direct task-like statements ("create endpoint for X", "refactor Y")
4. **Rank** — orders suggestions by estimated relevance (High / Medium / Low)
5. **Output** — produces a structured markdown report

---

## Usage

### Basic — last 7 days

```
📅 suggest tasks from calendar
```

### Custom date range

```
📅 suggest tasks from calendar from 2026-06-01 to 2026-06-14
```

### Specific calendar

```
📅 suggest tasks from calendar in "Work" calendar
```

---

## Parameters

| Parameter | Default | Description |
|---|---|---|
| `startDate` | 7 days ago | Start of the event lookup window (YYYY-MM-DD) |
| `endDate` | today | End of the event lookup window (YYYY-MM-DD) |
| `calendarId` | `primary` | Calendar to query (name or email, e.g. "Work" or "user@domain.com") |
| `minNoteLength` | 20 | Minimum non-whitespace characters for a note to be analyzed |

---

## Output Format

When suggestions are produced, use the following markdown structure:

```markdown
## 📋 Task Suggestions from Calendar Notes

### 1. 🔴 High — [Suggested Task Title]

- **Source:** Event Title (2026-06-10)
- **Description:** Clear description of the suggested task derived from the note.
- **Keywords:** `api`, `rate-limiting`, `performance`
- **Context excerpt:** "We discussed the API rate limiting issues and agreed to implement a sliding window approach."

### 2. 🟡 Medium — [Suggested Task Title]

- **Source:** Another Event (2026-06-09)
- **Description:** ...
- **Keywords:** `auth`, `login`, `refresh-token`
- **Context excerpt:** "..."

### 3. 🟢 Low — [Suggested Task Title]
...
```

### When no suggestions are found

```markdown
## 📋 Calendar Notes Review

No actionable task suggestions were identified in the selected date range.

### Raw Notes (for manual review)

| Event | Date | Notes |
|---|---|---|
| Standup | 2026-06-10 | Quick sync, no action items |
```

### When no events are found

```markdown
## 📅 No Events Found

No events were found in the specified range. Try a wider date range or a different calendar.
```

---

## Edge Cases

| Scenario | Behavior |
|---|---|
| Empty notes | Event is silently skipped |
| Notes <20 chars | Event is silently skipped |
| No events in range | Report "no events found", suggest wider range |
| All events filtered out | Report "no actionable content", present raw note excerpts |
| MCP tools unavailable | Report the error clearly and suggest checking Google Calendar connection |
| Multiple calendars | Defaults to `primary`; `calendarId` parameter switches to another |
| Full-day events without notes | Skipped (no description content to analyze) |

---

## Relevance Criteria

Suggestions are ranked as follows:

- **High**: Direct task statements ("create endpoint", "refactor module X", "fix bug in Y"), explicit TODO items, clear action items with ownership
- **Medium**: Discussed problems or ideas that imply follow-up work ("we should improve", "it would be good to"), references to ongoing project work
- **Low**: General discussion, status updates, informational content without clear next actions

---

## Dependencies

This skill requires the `google-calendar` MCP server to be available with the following tools:
- `google-calendar_list-events` — for retrieving events within a date range
- `google-calendar_search-events` — as an alternative for text-based event lookup
