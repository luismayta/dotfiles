---
description: Create a repo-local task plan for a feature using TaskManager
---

1. Read the feature name from `{{args}}`.
2. If `{{args}}` is missing, ask the user for the feature name (recommend `kebab-case`, e.g. `readme-refresh`).
3. This repository does not ship the old `.jasper/...` task backend; do not reference it.
4. Delegate to `TaskManager` to create a repo-local task plan for `<feature>`5. If the repository or user provides a canonical task output path, ask `TaskManager` to write `task.json` and `subtask_NN.json` there.
6. Otherwise, ask `TaskManager` to return the plan in-response instead of inventing a backend path.
7. Report the resulting task location (if files were created), the number of subtasks, and the recommended next subtask.

(End of file - total 10 lines)