# Event: {{title}}

## Metadata
- id: {{event_id_optional}}
- start: {{start_datetime}}
- end: {{end_datetime}}
- timezone: {{timezone}}
- duration: {{duration_optional}}
- attendees:
  - {{attendee_1}}
  - {{attendee_2}}
- recurrence: {{rrule_optional}}

## Description

{{description}}

## Location

{{location}}

---

## Date Format Options

### Simplified (Recommended)
```
- start: 2026-04-20 09:00
- end: 2026-04-20 10:00
```
or with duration:
```
- start: 2026-04-20 09:00
- duration: 1h
```

### ISO 8601 (Full)
```
- start: 2026-04-20T09:00:00-03:00
- end: 2026-04-20T10:00:00-03:00
```

### Natural Language
```
- start: next monday 9am
- end: next monday 10am
```

### Relative
```
- start: +1d
- end: +1d 2h
```

### Duration Format
```
- start: 2026-04-20 09:00
- duration: 1h30m
```
(Computes end time automatically)

### Event ID (Create vs Update)
- **Sin id o vacío**: Crea un nuevo evento
- **Con id**: Actualiza el evento existente (el id se obtiene después de crear el evento)