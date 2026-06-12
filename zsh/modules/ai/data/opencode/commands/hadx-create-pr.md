---
description: Push branch and create MR with title and description
agent: OpenRepoManager
---

1. Run `task validate`
2. Run `git diff main...HEAD --stat` to see changed files
3. Run `git log main...HEAD --oneline` to see commits
4. Check whether an MR already exists for the current branch:
   - `glab mr list --source-branch "$(git rev-parse --abbrev-ref HEAD)" --output json`
   - If one already exists, stop and report its URL instead of creating another one
5. Push the current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
6. Load skill: git-release
7. Generate an MR title and description using `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` as the base
8. Fill the MR body with:
   - Summary of changes based on `git diff main...HEAD --stat` and `git diff main...HEAD`
   - Testing notes including `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes
   - Checklist items that are true
9. Create the merge request automatically with `glab mr create`, setting both the title and the description
10. Return the MR URL after creation