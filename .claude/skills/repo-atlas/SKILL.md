---
name: repo-atlas
description: Language-agnostic repository codemap generator and structural analyzer powered by cartographer engine
license: Proprietary
metadata:
  author: "architecture"
  version: "0.0.0"
  opencode:
    emoji: 🧠
    mcp:
      preferredServer: git
---

# Repo Atlas Skill

You help users understand and map repositories by generating hierarchical codemaps using the `cartographer.py` engine.

This skill is **language-agnostic**, **monorepo-aware**, and works incrementally via file change detection.
The bundled engine writes deterministic `codemap.md` files from the currently tracked source files.

---

# Skill Assets

```bash
<skill-root>/
├── scripts/
│   └── cartographer.py
```

---

# When to Use

- Understand an unfamiliar repository
- Generate architecture documentation
- Prepare context for implementation tasks
- Analyze structure before refactoring

---

# Workflow

## Step 0: Load Config (Optional)

Check:

```
.slim/atlas.config.json
```

If exists:

- Override:
  - include
  - exclude
  - domains

---

## Step 1: Detect Repository Type

Inspect root:

- Node → `package.json`
- Python → `pyproject.toml`, `requirements.txt`
- Go → `go.mod`
- Java → `pom.xml`, `build.gradle`
- Rust → `Cargo.toml`

---

## Step 2: Detect Monorepo

Check:

- `pnpm-workspace.yaml`
- `turbo.json`
- `nx.json`

If found:

- Default domains are expanded from directories that actually exist under:
  - `apps/*`
  - `packages/*`
  - `services/*`

Examples:

- `apps/web`
- `packages/shared`
- `services/api`

Else:

- Single project

---

## Step 3: Build Patterns

### Include (fallback)

```
**/*.{ts,js,py,go,java}
```

### Exclude

```
**/*.test.*
**/*.spec.*
**/*_test.*
tests/**
__tests__/**
docs/**
**/*.md
dist/**
build/**
target/**
node_modules/**
venv/**
.venv/**
```

---

## Step 4: Check State

```
.slim/cartography.json
```

If exists → skip init

---

## Step 5: Init

```bash
python3 "<skill-root>/scripts/cartographer.py" init \
  --root ./ \
  --include "**/*.{ts,js,py,go,java}" \
  --exclude "**/*.test.*" \
  --exclude "**/*.spec.*" \
  --exclude "**/*_test.*" \
  --exclude "tests/**" \
  --exclude "__tests__/**" \
  --exclude "docs/**" \
  --exclude "**/*.md" \
  --exclude "dist/**" \
  --exclude "build/**" \
  --exclude "target/**" \
  --exclude "node_modules/**" \
  --exclude "venv/**" \
  --exclude ".venv/**"
```

---

## Step 6: Detect Changes

```bash
python3 "<skill-root>/scripts/cartographer.py" changes --root ./ --json
```

The change report surfaces:

- added / removed / modified files
- affected folders (including ancestors)
- affected modules/domains

---

## Step 7: Update Codemaps

- Regenerate root codemap every run
- Regenerate affected folder codemaps from actual tracked files
- Remove stale folder codemaps when a tracked scope disappears

---

## Step 8: Persist

```bash
python3 "<skill-root>/scripts/cartographer.py" update --root ./ --json
```

---

## Step 9: Build Root Atlas

Root `codemap.md` must include:

- Project Responsibility
- Entry Points
- Directory Map

These sections are populated from tracked files and detected domains, not empty placeholders.

---

# Codemap Contract

Each folder must define:

- Responsibility
- Design
- Flow
- Integration

Each section must be non-empty and derived from files in that folder scope.

---

# Explorer Rules

- Only read assigned folder
- Do not scan entire repo
- Do not guess
- Write only codemap

---

# Config File (Optional)

`.slim/atlas.config.json`

```json
{
  "include": ["**/*.ts"],
  "exclude": ["**/*.spec.ts"],
  "domains": ["apps/*", "packages/*"]
}
```

`domains` supports glob patterns. The engine expands them to real folders before scanning.

---

# CLI Notes

- `init` → detects repo type/domains, creates state, and generates all codemaps
- `changes` → compares current files to `.slim/cartography.json`
- `update` → refreshes state and regenerates root + affected folder codemaps
- `--json` → returns machine-readable output for automation/tests