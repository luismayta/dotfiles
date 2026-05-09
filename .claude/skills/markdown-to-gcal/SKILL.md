---
name: markdown-to-gcal
description: Create and update Google Calendar events from structured markdown files using MCP. Supports idempotent sync - running multiple times on the same markdown produces the same result.
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: 📅
    tags:
      - google-calendar
      - mcp
      - event
      - workflow
    mcp:
      preferredServer: google-calendar
---

# Markdown to Google Calendar

Use this skill when you have a markdown file with event details and want to create a Google Calendar event using MCP.

## Objective

Convert a structured markdown file into a Google Calendar event using the `@cocal/google-calendar-mcp` MCP.

## Invocation Patterns

This skill can be triggered when the user intent matches:

- creating calendar events from markdown
- syncing markdown events with Google Calendar
- updating existing calendar events based on markdown

### Example User Requests

- "Use the markdown-to-gcal skill with this file"
- "Create a Google Calendar event from this markdown"
- "Sync this markdown with my calendar"
- "Update this event in my calendar"

## Expected Markdown Format

The markdown file should follow the `event.md.tpl` structure:

```md
# Event: <title>

## Metadata

- start: <datetime>
- end: <datetime>
- timezone: <timezone>
- duration: <duration_optional>
- id: <event_id_optional>
- attendees:
  - <email1>
  - <email2>
- recurrence: <RRULE string>

## Description

<event description>

## Location

<location>
```

### Date Format Options

| Format     | Example                     | Description                            |
| ---------- | --------------------------- | -------------------------------------- |
| Simplified | `2026-04-20 09:00`          | Recommended - no T, no timezone suffix |
| ISO 8601   | `2026-04-20T09:00:00-03:00` | Full format                            |
| Natural    | `next monday 9am`           | Human readable                         |
| Relative   | `+1d`                       | Days from now                          |
| Duration   | `1h30m`                     | Use instead of end time                |

## Required Metadata

- `title` - Event title (from `# Event:` heading)
- `start` - Start datetime (simplified: `2026-04-20 09:00`, ISO 8601: `2026-04-20T09:00:00-03:00`, or natural: `next monday 9am`)
- `timezone` - Timezone identifier (e.g., `America/Argentina/Buenos_Aires`)

## Optional Metadata

- `id` - Google Calendar event ID (if present, validate and update; if absent, create new)
- `end` - End datetime (or use `duration` instead)
- `duration` - Event duration (e.g., `1h`, `30m`, `1h30m`) as alternative to `end`
- `attendees` - List of email addresses
- `recurrence` - RRULE string for recurring events (e.g., `FREQ=WEEKLY;BYDAY=MO`)
- `description` - Event description
- `location` - Physical or virtual location

## Operational Flow

1. Read the markdown file indicated by the user.
2. Parse the content to extract:
   - `title` from `# Event:` heading
   - `id` from Metadata section (optional - determines create vs update)
   - `start`, `end`, `duration`, `timezone` from Metadata section
   - `attendees` list from Metadata section
   - `recurrence` from Metadata section
   - `description` from Description section
   - `location` from Location section
3. Convert date formats to ISO 8601:
   - **Simplified** (`2026-04-18 22:00`): append `:00` and timezone offset
   - **ISO 8601** (`2026-04-18T22:00:00-05:00`): use as-is
   - **Duration** (`1h`): calculate end time by adding duration to start
4. Validate required fields are present.
5. **Idempotent Create/Update Logic**:
   a. If `id` is empty or not present → Create new event
   b. If `id` has a value:
      - First, validate existence using `google-calendar_get-event`
      - If event exists → Update the event
      - If event does NOT exist → Create new event (the old ID was invalid)
6. After create: If a new event was created (either from empty ID or invalid ID), add the returned `id` to the markdown file so future runs update instead of create
7. Return the result to the user.

## MCP Tools Available

### google-calendar_get-event
Get an event by ID to validate existence.

```json
{
  "calendarId": "primary",
  "eventId": "<event-id>"
}
```

### google-calendar_create-event
Create a new event.

```json
{
  "calendarId": "primary",
  "summary": "<title>",
  "start": "<ISO 8601 datetime>",
  "end": "<ISO 8601 datetime>",
  "timeZone": "<timezone>",
  "description": "<description>",
  "location": "<location>",
  "attendees": [
    { "email": "<email1>" },
    { "email": "<email2>" }
  ],
  "recurrence": ["RRULE:<rrule>"]
}
```

### google-calendar_update-event
Update an existing event.

```json
{
  "calendarId": "primary",
  "eventId": "<event-id>",
  "summary": "<title>",
  "start": "<ISO 8601 datetime>",
  "end": "<ISO 8601 datetime>",
  "timeZone": "<timezone>",
  "description": "<description>",
  "location": "<location>"
}
```

## Idempotent Flow (Recommended)

### Step 1: Check if ID exists in markdown
- If NO `id` field → Skip to Step 3 (create new)
- If `id` field exists → Go to Step 2

### Step 2: Validate event existence
Call `google-calendar_get-event` with the `id` from markdown:

- **If returns event** → Event exists → Go to Step 4 (update)
- **If returns 404/not found** → Event doesn't exist → Go to Step 3 (create new)
- **If returns other error** → STOP and report error

### Step 3: Create new event
Call `google-calendar_create-event`:

- The response contains `event.id`
- Write this `id` back to the markdown file in the Metadata section
- Future runs will use this ID for updates

### Step 4: Update existing event
Call `google-calendar_update-event` with the existing `id`:

- No need to update the markdown (ID stays the same)

## Idempotent Behavior Examples

### Example 1: First Execution (No ID)

**Before:**
```md
# Event: Team Standup

## Metadata

- start: 2026-04-22 09:00
- duration: 30m
- timezone: America/Argentina/Buenos_Aires
```

**After:**
```md
# Event: Team Standup

## Metadata

- start: 2026-04-22 09:00
- duration: 30m
- timezone: America/Argentina/Buenos_Aires
- id: abc123def456ghi789
```

### Example 2: Second Execution (With Valid ID)

The skill validates the ID exists in Google Calendar, then updates the event. No duplicate created.

### Example 3: Invalid ID (Event Deleted)

**Before:**
```md
- id: deleted-event-id
```

**After:**
```md
- id: new-event-id-xyz
```

The old ID is replaced with the new event ID.

## Validation Rules

- Required fields: title, start, timezone
- datetime can be: simplified (`2026-04-20 09:00`), ISO 8601 (`2026-04-20T09:00:00-03:00`), natural (`next monday 9am`), or relative (`+1d`)
- Use either `end` OR `duration`, not both
- attendees must be valid email addresses
- end time must be after start time (or duration must be positive)
- timezone must be a valid IANA timezone identifier

## Error Handling

- If markdown is invalid or missing required fields, explain what is missing.
- If MCP tool fails, report the error from the MCP.
- Do not invent any field values.
- **ID Validation Errors**:
  - If `google-calendar_get-event` fails with "not found" (404) → treat as new event (create)
  - If `google-calendar_get-event` fails with any other error (auth, network, quota) → STOP and report error, do not attempt create
- **Idempotency**: The skill should produce the same result regardless of how many times it runs