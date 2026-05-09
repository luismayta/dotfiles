---
name: agents-bootstrap-sync
description: Bootstrap agent configuration and generate AGENTS.md from docs using a template-based, idempotent approach without external templating engines.
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
  opencode:
    emoji: 🔄
triggers:
  - "bootstrap sync"
  - "sync agents"
  - "bootstrap agentes"
  - "agent config"
  - "agent bootstrap"
tags:
  - bootstrap
  - configuration
  - sync
  - agents
  - idempotent
---

---

# agents-bootstrap-sync

Skill para bootstrap de configuración de agentes y generación de `AGENTS.md` como router semántico basado en `docs/`.

---

# Purpose

- Bootstrap de `jasper.toml` y `.goji.json`
- Generación de `AGENTS.md` como entrypoint para agentes
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
├── jasper.toml.tpl
├── .goji.json.tpl
```

---

# Flow

---

## STEP 1 — Detect config

```bash
JASPER_EXISTS=false
GOJI_EXISTS=false

[ -f jasper.toml ] && JASPER_EXISTS=true
[ -f .goji.json ] && GOJI_EXISTS=true
```

---

## STEP 2 — Bootstrap config

```bash
if [ "$JASPER_EXISTS" = false ] || [ "$FORCE" = true ]; then
  cp -rf <skill-root>/jasper.toml.tpl jasper.toml
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
    -v general="$GENERAL_SECTION" \
    -v project="$PROJECT_SECTION" \
    -v misc="$MISC_SECTION" '
{
  gsub(/\{\{USAGE\}\}/, usage)
  gsub(/\{\{CONTRIBUTING\}\}/, contributing)
  gsub(/\{\{ARCHITECTURE\}\}/, architecture)
  gsub(/\{\{ADR\}\}/, adr)
  gsub(/\{\{RUNBOOKS\}\}/, runbooks)
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

- jasper.toml
- .goji.json
- AGENTS.md

---

# Principles

- Docs as control plane
- AGENTS.md como routing layer
- Idempotent & safe
- Zero dependencies