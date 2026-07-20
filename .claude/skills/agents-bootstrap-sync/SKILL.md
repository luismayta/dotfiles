---
name: agents-bootstrap-sync
description: Bootstrap agent configuration and generate AGENTS.md from project config (codi.toml), SCM flow, monorepo structure, MCP ecosystem, and docs/ — template-based and idempotent.
license: Proprietary
metadata:
  author: "codiplab"
  version: "0.4.1"
  opencode:
    emoji: 🔄
triggers:
  - "bootstrap sync"
  - "sync agents"
  - "bootstrap agentes"
  - "agent config"
  - "agent bootstrap"
  - "codi config"
tags:
  - bootstrap
  - configuration
  - sync
  - agents
  - idempotent
  - detection
  - codi
---

# agents-bootstrap-sync

Skill para bootstrap de configuración de agentes y generación de `AGENTS.md` como router semántico basado en `codi.toml` y `docs/`.

---

# Purpose

- Bootstrap de `codi.toml` y `.goji.json`
- Detección dinámica de SCM provider y workflow
- Detección de monorepo (turborepo, nx, pnpm)
- Detección de MCP servers configurados
- Lectura de scopes y tipos de commit desde `.goji.json`
- Generación de `AGENTS.md` como entrypoint enriquecido para agentes
- Enfoque idempotente y seguro

---

# Inputs

- `--force` → sobrescribe archivos existentes
- `DOCS_PATH` (env) → default: `docs/`

---

# Skill Assets

```bash
<skill-root>/
├── AGENTS.md.tpl
├── codi.toml.tpl
├── .goji.json.tpl
```

---

# Flow

---

## STEP 0 — Detection functions

### detect_scm_flow

```bash
detect_scm_flow() {
  local remote
  remote=$(git remote get-url origin 2>/dev/null || echo "")

  local provider=""
  if echo "$remote" | grep -qi "github.com"; then
    provider="github"
  elif echo "$remote" | grep -qi "gitlab.com"; then
    provider="gitlab"
  else
    # fallback to local git dir heuristic
    provider="unknown"
  fi

  local flow=""
  # Check branch names to infer flow
  if git show-ref --verify --quiet refs/heads/develop 2>/dev/null; then
    if git show-ref --verify --quiet refs/heads/main 2>/dev/null ||
       git show-ref --verify --quiet refs/heads/master 2>/dev/null; then
      flow="gitflow"
    fi
  fi
  if [ -z "$flow" ]; then
    flow="${provider}-flow"
  fi

  echo "$provider $flow"
}
```

### detect_monorepo

```bash
detect_monorepo() {
  # Check known monorepo markers (ordered by preference)
  local tool=""
  local markers=""

  if [ -f turbo.json ]; then
    tool="turborepo"
    markers='["turbo.json"]'
  elif [ -f pnpm-workspace.yaml ]; then
    tool="pnpm"
    markers='["pnpm-workspace.yaml"]'
  elif [ -f nx.json ]; then
    tool="nx"
    markers='["nx.json"]'
  fi

  if [ -n "$tool" ]; then
    # Derive domains from workspace configs or use defaults
    local domains='["packages/*", "apps/*", "services/*"]'

    # Try to extract workspace globs from package.json
    if command -v jq &>/dev/null && [ -f package.json ]; then
      local ws
      ws=$(jq -r '.workspaces // .workspaces.packages // empty' package.json 2>/dev/null | head -5 | tr '\n' ' ')
      if [ -n "$ws" ]; then
        domains=$(echo "$ws" | jq -R -c 'split(" ") | map(select(length > 0))' 2>/dev/null || echo "$domains")
      fi
    fi

    echo "true $tool $markers $domains"
  else
    echo "false"
  fi
}
```

### detect_commit_domain

```bash
detect_commit_domain() {
  local scopes="[]"
  local types="[]"

  if [ -f .goji.json ]; then
    scopes=$(jq -r '.scopes // []' .goji.json 2>/dev/null | tr -d ' \n' || echo "[]")
    types=$(jq -r '[.types[].name] // []' .goji.json 2>/dev/null | tr -d ' \n' || echo "[]")
  elif [ -f .goji.json.tpl ]; then
    scopes=$(jq -r '.scopes // []' .goji.json.tpl 2>/dev/null | tr -d ' \n' || echo "[]")
    types=$(jq -r '[.types[].name] // []' .goji.json.tpl 2>/dev/null | tr -d ' \n' || echo "[]")
  fi

  echo "$scopes $types"
}
```

### detect_mcp_ecosystem

```bash
detect_mcp_ecosystem() {
  local mcp_list=""

  # Try opencode.json first
  if [ -f opencode.json ]; then
    mcp_list=$(jq -r '(.mcpServers // {}) | keys | .[]' opencode.json 2>/dev/null)
  fi

  # Fallback: scan .opencode/mcp.json or .opencode/mcp*.json
  if [ -z "$mcp_list" ] && [ -d .opencode ]; then
    mcp_list=$(find .opencode -name "mcp*.json" -maxdepth 1 2>/dev/null | while read -r f; do
      jq -r 'keys | .[]' "$f" 2>/dev/null
    done)
  fi

  if [ -z "$mcp_list" ]; then
    echo "none"
  else
    echo "$mcp_list" | tr '\n' ' ' | xargs
  fi
}
```

---

## STEP 1 — Detect all

```bash
CODI_EXISTS=false
GOJI_EXISTS=false

[ -f codi.toml ] && CODI_EXISTS=true
[ -f .goji.json ] && GOJI_EXISTS=true

# Run all detections
SCM_RESULT=$(detect_scm_flow)
SCM_PROVIDER=$(echo "$SCM_RESULT" | awk '{print $1}')
SCM_FLOW=$(echo "$SCM_RESULT" | awk '{print $2}')

MONOREPO_RESULT=$(detect_monorepo)
MONOREPO_ENABLED=$(echo "$MONOREPO_RESULT" | awk '{print $1}')
MONOREPO_TOOL=$(echo "$MONOREPO_RESULT" | awk '{print $2}')
MONOREPO_MARKERS=$(echo "$MONOREPO_RESULT" | awk '{print $3}')
MONOREPO_DOMAINS=$(echo "$MONOREPO_RESULT" | awk '{print $4}')

COMMIT_RESULT=$(detect_commit_domain)
COMMIT_SCOPES=$(echo "$COMMIT_RESULT" | awk '{print $1}')
COMMIT_TYPES=$(echo "$COMMIT_RESULT" | awk '{print $2}')

MCP_SERVERS=$(detect_mcp_ecosystem)
```

---

## STEP 2 — Bootstrap config

```bash
if [ "$CODI_EXISTS" = false ] || [ "$FORCE" = true ]; then
  cp -rf <skill-root>/codi.toml.tpl codi.toml
  # Merge detected values into codi.toml using yq if available
  if command -v yq &>/dev/null; then
    if [ "$SCM_PROVIDER" != "unknown" ]; then
      yq -i ".scm.provider = \"$SCM_PROVIDER\"" codi.toml
    fi
    if [ -n "$SCM_FLOW" ]; then
      yq -i ".scm.flow = \"$SCM_FLOW\"" codi.toml
    fi
    if [ "$MONOREPO_ENABLED" = "true" ]; then
      yq -i ".monorepo.enabled = true" codi.toml
      if [ -n "$MONOREPO_TOOL" ]; then
        yq -i ".monorepo.tool = \"$MONOREPO_TOOL\"" codi.toml
      fi
    fi
  fi
fi

if [ "$GOJI_EXISTS" = false ] || [ "$FORCE" = true ]; then
  cp -rf <skill-root>/.goji.json.tpl .goji.json
fi
```

---

## STEP 3 — Ensure docs path

```bash
DOCS_PATH=${DOCS_PATH:-docs}

if [ ! -d "$DOCS_PATH" ]; then
  echo "docs/ directory not found, skipping AGENTS.md generation"
  exit 0
fi
```

---

## STEP 4 — Build sections

---

### Usage

```bash
USAGE_SECTION=""
[ -f "$DOCS_PATH/usage.md" ] && USAGE_SECTION="- Usage → $DOCS_PATH/usage.md"
```

---

### Contributing

```bash
CONTRIBUTING_SECTION=""
[ -f "$DOCS_PATH/contributing.md" ] && CONTRIBUTING_SECTION="- Contributing → $DOCS_PATH/contributing.md"
```

---

### Architecture

```bash
ARCHITECTURE_SECTION=""
[ -f "$DOCS_PATH/architecture.md" ] && ARCHITECTURE_SECTION="- Architecture → $DOCS_PATH/architecture.md"
```

---

### ADR

```bash
ADR_SECTION=""

if [ -d "$DOCS_PATH/adr" ]; then
  ADR_FILES=$(find "$DOCS_PATH/adr" -type f -name "*.md" | sort)

  if [ -n "$ADR_FILES" ]; then
    ADR_SECTION="### ADRs"
    while IFS= read -r f; do
      ADR_SECTION="$ADR_SECTION\n- $f"
    done <<< "$ADR_FILES"
  fi
fi
```

---

### Runbooks

```bash
RUNBOOKS_SECTION=""

if [ -d "$DOCS_PATH/runbooks" ]; then
  FILES=$(find "$DOCS_PATH/runbooks" -type f -name "*.md" | sort)

  if [ -n "$FILES" ]; then
    RUNBOOKS_SECTION="### Runbooks"
    while IFS= read -r f; do
      RUNBOOKS_SECTION="$RUNBOOKS_SECTION\n- $f"
    done <<< "$FILES"
  fi
fi
```

---

### Project Structure

```bash
PROJECT_STRUCTURE_SECTION=""

if [ -f codi.toml ]; then
  if [ "$MONOREPO_ENABLED" = "true" ]; then
    PROJECT_STRUCTURE_SECTION="- Monorepo: $MONOREPO_TOOL"
    PROJECT_STRUCTURE_SECTION="$PROJECT_STRUCTURE_SECTION\n- Domains: $MONOREPO_DOMAINS"
  else
    PROJECT_STRUCTURE_SECTION="- Single project"
  fi
fi

[ -n "$PROJECT_STRUCTURE_SECTION" ] && PROJECT_STRUCTURE_SECTION="### Project Structure\n$PROJECT_STRUCTURE_SECTION"
```

---

### SCM & Workflow

```bash
SCM_WORKFLOW_SECTION=""

if [ -f codi.toml ]; then
  SCM_WORKFLOW_SECTION="- Provider: $SCM_PROVIDER"
  SCM_WORKFLOW_SECTION="$SCM_WORKFLOW_SECTION\n- Workflow: $SCM_FLOW"
fi

[ -n "$SCM_WORKFLOW_SECTION" ] && SCM_WORKFLOW_SECTION="### SCM & Workflow\n$SCM_WORKFLOW_SECTION"
```

---

### MCP Ecosystem

```bash
MCP_ECOSYSTEM_SECTION=""

if [ "$MCP_SERVERS" != "none" ]; then
  MCP_ECOSYSTEM_SECTION="- MCP Servers: $MCP_SERVERS"
  MCP_ECOSYSTEM_SECTION="$MCP_ECOSYSTEM_SECTION\n- See opencode.json or .opencode/ for details"
fi

[ -n "$MCP_ECOSYSTEM_SECTION" ] && MCP_ECOSYSTEM_SECTION="### MCP Ecosystem\n$MCP_ECOSYSTEM_SECTION"
```

---

### Commit Convention

```bash
COMMIT_CONVENTION_SECTION=""

if [ -f .goji.json ]; then
  COMMIT_CONVENTION_SECTION="- Scopes: $COMMIT_SCOPES"
  COMMIT_CONVENTION_SECTION="$COMMIT_CONVENTION_SECTION\n- Types: $COMMIT_TYPES"
fi

[ -n "$COMMIT_CONVENTION_SECTION" ] && COMMIT_CONVENTION_SECTION="### Commit Convention\n$COMMIT_CONVENTION_SECTION"
```

---

### General + lightweight classification

```bash
GENERAL_SECTION=""
PROJECT_SECTION=""
MISC_SECTION=""

ALL_DOCS=$(find "$DOCS_PATH" -type f -name "*.md" \
  ! -path "$DOCS_PATH/usage.md" \
  ! -path "$DOCS_PATH/contributing.md" \
  ! -path "$DOCS_PATH/architecture.md" \
  ! -path "$DOCS_PATH/prompts/*" \
  ! -path "$DOCS_PATH/skills/*" \
  ! -path "$DOCS_PATH/adr/*" \
  ! -path "$DOCS_PATH/runbooks/*" | sort)

if [ -n "$ALL_DOCS" ]; then
  while IFS= read -r f; do
    case "$f" in
      *faq*|*troubleshooting*)
        MISC_SECTION="$MISC_SECTION\n- $f"
        ;;
      *authors*|*code_of_conduct*|*disclaimer*)
        PROJECT_SECTION="$PROJECT_SECTION\n- $f"
        ;;
      *)
        GENERAL_SECTION="$GENERAL_SECTION\n- $f"
        ;;
    esac
  done <<< "$ALL_DOCS"

  [ -n "$GENERAL_SECTION" ] && GENERAL_SECTION="### Other Docs$GENERAL_SECTION"
  [ -n "$PROJECT_SECTION" ] && PROJECT_SECTION="### Project Info$PROJECT_SECTION"
  [ -n "$MISC_SECTION" ] && MISC_SECTION="### Troubleshooting & FAQ$MISC_SECTION"
fi
```

---

## STEP 5 — Render template

```bash
awk -v usage="$USAGE_SECTION" \
    -v contributing="$CONTRIBUTING_SECTION" \
    -v architecture="$ARCHITECTURE_SECTION" \
    -v adr="$ADR_SECTION" \
    -v runbooks="$RUNBOOKS_SECTION" \
    -v project_structure="$PROJECT_STRUCTURE_SECTION" \
    -v scm_workflow="$SCM_WORKFLOW_SECTION" \
    -v mcp_ecosystem="$MCP_ECOSYSTEM_SECTION" \
    -v commit_convention="$COMMIT_CONVENTION_SECTION" \
    -v general="$GENERAL_SECTION" \
    -v project="$PROJECT_SECTION" \
    -v misc="$MISC_SECTION" '
{
  gsub(/\{\{USAGE\}\}/, usage)
  gsub(/\{\{CONTRIBUTING\}\}/, contributing)
  gsub(/\{\{ARCHITECTURE\}\}/, architecture)
  gsub(/\{\{ADR\}\}/, adr)
  gsub(/\{\{RUNBOOKS\}\}/, runbooks)
  gsub(/\{\{PROJECT_STRUCTURE\}\}/, project_structure)
  gsub(/\{\{SCM_WORKFLOW\}\}/, scm_workflow)
  gsub(/\{\{MCP_ECOSYSTEM\}\}/, mcp_ecosystem)
  gsub(/\{\{COMMIT_CONVENTION\}\}/, commit_convention)
  gsub(/\{\{GENERAL\}\}/, general)
  gsub(/\{\{PROJECT\}\}/, project)
  gsub(/\{\{MISC\}\}/, misc)
  print
}' <skill-root>/AGENTS.md.tpl > AGENTS.md.tmp
```

---

## STEP 6 — Safe write

```bash
if [ ! -f AGENTS.md ]; then
  mv AGENTS.md.tmp AGENTS.md

elif grep -q "AUTO-GENERATED: agents-bootstrap-sync" AGENTS.md; then
  mv AGENTS.md.tmp AGENTS.md

elif [ "$FORCE" = true ]; then
  mv AGENTS.md.tmp AGENTS.md

else
  echo "AGENTS.md exists and is user-managed. Skipping."
  rm AGENTS.md.tmp
fi
```

---

# Outputs

- codi.toml
- .goji.json
- AGENTS.md

---

# Principles

- codi.toml as single source of truth
- Docs as control plane
- AGENTS.md como routing layer
- Dynamic detection over static config
- Idempotent & safe
- Zero external dependencies
