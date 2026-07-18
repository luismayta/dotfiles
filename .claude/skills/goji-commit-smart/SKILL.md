---
name: goji-commit-smart
description: Multi-commit planner from git working tree. LLM groups changed files into logical commits using codi CLI context and executes them via codi commit.
license: Proprietary
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
- Write a plan to `.codi/build/<name>-<id>.json` (unique via `codi util short-uuid`)
- Execute the plan with `codi commit --file`

---

**Input**: No input required if the working tree has changes. The skill automatically reads the git diff, `.goji.json` (taxonomy), and `codi.toml` (format policy).

If the working tree is clean or has too many changes, I may ask:
> "What do you want to commit? Describe the logical groups you have in mind."

---

**Contract**

- Dependencies validated at load time via `codi doctor --llm` (requires frontmatter)
- If validation fails → abort immediately

---

### STEP 0 — Dependency validation

Run `codi doctor --llm` and review the JSON output. If any critical dependencies are missing, abort.

**Steps**

1. **Run `codi commit context` to load project context**
   ```bash
   codi commit context
   ```
   This returns JSON with:
   - `taxonomy.types`: allowed commit types from `.goji.json` (feat, fix, docs, chore, test, etc.) with their emoji and description
   - `taxonomy.scopes`: allowed scopes (cli, core, opencode, skills, mcp, config, etc.)
   - `taxonomy.typeDetails`: array of `{ name, emoji, code, description }` for each type
   - `files[]`: list of changed files with paths

2. **Validate issue key and classify files by priority tier**

   a) **Validate issue key**: Run the standardized command to derive the issue key:
   ```bash
   codi commit issue-key
   ```
   If the command fails (issueTracking not configured, invalid branch, etc.), abort with:
   > "ERROR: No valid issue key could be derived. Run `codi commit issue-key` for details."

   b) **Classify files by priority tier**: Categorize each changed file from the context:

   | Tier | Name | File Patterns |
   |------|------|---------------|
   | 1 | Tool Configuration | `.pre-commit-config.yaml`, `.ci/**`, `codi.toml`, `.commitlintrc.json`, `.goji.json` |
   | 2 | Infrastructure | `Taskfile.yml`, `Taskfile.yaml`, Nix files, CI/CD configs |
   | 3 | Source Code & Skills | Source code, `skills/*`, tests |
   | 4 | Secondary Artifacts | Documentation (`docs/`), changelogs, OpenSpec archives |

   Sort all changed files by tier order (Tier 1 → 2 → 3 → 4). Files in lower-numbered tiers must be grouped into commits before higher-numbered tiers.

   c) **Group files within each priority tier**: Within each tier, group files into logical commits. For each group:

   - **type**: Pick from `context.taxonomy.types` (feat=new feature, fix=bug fix, docs=documentation, chore=maintenance, test=tests, refactor=restructure, perf=performance, etc.)
   - **scope**: Pick from `context.taxonomy.scopes` that best matches the files' location
   - **subject**: Write a concise conventional-commit subject (max 100 chars). Do NOT include the issue key — `codi commit` handles issue key rendering automatically via its internal renderer (e.g., write `add user login`, not `PE-129 add user login`).
   - **emoji**: The emoji is handled by `codi commit` automatically — do NOT include it in the plan.

   **Grouping heuristics** (applied within each tier):
   - Tier 1 files (`.pre-commit-config.yaml`, `.ci/**`) are ALWAYS the first commit — unconditional priority. They must be staged before any other tier.
   - Files in the same package/app directory → likely same commit
   - Test files matching a source change → group with that source change
   - Unrelated changes in different tiers → separate commits per tier
   - Configuration-only changes within Tier 1 → `chore(config)` type

3. **Generate plan ID and write the plan**

   ```bash
    ID=$(codi util short-uuid)
   ```

   Derive a kebab-case name from the primary intent of the changes (e.g., `add-login`, `skill-reinstall`).

   Combine them: `.codi/build/<name>-<id>.json` (e.g., `add-login-aB3xYz.json`).

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
   PLAN_FILE=".codi/build/${NAME}-${ID}.json"
   # write plan to $PLAN_FILE
   ```

4. **Present the plan to the user for review**

   Show a summary of the planned commits and ask:
   > "Here's the commit plan. Shall I execute it?"

   If the user wants changes, modify the plan JSON and re-present.

5. **Validate and execute the plan**

   Run validation gate immediately before execution:
   ```bash
   task validate
   if [ $? -ne 0 ]; then
     echo "VALIDATION FAILED — aborting execution"
     exit 1
   fi
   ```

   Then execute the plan:
   ```bash
   codi commit --file "$PLAN_FILE"
   ```

   This stages files, builds commit messages using the configured format (`<type> <emoji>(<scope>): <issueKey> <subject>`), and commits with optional sign-off.

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
- Never include the issue key in plan subjects or filenames — the issue key is solely `codi`'s responsibility and is resolved internally by `codi commit`. You MAY derive the issue key from the branch name for validation purposes only.
- If `codi commit` reports errors (e.g., dirty tree, invalid config), show the error and stop — do not force-commit
- Prefer splitting unrelated changes into separate commits over lumping everything into one
