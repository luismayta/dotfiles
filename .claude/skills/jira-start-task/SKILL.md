---
name: jira-start-task
description: Resolve a Jira issue, ensure the correct branch, generate an OpenSpec prompt, and optionally enrich context using obsidian MCP.
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: 🎯
    triggers:
      - "usa el skill jira-start-task"
      - "empezar tarea jira"
      - "trabajar en issue"
      - "generar prompt openspec"
    tags:
      - jira-cloud
      - git
      - workflow
      - openspec
      - mcp
      - obsidian
    mcp:
      preferredServer: jira
---

# jira-start-task

Starts work on a Jira issue and generates an OpenSpec prompt ready for execution.

---

## Template Resolution

Path:

```text
<skill_root>/prompt.md.tpl
```

Rules:

- MUST exist
- NO fallback allowed

---

## Flow

---

## 1. Resolve Issue

### If `issueKey` is provided

- Fetch via Jira MCP

### If NOT provided

- Read `jasper.toml`
- Get `issueTracking.projectKey`

If missing:

```text
jasper.toml not found. Provide issueKey or configure projectKey.
```

Run JQL:

```jql
project = <PROJECT_KEY>
AND assignee = currentUser()
AND statusCategory != Done
ORDER BY updated DESC
```

---

## 2. Fetch Issue

Retrieve:

- key
- title
- description

Fail if not found.

---

## 3. Git (Deterministic)

Branch:

```text
feature/<ISSUE-KEY>
```

Rules:

- MUST ensure branch before processing
- checkout if exists
- create if not

---

## 4. Parsing

Extract:

- Scenario
- Acceptance Tests
- Sources
- Context Queries

Fallback:

- raw_description

---

## 5. Content Extraction

### Context Queries

Pattern:

```text
mcp obsidian: <query>
```

---

## 6. Data Contract

```yaml
issue:
  key: string
  title: string

content:
  scenario: string
  acceptance_tests: string[]
  sources: string[]
  context_queries: string[]
  raw_description: string
```

---

# 7. Enrichment (Obsidian MCP - Smart Context)

This step enriches the prompt with **relevant, human-readable context** from the Obsidian vault.

---

## Execution Rule

Run ONLY if:

- context_queries NOT empty

---

## MCP Flow (Per Query)

For each query:

---

### 1. Search

Primary search tool:

- `obsidian_obsidian_simple_search`

Optional advanced search (when needed for narrower matching):

- `obsidian_obsidian_complex_search`

---

### 2. Selection

The system MUST:

- rank results by textual relevance to the query
- deduplicate by file path (one entry per file)
- select top 3-5 files per query
- require valid `selected_path`

---

### 3. Fetch File Content

The system MUST fetch selected files using:

- `obsidian_obsidian_get_file_contents` (single file), or
- `obsidian_obsidian_batch_get_file_contents` (multiple files)

with:

- selected_path: <vault_relative_file_path>

---

### 4. Summarization (CRITICAL)

The system MUST transform fetched note content into a concise summary.

Rules:

- MUST extract only relevant parts for the scenario
- MUST remove noise (excess formatting, unrelated sections)
- MUST be readable plain text
- MUST be 3-6 bullet points
- MUST focus on actionable rules / patterns

---

### 5. Fallback

If search yields no usable files, or selected paths cannot be fetched:

- list vault files with `obsidian_obsidian_list_files_in_vault`
- optionally narrow scope with `obsidian_obsidian_list_files_in_dir`
- retry search/fetch with refined query or narrowed directory scope

---

## Enrichment Output

```yaml
enrichment:
  status: "applied" | "failed" | "skipped_no_context_queries" | "skipped_obsidian_unavailable"
  reason: string
  context_queries: string[]
  mcp:
    - query: string
      tool: "obsidian_obsidian_get_file_contents" | "obsidian_obsidian_batch_get_file_contents"
      selected_path: string
      result: string  # summarized context
      error?: string
```

---

## Rules

- MUST NOT modify original content
- MUST continue on errors
- MUST always return enrichment block

---

## 8. Render Template

Inputs:

- issue
- content
- enrichment

---

## 9. Output

```text
docs/prompts/openspec/<ISSUE-KEY>.md
```

---

## Validation

Output MUST:

- be valid OpenSpec prompt
- use MUST / SHOULD / MAY

---

## Debug

- issue source
- branch
- enrichment status