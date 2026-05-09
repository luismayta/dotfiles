---
name: goji-commit-smart
description: Deterministic multi-commit generator from git working tree. Uses jasper.toml (policy) and .goji.json (domain). Single validation gate + fast commit execution.
license: Proprietary
metadata:
  author: "hadenlabs"
  version: "0.0.0"
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
      - deterministic
      - policy-driven
    mcp:
      preferredServer: git
---

# goji-commit-smart

Deterministic semantic commit partitioning engine.

---

# Inputs

- No inputs
- Input = git working tree

---

# Contract

- `task validate` executes exactly once at start
- If validation fails → abort immediately
- Only sources of truth:
  - `jasper.toml`
  - `.goji.json`
- No external configuration allowed

---

# STEP 0 — Dependency validation

```bash
command -v task >/dev/null 2>&1 || {
  echo "ERROR: task not installed (https://taskfile.dev)"
  exit 1
}

command -v jq >/dev/null 2>&1 || {
  echo "ERROR: jq not installed (https://stedolan.github.io/jq/)"
  exit 1
}

command -v yq >/dev/null 2>&1 || {
  echo "ERROR: yq not installed (https://mikefarah.gitbook.io/yq)"
  exit 1
}
```

---

# STEP 1 — Validate Task system (single execution gate)

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

# STEP 2 — Load configuration (jasper.toml)

```bash
FORMAT=$(yq -p toml '.commit.format' jasper.toml)
STYLE=$(yq -p toml '.commit.style' jasper.toml)

PROJECT_KEY=$(yq -p toml '.issueTracking.projectKey' jasper.toml)

if [ "$FORMAT" = "null" ] || [ "$STYLE" = "null" ]; then
  echo "ERROR: invalid jasper.toml commit config"
  exit 1
fi
```

---

# STEP 3 — Load domain model (.goji.json)

```bash
[ ! -f .goji.json ] && cp <skill_root>/goji.json.tpl .goji.json

jq empty .goji.json || {
  echo "ERROR: invalid .goji.json"
  exit 1
}
```

---

# STEP 4 — Detect git state

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)
git status --porcelain
git diff --name-only
```

---

# STEP 5 — Load domain types

```bash
declare -A TYPE_EMOJI

while read -r name emoji; do
  TYPE_EMOJI[$name]=$emoji
done < <(jq -r '.types[] | "\(.name) \(.emoji)"' .goji.json)

SCOPES=$(jq -r '.scopes[]' .goji.json)
```

---

# STEP 6 — Issue extraction (infobot-driven)

```bash
case "$STYLE" in
  jira)
    ISSUE=$(echo "$BRANCH" | grep -oE "${PROJECT_KEY}-[0-9]+" | head -1)
    ;;
  github|gitlab)
    ISSUE="#$(echo "$BRANCH" | grep -oE '[0-9]+' | head -1)"
    ;;
esac
```

---

# STEP 7 — Detect Git signing capability

```bash
GIT_SIGNING_KEY=$(git config --get user.signingkey)

if [ -n "$GIT_SIGNING_KEY" ]; then
  ENABLE_SIGN=true
else
  ENABLE_SIGN=false
fi
```

---

# STEP 8 — Semantic grouping engine

* group by `(scope, type, intent)`
* enforce `.goji.json`
* no orphan atoms
* fail-fast on ambiguity

---

# STEP 9 — Build commit message

```bash
build_message() {
  TYPE=$1
  SCOPE=$2
  SUBJECT=$3

  EMOJI=${TYPE_EMOJI[$TYPE]}

  case "$STYLE" in
    jira)
      SUBJECT="$ISSUE $SUBJECT"
      ;;
    github|gitlab)
      SUBJECT="$SUBJECT ($ISSUE)"
      ;;
  esac

  echo "$TYPE $EMOJI ($SCOPE): $SUBJECT"
}
```

---

# STEP 10 — Validate commit format

```bash
validate_commit() {
  local msg="$1"

  case "$STYLE" in
    jira)
      PATTERN="^[a-z]+ .+ \\([a-z]+\\): [A-Z]+-[0-9]+ .+"
      ;;
    github|gitlab)
      PATTERN="^[a-z]+ .+ \\([a-z]+\\): .+ \\(#[0-9]+\\)$"
      ;;
  esac

  echo "$msg" | grep -Eq "$PATTERN" || {
    echo "ERROR: invalid commit format"
    exit 1
  }
}
```

---

# STEP 11 — Execution loop

```bash
COUNT=0

for each group:

  MESSAGE=$(build_message "$TYPE" "$SCOPE" "$SUBJECT")

  validate_commit "$MESSAGE"

  git add <files>

  if [ "$ENABLE_SIGN" = true ]; then
    git commit -m "$MESSAGE" --no-verify -S
  else
    git commit -m "$MESSAGE" --no-verify
  fi

  COUNT=$((COUNT+1))
done
```

---

# STEP 12 — Report

```bash
echo ""
echo "Commit Summary"
echo "===================="

i=1
for each group:
  echo "$i. $TYPE ($SCOPE)"
  echo "   -> $SUBJECT"
  i=$((i+1))
done

echo ""
echo "Total commits: $COUNT"
```

---

# Safety rules

- Never commit secrets
- Fail-fast on invalid config
- `.goji.json` = domain authority
- `jasper.toml` = policy authority
- `task validate` runs once and is mandatory