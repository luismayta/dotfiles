---
name: git-release
description: Create consistent releases and changelogs
license: Proprietary
---

## What I do

- Draft release notes from merged PRs
- Propose a version bump
- Provide a copy-pasteable `glab release create` command

## When to use me

Use this when preparing a tagged release. Ask clarifying questions if versioning scheme is unclear.

## Process

1. Run `task validate`
2. Run `git log --oneline $(git describe --tags --abbrev=0)..HEAD`
3. Categorise commits (features, fixes, chores)
4. Determine version bump (major/minor/patch)
5. Generate changelog entry
6. Output the release command

## MR template (when creating an MR)

Use `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md` as the base for the MR body and fill it with the specifics of the change.

Prefer to include:

- Testing: `task validate`
- Migration steps (if any)
- Screenshots placeholders

Example (copy/paste):

```bash
glab mr create --target-branch main --source-branch "${BRANCH}" \
  --title "<title>" \
  --description "$(cat <<'EOF'
## Proposed changes

<describe the big picture and link issues>

Testing:
- `task validate`

Migration steps (if any):
- None

Screenshots:
- [ ] N/A
- [ ] <paste screenshot 1>

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

Example release command:

```bash
glab release create <tag> --notes-file <notes-file>
```
