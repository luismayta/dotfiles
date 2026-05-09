---
name: gitlab-update-mr
description: Push branch commits and update the existing MR body safely (prefer REST API)
triggers:
  - "Use the skill `gitlab-update-mr`"
  - "Refresh the existing merge request description"
  - "Update the MR body to match the latest diff"
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
---

## What I do

- Validate changes locally.
- Push the current branch (handles unset upstream).
- Detect the PR for the current branch.
- Regenerate the PR body from `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` using the current `main...HEAD` diff.
- Update the PR body using `glab mr update` (fallback to `glab api`).

## When to use me

Use this when you already have a PR open and need to refresh its description to match the latest branch changes.

## Process

1. Run `task validate`
2. Collect context:
   - `git diff main...HEAD --stat`
   - `git diff main...HEAD`
   - `git log main...HEAD --oneline`
3. Push current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
4. Detect PR:
   - Prefer: `glab mr view "$(git rev-parse --abbrev-ref HEAD)" --json number,title,url`
   - Fallback: `glab mr list --head "$(git rev-parse --abbrev-ref HEAD)" --json number,title,url`
5. Generate updated PR body (based on `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md`) and fill:
   - Proposed changes: bullets derived from `main...HEAD` diff (group by area; reference key paths)
   - Testing: include `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes: mark what applies
   - Checklist: mark what is true
6. Update PR body:
   - Prefer:

```bash
glab mr edit <PR_NUMBER> --body "$(cat <<'EOF'
<filled template body>
EOF
)"
```

- Fallback:

```bash
owner="$(gh repo view --json owner --jq '.owner.login')"
repo="$(gh repo view --json name --jq '.name')"
gh api "repos/${owner}/${repo}/pulls/<PR_NUMBER>" \
  --method PATCH \
  --field body="$(cat <<'EOF'
<filled template body>
EOF
)"
```