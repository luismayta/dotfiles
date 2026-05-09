---
name: update-pr
description: Push branch commits and update the existing MR body safely (prefer REST API)
license: Proprietary
---

## What I do

- Validate changes locally.
- Push the current branch (handles unset upstream).
- Detect the MR for the current branch.
- Regenerate the MR body from `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` using the current `main...HEAD` diff.
- Update the MR body using `glab mr update` (fallback to `glab api`).

## When to use me

Use this when you already have an MR open and need to refresh its description to match the latest branch changes.

## Process

1. Run `task validate`
2. Collect context:
   - `git diff main...HEAD --stat`
   - `git diff main...HEAD`
   - `git log main...HEAD --oneline`
3. Push current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
4. Detect MR:
   - Prefer: `glab mr view "$(git rev-parse --abbrev-ref HEAD)" --output json | jq '{iid: .iid, url: .web_url}'`
   - Fallback: `glab mr list --source-branch "$(git rev-parse --abbrev-ref HEAD)" --output json | jq '.[0] | {iid: .iid, url: .web_url}'`
5. Generate updated MR body (based on `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md`) and fill:
   - Proposed changes: bullets derived from `main...HEAD` diff (group by area; reference key paths)
   - Testing: include `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes: mark what applies
   - Checklist: mark what is true
6. Update MR body:
   - Prefer:

```bash
glab mr update <MR_IID> --description "$(cat <<'EOF'
<filled template body>
EOF
)"
```

- Fallback:

```bash
project="$(glab repo view --output json | jq -r '.path_with_namespace')"
glab api "projects/$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "${project}")/merge_requests/<MR_IID>" \
  --method PUT \
  --raw-field description="$(cat <<'EOF'
<filled template body>
EOF
)"
```