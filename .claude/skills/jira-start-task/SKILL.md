---
name: jira-start-task
description: Resolve a Jira issue, ensure the correct branch, generate an OpenSpec prompt, and enrich context using Obsidian MCP for documentation and CodeGraph MCP for structural code analysis.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.5.0"
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
      - codegraph
      - enrichment
    mcp:
      preferredServer: [jira, codegraph]
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

- Read `codi.toml`
- Get `issueTracking.projectKey`

If missing:

```text
codi.toml not found. Provide issueKey or configure projectKey.
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



## 3. Parsing

Extract:

- Scenario
- Acceptance Tests
- Sources
- Context Queries
- Code Symbols (via lexical heuristics)

Fallback:

- raw_description

---

## 4. Content Extraction

### Context Queries

Pattern:

```text
mcp obsidian: <query>
```

---

### Code Symbols

The system MUST extract candidate symbols from issue title and description:

Lexical heuristics:
- PascalCase words → class/component names (e.g., "AuthService", "UserController")
- camelCase words → function/variable names (e.g., "getUser", "validateToken")
- Technical terms → "API", "service", "endpoint", "middleware", "handler", "controller", "model", "route", "schema", "mutation", "query"

Fallback:
- empty array [] if no matches

---

## 5. Data Contract

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
  extracted_symbols: string[]  # from lexical heuristic extraction
```

---

codegraph_enrichment:
  status: "applied" | "partial" | "skipped_no_index" | "skipped_no_symbols"
  queries: string[]
  mcp:
    - tool: "codegraph_explore" | "codegraph_search" | "codegraph_node" | "codegraph_callers" | "codegraph_callees"
      query: string
      result: string
      error?: string

---

# 6. Enrichment (Obsidian MCP - Smart Context)

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

# 7. Enrichment (CodeGraph MCP - Structural Context)

This step enriches the prompt with **structural code context** from the codebase via CodeGraph MCP queries.

---

## Execution Rule

Run ALWAYS — unconditional (unlike Obsidian which requires context_queries).

---

## Symbol Extraction

Before querying, extract symbols from the issue title and description using lexical heuristics (see Parsing step). Feed extracted symbols as search queries.

---

## MCP Flow

---

### 1. codegraph_explore (Primary — most information per call)

Use when extracted symbols suggest a bounded code area.

Execution:
- Single symbol: call `codegraph_explore` with that symbol as the query
- Multiple symbols: call once with up to 3 symbols joined
- Result limit: max 12 files

---

### 2. codegraph_search

Use when symbol extraction produces names but bounded area is unknown.

Execution:
- Call `codegraph_search` with symbol name and optional kind filter
- Result limit: top 10 matches
- Follow up with `codegraph_node` or `codegraph_explore` if relevant

---

### 3. codegraph_node

Use when the issue directly references a symbol (file:line format, explicit class/function name).

Execution:
- includeCode: true
- Include full symbol source in output
- Annotate with file path, line range, and callers/callees counts

---

### 4. codegraph_callers

Use when the issue implies modifying an existing symbol.

Execution:
- Call `codegraph_callers` for the target symbol
- Limit: 20 callers
- Include in output to show what would break

---

### 5. codegraph_callees

Use when the issue involves adding new functionality or refactoring.

Execution:
- Call `codegraph_callees` for the relevant symbol
- Include dependency relations in output

---

## Summarization

The system MUST transform raw CodeGraph output into concise summaries:

- Explore results: extract symbol definitions, signatures, key structural relationships
- Node results: include full symbol body in fenced code block with file header
- Error results: capture error message and continue with next tool

---

## Fallback

If CodeGraph MCP index returns "not initialized":
- Set status: "skipped_no_index"
- Continue flow without error

If no symbols extracted:
- Set status: "skipped_no_symbols"
- Continue flow without error

If some tools fail and others succeed:
- Set status: "partial"
- Include successful results + error messages

---

## 8. Render Template

Inputs:

- issue
- content
- enrichment
- codegraph_enrichment

---

## 9. Output

Ensure output directory exists:

```bash
mkdir -p .codi/jira/issues/prompts
```

Output path:

```text
.codi/jira/issues/prompts/<ISSUE-KEY>.md
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