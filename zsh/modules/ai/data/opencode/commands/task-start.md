---
description: Start the next ready repo-local subtask when task artifacts already exist
---

1. Read the feature name from `{{args}}`.
2. If `{{args}}` is missing:
   - Ask the user for the feature name or the repo-local task directory that contains `task.json` and `subtask_NN.json` files.
3. This repository does not ship the old `.jasper/...` task router; do not reference it.
4. Read the existing repo-local task artifacts for the selected feature.
5. Determine the next ready subtask by checking `status` and `depends_on` in the subtask JSON files.
6. Mark that subtask `in_progress` by editing the JSON directly when no documented backend exists.
7. Execute the selected subtask through OpenCode using the subtask's `suggested_agent` as the preferred executor.
8. Prompt selection rules:
   - If the subtask has a `prompt`, use it as the primary execution prompt.
   - Otherwise, synthesize a prompt from the subtask metadata (`title`, `execution_notes`, `run`, `deliverables`, `acceptance_criteria`).
   - If `suggested_agent` has a configured model in `opencode.json`, pass that model to `opencode run`.
9. Sequential behavior:
   - If a subtask completes successfully and marks itself `completed`, continue automatically with the next ready subtask.
   - Stop when there are no more ready subtasks or when the current subtask remains `in_progress`.

(End of file - total 19 lines)