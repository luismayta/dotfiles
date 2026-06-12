---
description: Audit and sync project-specific OpenCode files and AGENTS.md with the current repository
---

1. Load skill: context-sync
2. If `{{args}}` is provided, use it as an optional scope hint (`context`, `agents`, `commands`, `skills`, `config`, `workflow`, `repo`, or `all`) when it can be applied safely; otherwise review the full project-specific OpenCode setup and `AGENTS.md`.
3. Compare `.opencode/context/`, `.opencode/agent/`, `.opencode/skills/`, `.opencode/commands/`, `.opencode/config/`, `.agents/skills/`, `opencode.json`, and `AGENTS.md` against the current repository structure and source-of-truth files defined by the skill.
4. Report and fix stale repo names, nonexistent paths, missing skill references, invalid task names, and metadata drift when found.