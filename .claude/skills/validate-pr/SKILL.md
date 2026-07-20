---
name: validate-pr
description: Find vulnerabilities or errors in a merge request (checks, scans, merge blockers) and propose fixes.
license: Proprietary
---

## What I do

- Ask which MR to validate (IID or URL).
- List MRs assigned to you so you can pick quickly.
- Inspect CI/check failures, required checks, and merge blockers.
- Look for security signals when available (vulnerability findings / dependency updates).
- Produce an actionable checklist to get the MR merge-ready.

## First question (required)

1. List MRs assigned to the current user:

```bash
glab mr list --assignee @me --state opened --output json | jq -r '.[] | "!\(.iid)\t\(.source_branch) -> \(.target_branch)\t\(.updated_at)\t\(.title)\t\(.web_url)"'
```

2. Ask: "Which MR do you want to validate? (IID or URL)"

Notes:

- If the list is empty, fallback to:

```bash
glab mr list --author @me --state opened --output json | jq -r '.[] | "!\(.iid)\t\(.source_branch) -> \(.target_branch)\t\(.updated_at)\t\(.title)\t\(.web_url)"'
```

## Validation workflow (for MR <IID>)

### 1) Quick MR status

```bash
glab mr view <IID> --output json
```

### 2) Checks / CI failures

```bash
branch="$(glab mr view <IID> --output json | jq -r '.source_branch')"
glab ci status --branch "${branch}"
```

If there are failing runs, inspect logs:

```bash
glab ci list --branch "${branch}"
```

Pick the failing pipeline/job and inspect it. For a pipeline overview:

```bash
glab ci view -b "${branch}"
```

For a failed job log:

```bash
glab ci trace <JOB_ID>
```

### 3) Files changed (to scope the investigation)

```bash
glab mr diff <IID>
git diff --stat main...HEAD
```

### 4) Security signals (best-effort)

Vulnerability findings in GitLab may require Ultimate-tier features and API permissions. Best-effort example:

```bash
project="$(glab repo view --output json | jq -r '.path_with_namespace')"
glab api "projects/$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "${project}")/vulnerability_findings"
```

If the API call returns 403/404, report that vulnerability findings are not accessible with current permissions or project tier and continue with checks/logs.

### 5) Output

Provide:

- The failing checks (name + link) and the root cause from logs.
- Any merge blockers (conflicts, required reviews, missing approvals).
- Any open vulnerability findings (if accessible) with severity.
- Concrete next steps (commands to run locally and files to change).