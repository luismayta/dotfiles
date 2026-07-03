---
description: Review working tree changes with hunk interactive diff viewer
---

# hadx-review

## Description
Review uncommitted changes in the working tree using hunk, the terminal diff viewer
for agentic coders. Supports agent daemon mode for AI-assisted review sessions.

## Usage
- `hadx-review` — open hunk diff in current repo
- `hadx-review --watch` — auto-reload on file changes
- `hadx-review --commit HEAD~1` — review a specific commit
- `hadx-review --agent` — start daemon for agent interaction

## Steps
1. Verify hunk is installed (`core::exists hunk`)
2. If `--agent` flag is provided, start the loopback daemon:
   ```
   hunk daemon serve &
   ```
3. Determine target:
   - If `--commit <ref>` is provided, run `hunk show <ref>`
   - Otherwise run `hunk diff`
4. If `--watch` is provided, append `--watch`
5. If daemon is running, print session info for agent connection:
   ```
   hunk session list
   ```
