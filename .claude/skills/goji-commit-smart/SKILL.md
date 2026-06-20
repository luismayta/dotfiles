---
name: goji-commit-smart
description: Multi-commit planner from git working tree. LLM groups changed files into logical commits using codi CLI context and executes them via codi commit.
license: Proprietary
compatibility: Requires codi CLI (codi commit context, codi commit --file).
metadata:
  author: "codiplab"
  version: "0.4.1"
  opencode:
    emoji: 🧠
    triggers:
      - "goji commit"
      - "commit smart"
      - "create commits"
      - "organize commits"
    tags:
      - git
      - commits
      - grouping
      - llm-orchestrated
      - codi
---

LLM-orchestrated commit planner — analyzes your git working tree, groups files into logical commits, and executes them via `codi commit`.

I'll:
- Load your project's commit taxonomy (types, scopes, format policy)
- Analyze changed files and group them by logical concern
- Assign conventional-commit type, scope, and subject per group
- Write a plan to `.codi/build/<name>.json`
- Execute the plan with `codi commit --file`

---

**Input**: No input required if the working tree has changes. The skill automatically reads the git diff, `.goji.json` (taxonomy), and `codi.toml` (format policy).

If the working tree is clean or has too many changes, I may ask:
> "What do you want to commit? Describe the logical groups you have in mind."

---

**Contract**

- `task validate` executes exactly once at start
- If validation fails → abort immediately

---

### STEP 0 — Dependency validation

```bash
command -v task >/dev/null 2>&1 || {
  echo "ERROR: task not installed (https://taskfile.dev)"
  exit 1
}
```

---

### STEP 1 — Validate Task system (single execution gate)

```bash
if [ ! -f Taskfile.yml ] && [ ! -f Taskfile.yaml ]; then
  echo "ERROR: Taskfile not found"
  exit 1
fi

task --list | grep -q "^validate" || {
  echo "ERROR: task validate not defined"
  exit 1
}

echo "Running task validate..."

task validate
if [ $? -ne 0 ]; then
  echo "VALIDATION FAILED"
  exit 1
fi

echo "Validation passed"
```

---

**Steps**

2. **Run `codi commit context` to load project context**
   ```bash
   codi commit context
   ```
   This returns JSON with:
   - `taxonomy.types`: allowed commit types from `.goji.json` (feat, fix, docs, chore, test, etc.) with their emoji and description
   - `taxonomy.scopes`: allowed scopes (cli, core, opencode, skills, mcp, config, etc.)
   - `taxonomy.typeDetails`: array of `{ name, emoji, code, description }` for each type
   - `files[]`: list of changed files with paths

3. **Analyze context and group files into logical commits**

   Group files that belong to the same logical change. For each group:

   - **type**: Pick from `context.taxonomy.types` (feat=new feature, fix=bug fix, docs=documentation, chore=maintenance, test=tests, refactor=restructure, perf=performance, etc.)
   - **scope**: Pick from `context.taxonomy.scopes` that best matches the files' location
   - **subject**: Write a concise conventional-commit subject (max 100 chars). Do NOT include the issue key — `codi commit` handles issue key rendering automatically via its internal renderer (e.g., write `add user login`, not `PE-123 add user login`).
   - **emoji**: The emoji is handled by `codi commit` automatically — do NOT include it in the plan.

   **Grouping heuristics**:
   - Files in the same package/app directory → likely same commit
   - Configuration files (`.json`, `.toml`, `.yaml`) → `chore(config)` or separate commit
   - Test files matching a source change → group with that source change
   - Unrelated changes in different domains → separate commits

4. **Write the plan to `.codi/build/<name>.json`**

   Derive a kebab-case name from the primary intent of the changes (e.g., `add-login`, `skill-reinstall`).

   Do NOT include the issue key in the plan filename — the issue key is `codi`'s responsibility.

   Plan JSON structure (subjects are plain — no issue key prefix):
   ```json
   {
     "commits": [
       {
         "type": "feat",
         "scope": "core",
         "subject": "add user authentication middleware",
         "files": ["src/auth/middleware.ts", "src/auth/types.ts"]
       },
       {
         "type": "chore",
         "scope": "config",
         "subject": "update dependencies",
         "files": ["package.json", "pnpm-lock.yaml"]
       }
     ]
   }
   ```

   Ensure the `.codi/build/` directory exists:
   ```bash
   mkdir -p .codi/build
   ```

5. **Present the plan to the user for review**

   Show a summary of the planned commits and ask:
   > "Here's the commit plan. Shall I execute it?"

   If the user wants changes, modify the plan JSON and re-present.

6. **Execute the plan**
   ```bash
   codi commit --file .codi/build/<name>.json
   ```

   This stages files, builds commit messages using the configured format (`<type> <emoji>(<scope>): <issueId> <subject>`), and commits with optional sign-off.

   If `codi commit --file` is not available (e.g., `error: unknown option '--file'`):
   - This is a **blocker**. Do NOT manually execute commits.
   - The agent does not handle issue keys, emojis, or commit format rendering — those are `codi`'s responsibility.
   - Report the error and stop.

**Output**

After execution, summarize:
- Branch name
- Number of commits created
- For each commit: type, scope, subject, and files
- Any warnings (e.g., untracked files not included)

**Plan JSON Structure Reference**

| Field | Type | Description |
|-------|------|-------------|
| `commits[].type` | string | Conventional commit type from `.goji.json` types list |
| `commits[].scope` | string | Scope from `.goji.json` scopes list |
| `commits[].subject` | string | Commit subject (max 100 chars), plain — no issue key prefix |
| `commits[].files` | string[] | File paths to include in this commit |

**Guardrails**
- Never include secrets, tokens, or credentials in commit subjects or plan files
- Never create empty commits (a commit must have at least one file)
- Never modify files outside the git working tree
- Validate each commit has: type (from taxonomy), scope (from taxonomy), subject, and at least 1 file
- A file must appear in exactly one commit — no duplicate file entries across commits
- If the plan file already exists, confirm with the user before overwriting
- Never derive, include, or reference the issue key. The issue key is solely `codi`'s responsibility and is resolved internally by `codi commit`
- If `codi commit` reports errors (e.g., dirty tree, invalid config), show the error and stop — do not force-commit
- Prefer splitting unrelated changes into separate commits over lumping everything into one
