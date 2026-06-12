---
description: Run a release bump using the release skill (major/minor/patch)
---

1. Load skill: release
2. Read the bump type from `{{args}}` (expected: `major`, `minor`, or `patch`)
   - If `{{args}}` is missing or not one of the expected values, ask the user to choose one of: `major` | `minor` | `patch`
3. Run: `task release:{{args}}`
4. Confirm the new version and show the generated changelog entry (if produced by the task)