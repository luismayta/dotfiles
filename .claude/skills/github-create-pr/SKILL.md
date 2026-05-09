---
name: github-create-pr
description: Validate, push the current branch, and create a GitHub pull request from the current diff
triggers:
  - "Use the skill `github-create-pr`"
  - "Create a GitHub pull request from this branch"
  - "Open a PR and push the current branch"
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
---

## What I do

- Run `task validate` before opening the PR.
- Inspect `main...HEAD` changes and recent commits to summarize the branch.
- Check whether a PR already exists for the current branch and stop if one is already open.
- Push the current branch, including setting upstream when needed.
- Build a PR title and description from `.github/PULL_REQUEST_TEMPLATE.md`.
- Create the PR with `gh pr create` and return the URL.

## When to use me

Use this when your branch is ready for review and you want a consistent GitHub pull request created automatically.

## Process

1. Run `task validate`
2. Collect branch context:
   - `git diff main...HEAD --stat`
   - `git diff main...HEAD`
   - `git log main...HEAD --oneline`
3. Check whether a PR already exists for the current branch:
   - `gh pr list --head "$(git rev-parse --abbrev-ref HEAD)" --json number,title,url`
   - If one exists, report its URL and stop
4. Push the current branch:
   - If upstream is not set: `git push -u origin HEAD`
   - Otherwise: `git push`
5. Generate the PR title and description from `.github/PULL_REQUEST_TEMPLATE.md`
6. Fill the PR body with:
   - Summary of changes based on `git diff main...HEAD --stat` and `git diff main...HEAD`
   - Testing notes including `task validate`
   - Migration steps (if any)
   - Screenshots placeholders
   - Types of changes
   - Checklist items that are true
7. Create the pull request automatically with `gh pr create`
8. Return the PR URL after creation

## PR template guidance

Use `.github/PULL_REQUEST_TEMPLATE.md` as the base for the PR body.

Prefer to include:

- Testing: `task validate`
- Migration steps (if any)
- Screenshots placeholders

Example (copy/paste):

```bash
gh pr create --base main --head "$(git rev-parse --abbrev-ref HEAD)" \
  --title "<title>" \
  --body "$(cat <<'EOF'
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