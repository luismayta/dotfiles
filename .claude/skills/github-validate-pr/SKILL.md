---
name: github-validate-pr
description: Find vulnerabilities or errors in a pull request (checks, scans, merge blockers) and propose fixes.
triggers:
  - "Use the skill `github-validate-pr`"
  - "Validate a pull request for checks and blockers"
  - "Review PR CI status and merge blockers"
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
---

## What I do

- Ask which PR to validate (number or URL).
- List PRs assigned to you so you can pick quickly.
- Inspect CI/check failures, required checks, and merge blockers.
- Look for security signals when available (vulnerability findings / dependency updates).
- Produce an actionable checklist to get the PR merge-ready.

## First question (required)

1. List PRs assigned to the current user:

```bash
gh pr list --assignee "@me" --state open --json number,title,url,headRefName,baseRefName,updatedAt
```

2. Ask: "Which PR do you want to validate? (number or URL)"

Notes:

- If the list is empty, fallback to:

```bash
gh pr list --author "@me" --state open --json number,title,url,headRefName,baseRefName,updatedAt
```

## Validation workflow (for PR <NUMBER>)

### 1) Quick PR status

```bash
gh pr view <NUMBER> --json number,title,state,body,url,headRefName,baseRefName,mergeable
```

### 2) Checks / CI failures

```bash
gh run list --branch "$(gh pr view <NUMBER> --json headRefName --jq '.headRefName')" --json status,conclusion,name,url
```

If there are failing runs, inspect logs:

```bash
gh run list --branch "$(gh pr view <NUMBER> --json headRefName --jq '.headRefName')" --json status,conclusion,name,url
```

Pick the failing run/job and inspect it. For a run overview:

```bash
gh run view <RUN_ID> --json jobs,status,conclusion,name,url
```

For a failed job log:

```bash
gh run view <RUN_ID> --job <JOB_ID> --log
```

### 3) Files changed (to scope the investigation)

```bash
gh pr diff <NUMBER>
git diff --stat main...HEAD
```

### 4) Security signals (best-effort)

Vulnerability findings in GitHub may require specific permissions. Best-effort example:

```bash
owner="$(gh repo view --json owner --jq '.owner.login')"
repo="$(gh repo view --json name --jq '.name')"
gh api "repos/${owner}/${repo}/dependabot/alerts"
```

If the API call returns 403/404, report that vulnerability findings are not accessible with current permissions and continue with checks/logs.

### 5) Output

Provide:

- The failing checks (name + link) and the root cause from logs.
- Any merge blockers (conflicts, required reviews, missing approvals).
- Any open vulnerability findings (if accessible) with severity.
- Concrete next steps (commands to run locally and files to change).