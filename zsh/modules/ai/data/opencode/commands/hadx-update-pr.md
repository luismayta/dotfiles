---
description: Push branch commits and update MR content
---

1. Run `task validate`
2. Run `git diff main...HEAD --stat` to see changed files
3. Run `git log main...HEAD --oneline` to see commits
4. Push the current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
5. Detect the MR for the current branch:
   - Prefer: `glab mr view "$(git rev-parse --abbrev-ref HEAD)" --output json | jq '{iid: .iid, url: .web_url}'`
   - Fallback: `glab mr list --source-branch "$(git rev-parse --abbrev-ref HEAD)" --output json | jq '.[0] | {iid: .iid, url: .web_url}'`
6. Load skill: update-pr
7. Generate an updated MR body using `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` as the base, and fill in:
   - Proposed changes (bullet list) derived from the _current_ branch changes:
     - Use `git diff main...HEAD --stat` + `git diff main...HEAD` to refresh the bullets with whatever is new
     - Add new bullets for newly introduced work; update/remove bullets that are no longer accurate
     - Prefer grouping by area (e.g. Taskfile/docs/config) and reference key paths when helpful
   - Testing: include `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes (mark the right one)
   - Checklist (mark what is true)
8. Update the MR content (follow the update-pr skill; prefer `glab mr update` and fallback to `glab api`)