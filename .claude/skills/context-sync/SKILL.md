---
name: context-sync
description: Audit and synchronize local OpenCode context, commands, skills, agents, config, and AGENTS.md with the current repository.
license: Proprietary
---

# Context Sync Skill

## What I do

- Audit the repo's local OpenCode surface against the current checkout.
- Verify that documented paths, commands, skills, and agent metadata still exist.
- Detect stale repo names, nonexistent paths, missing `Load skill:` targets, invalid task names, and metadata drift.
- Fix safe documentation and configuration drift directly when the source of truth is clear.

## Scope

Review these areas when present:

- `.opencode/context/`
- `.opencode/agent/`
- `.opencode/skills/`
- `.opencode/commands/`
- `.opencode/config/`
- `.agents/skills/`
- `.claude/skills/`
- `opencode.json`
- `AGENTS.md`

If a scope hint is provided (`context`, `agents`, `commands`, `skills`, `config`, `workflow`, `repo`, `all`), use it only when that scope can be checked safely without hiding cross-file drift.

## Source Of Truth

- `AGENTS.md`
- `Taskfile.yml`
- `opencode.json`
- `.opencode/paths.json`
- `.opencode/config/agent-metadata.json`
- `.opencode/context/project/*.md`
- `.opencode/commands/*.md`
- `.agents/skills/<skill-name>/SKILL.md`
- `.claude/skills/<skill-name>/SKILL.md`
- `.opencode/skills/<skill-name>/SKILL.md`

## Audit Rules

1. Verify every `Load skill: <name>` reference resolves in this order:
   - `.agents/skills/<name>/SKILL.md`
   - `.claude/skills/<name>/SKILL.md`
   - `.opencode/skills/<name>/SKILL.md`
2. Verify every documented file or directory path exists, unless the text explicitly marks it as optional, preferred, compatibility-only, or future-facing.
3. Verify task names against `Taskfile.yml` and its includes; do not assume local tasks must be declared inline when they are provided through `includes:`.
4. Keep repo naming aligned with this checkout: `architecture/infrastructure`.
5. Keep `.opencode/context/project/*.md` aligned with the actual repo layout, active workflows, and local skill locations.
6. Treat references to the removed `.infobot/...` task backend as stale unless a current repo file explicitly restores that workflow.
7. Keep agent/config metadata aligned with actual files under `.opencode/agent/` and the agent registry in `opencode.json`.

## Fix Policy

- Fix safe drift directly in docs, commands, local skills, and metadata.
- Prefer updating the inaccurate reference rather than adding compatibility shims for removed paths.
- Do not invent new operational backends; if a backend is absent, document the absence and point to the supported workflow.
- If validation depends on an external service or unclear source of truth, report the drift instead of guessing.

## Expected Output

- Brief audit summary
- Files updated
- Remaining unresolved gaps, if any