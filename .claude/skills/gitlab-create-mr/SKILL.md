---
name: gitlab-create-mr
description: Validate, push the current branch, and create a GitLab merge request from the current diff
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
---

## What I do

- Run `task validate` before opening the MR.
- Inspect `main...HEAD` changes and recent commits to summarize the branch.
- Check whether an MR already exists for the current branch and stop if one is already open.
- Push the current branch, including setting upstream when needed.
- Build an MR title and description from `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md`.
- Create the MR with `glab mr create` and return the URL.

## When to use me

Use this when your branch is ready for review and you want a consistent GitLab merge request created automatically.

## Process

1. Run `task validate`
2. Collect branch context:
   - `git diff main...HEAD --stat`
   - `git diff main...HEAD`
   - `git log main...HEAD --oneline`
3. Check whether an MR already exists for the current branch:
   - `glab mr list --source-branch "$(git rev-parse --abbrev-ref HEAD)" --output json`
   - If one exists, report its URL and stop
4. Push the current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
5. Generate the MR title and description from `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md`
6. Fill the MR body with:
   - Summary of changes based on `git diff main...HEAD --stat` and `git diff main...HEAD`
   - Testing notes including `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes
   - Checklist items that are true
7. Create the merge request automatically with `glab mr create`
8. Return the MR URL after creation

## MR template guidance

Use `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` as the base for the MR body.

Prefer to include:

- Testing: `task validate`
- Migration steps (if any)
- Screenshots placeholders

Example (copy/paste):

```bash
glab mr create --target-branch main --source-branch "$(git rev-parse --abbrev-ref HEAD)" \
  --title "<title>" \
  --description "$(cat <<'EOF'
## Proposed changes

<describe the branch and the why>

### Summary of changes

- <change 1>
- <change 2>

### Testing

- `task validate`

### Migration steps

- None

### Screenshots

- [x] N/A
- [ ] Screenshot 1

## Types of changes

- [ ] Bugfix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)

## Checklist

- [ ] I have read the [CONTRIBUTING](/docs/contributing.md) doc
- [ ] Lint and unit tests pass locally with my changes
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] I have added necessary documentation (if appropriate)
- [ ] Any dependent changes have been merged and published in downstream modules

## Further comments

<optional>
EOF
)"
```