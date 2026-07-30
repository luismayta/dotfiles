---
type: Guide
title: Implement Tool in Module
description: Guide for implementing tools within modules
tags: [guide, tool, module]
---

# How to Implement a Tool in a Module

This guide explains how to add a new tool to any module following the established three-layer architecture pattern. Each tool integrates through config variables, internal logic, and a public API — all following consistent conventions. The devops module and notify module serve as reference implementations.

## Table of Contents

- [Overview](#overview)
- [File Structure](#file-structure)
- [Step 1: Config Layer](#step-1-config-layer)
- [Step 2: Internal Layer](#step-2-internal-layer)
- [Step 3: Public Layer](#step-3-public-layer)
- [Step 4: Registration](#step-4-registration)
- [Step 5: Testing](#step-5-testing)
- [Checklist](#checklist)
- [References](#references)

---

## Overview

### Three-Layer Architecture

Every tool follows the same chain:

```
config/   → environment variables and tool settings
internal/ → private implementation (install, load, helpers)
pkg/      → public API functions (install, upgrade, post_install)
```

**Layer rules:**

| Layer | Contains | Who calls it |
|-------|----------|-------------|
| `config/` | `export` env vars with `DEVOPS_<TOOL>_` prefix | Shell config, user overrides |
| `data/` | Templates and config files for rsync | internal/ sync functions |
| `internal/` | Functions prefixed `devops::<tool>::internal::` | Only `pkg/` functions |
| `pkg/` | Functions prefixed `devops::<tool>::` | End user |

### Two Integration Patterns

Tools fall into two categories based on shell integration needs:

| Pattern | When to Use | Example |
|---------|-------------|---------|
| **Shell hooks** | Tool provides shell integration (keybindings, history, completions) | atuin |
| **PATH-only** | Tool is a standalone CLI without shell integration | bruno |

**Decision tree:**

```
Does your tool provide shell hooks? (init zsh, completions, keybindings)
├─ Yes → Use eval pattern (see atuin example)
└─ No  → Use PATH-only pattern (see bruno example)
```

### Template Rendering Pattern

For tools with config files containing sensitive values (tokens, keys), use **gomplate** instead of shell heredoc:

```
Template (data/noti/noti.yaml.tpl)  →  gomplate  →  Output file
```

```zsh
# ❌ Don't — shell interpolates secrets
cat > config.yaml <<EOF
token: "${TOKEN}"
EOF

# ✅ Do — gomplate reads env vars safely
gomplate -f data/<tool>/<tool>.yaml.tpl -o ~/.config/<tool>/config.yaml
```

Variables referenced in templates use `{{ getenv "VAR_NAME" }}` syntax.

---

## File Structure

### Complete Structure

```
zsh/modules/devops/
├── config/
│   ├── base.zsh          ← DEVOPS_TOOLS registration
│   └── <tool>.zsh        ← Tool-specific variables
├── data/
│   └── <tool>/           ← Templates and config files for rsync/sync
├── internal/
│   └── <tool>.zsh        ← Private implementation
└── pkg/
    └── <tool>.zsh        ← Public API functions
```

### Reference Implementations

**Atuin** (shell hooks pattern):
```
zsh/modules/devops/
├── config/atuin.zsh      ← DEVOPS_ATUIN_* variables
├── internal/atuin.zsh    ← load, install, upgrade, factory
└── pkg/atuin.zsh         ← install, upgrade, post_install
```

**Bruno** (PATH-only pattern):
```
zsh/modules/devops/
├── config/bruno.zsh      ← DEVOPS_BRUNO_* variables
├── internal/bruno.zsh    ← load, install, sync
└── pkg/bruno.zsh         ← load, bru::install, sync
```

---

## Step 1: Config Layer

Create `config/<tool>.zsh` with environment variables.

### Pattern

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# <Tool> configuration
export DEVOPS_<TOOL>_PACKAGE_NAME=<tool>
export DEVOPS_<TOOL>_INSTALL_CMD="<command>"
export DEVOPS_<TOOL>_CONFIG_DIR="${HOME}/.config/<tool>"
```

### Example: Atuin (shell hooks)

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Atuin configuration
export DEVOPS_ATUIN_PACKAGE_NAME=atuin
export DEVOPS_ATUIN_INSTALL_URL="https://setup.atuin.sh"
export DEVOPS_ATUIN_CONFIG_DIR="${HOME}/.config/atuin"
export DEVOPS_ATUIN_ROOT_BIN="${HOME}/.atuin/bin"
export DEVOPS_ATUIN_INIT_FLAGS=()
```

### Example: Bruno (PATH-only)

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Bruno configuration
export DEVOPS_BRUNO_PACKAGE_NAME=bruno
export DEVOPS_BRUNO_CLI_PACKAGE="@usebruno/cli"
export DEVOPS_BRUNO_INSTALL_CMD="bun add -g"
export DEVOPS_BRUNO_DATA_PATH="${DEVOPS_PATH}/data/bruno"
```

### Naming Convention

All variables use `DEVOPS_<TOOL>_` prefix:

| Variable | Purpose |
|----------|---------|
| `DEVOPS_<TOOL>_PACKAGE_NAME` | Tool name for messages |
| `DEVOPS_<TOOL>_INSTALL_*` | Installation commands/URLs |
| `DEVOPS_<TOOL>_CONFIG_*` | Configuration paths |
| `DEVOPS_<TOOL>_<CUSTOM>`` | Tool-specific settings |

---

## Step 2: Internal Layer

Create `internal/<tool>.zsh` with private implementation functions.

### Core Functions

Every tool needs these functions:

| Function | Purpose |
|----------|---------|
| `devops::<tool>::internal::load` | Load tool into shell (PATH, hooks) |
| `devops::<tool>::internal::install` | Install the tool |
| `devops::<tool>::internal::render` | Generate config from gomplate template |
| `devops::<tool>::internal::sync` | Rsync data/ config to ~/.config/ |
| `devops::<tool>::internal::upgrade` | Upgrade the tool |
| `devops::<tool>::internal::main::factory` | Auto-install if missing |

### Guard Pattern

Always check if the tool exists before operating:

```zsh
function devops::<tool>::internal::load {
    if ! core::exists <tool>; then
        return
    fi
    # ... load logic
}
```

### Example: Atuin (shell hooks)

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::atuin::internal::load {
    if ! core::exists atuin; then
        return
    fi

    # Add custom bin to PATH
    path::prepend "${DEVOPS_ATUIN_ROOT_BIN}"
    
    # Shell integration — eval atuin init zsh
    eval "$(atuin init zsh ${DEVOPS_ATUIN_INIT_FLAGS[@]})"
}

function devops::atuin::internal::install {
    message_info "Installing ${DEVOPS_ATUIN_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_ATUIN_INSTALL_URL}" | bash
    message_success "Installed ${DEVOPS_ATUIN_PACKAGE_NAME}"
}

function devops::atuin::internal::upgrade {
    message_info "Upgrading ${DEVOPS_ATUIN_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_ATUIN_INSTALL_URL}" | bash
    message_success "Upgraded ${DEVOPS_ATUIN_PACKAGE_NAME}"
}

function devops::atuin::internal::main::factory {
    if ! core::exists atuin; then
        devops::atuin::internal::install
    fi
}

devops::atuin::internal::load
devops::atuin::internal::main::factory
```

### Example: Bruno (PATH-only)

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::bruno::internal::load {
    if ! core::exists bru; then
        return
    fi
    # Bruno CLI is available via PATH (installed globally via bun)
}

function devops::bruno::internal::bru::install {
    if ! core::exists bun; then
        message_error "bun is required to install ${DEVOPS_BRUNO_PACKAGE_NAME}"
        return 1
    fi
    message_info "Installing ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
    ${DEVOPS_BRUNO_INSTALL_CMD} ${DEVOPS_BRUNO_CLI_PACKAGE}
    message_success "Installed ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
}

function devops::bruno::internal::sync {
    message_info "Syncing ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avhP --no-perms "${DEVOPS_BRUNO_DATA_PATH}/" "${HOME}/.config/bruno/"
    message_success "Synced ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
}

devops::bruno::internal::load
if ! core::exists bru; then devops::bruno::internal::bru::install; fi
```

### Shell Integration Decision

**Does your tool provide shell hooks?**

| Answer | Pattern | Example |
|--------|---------|---------|
| Yes | `eval "$(tool init zsh)"` in load function | atuin, zoxide |
| No | Just check existence, tool works via PATH | bruno, kubectl |

### Auto-Install Pattern

The `main::factory` function runs at source time and auto-installs missing tools:

```zsh
function devops::<tool>::internal::main::factory {
    if ! core::exists <tool>; then
        devops::<tool>::internal::install
    fi
}
```

---

## Step 3: Public Layer

Create `pkg/<tool>.zsh` with thin wrappers exposing the public API.

### Pattern

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::<tool>::install {
    devops::<tool>::internal::main::factory
}

function devops::<tool>::upgrade {
    devops::<tool>::internal::upgrade
}

function devops::<tool>::render {
    devops::<tool>::internal::render
}

function devops::<tool>::sync {
    devops::<tool>::internal::sync
}

function devops::<tool>::post_install {
    message_info "Post Install ${DEVOPS_<TOOL>_PACKAGE_NAME}"
    # Add any post-install guidance here
    message_success "<Tool> installed! <Next steps guidance>."
}
```

### Example: Atuin

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::atuin::install {
    devops::atuin::internal::main::factory
}

function devops::atuin::upgrade {
    devops::atuin::internal::upgrade
}

function devops::atuin::post_install {
    message_info "Post Install ${DEVOPS_ATUIN_PACKAGE_NAME}"
    message_success "Atuin installed! Run 'atuin login' to enable sync, or 'atuin import zsh' to import existing history."
}
```

### Example: Bruno

```zsh
#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::bruno::load {
    devops::bruno::internal::load
}

function devops::bruno::bru::install {
    devops::bruno::internal::bru::install
}

function devops::bruno::sync {
    devops::bruno::internal::sync
}
```

### Post-Install Guidance

The `post_install` function provides user guidance after installation. Include:
- Login instructions (if authentication needed)
- Configuration steps
- Quick start commands

---

## Step 4: Registration

Add your tool to the `DEVOPS_TOOLS` array in `config/base.zsh`.

### Location

```zsh
export DEVOPS_TOOLS=(
  sops
  packer
  # ... existing tools ...
  atuin
  <your-tool>  ← Add here
)
```

### Example

```zsh
export DEVOPS_TOOLS=(
  sops
  packer
  telepresenceio/telepresence/telepresence-oss
  k9s
  kubectl
  helm
  tfenv
  terragrunt
  terraform-docs
  glab
  google-cloud-cli
  github-cli
  zoxide
  atuin
  bruno  ← Added
)
```

---

## Step 5: Testing

### Load the Module

```zsh
source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh
```

Expected: No errors, tool loads silently.

### Verify Functions

```zsh
type devops::<tool>::install
# → "function"

type devops::<tool>::upgrade
# → "function"
```

### Verify Auto-Install

If the tool is not installed, loading the module should trigger installation:

```zsh
# Remove tool temporarily (if safe)
# Then reload:
source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh
# → Should see: [INFO]: Installing <tool>
```

---

## Checklist

### Files Created

- [ ] `config/<tool>.zsh` — Tool-specific variables with `DEVOPS_<TOOL>_` prefix
- [ ] `internal/<tool>.zsh` — Private implementation functions
- [ ] `pkg/<tool>.zsh` — Public API functions
- [ ] `data/<tool>/` — Templates and config files
- [ ] `data/<tool>/<tool>.yaml.tpl` — Gomplate template (if config has secrets)
- [ ] Added to `DEVOPS_TOOLS` in `config/base.zsh`

### Code Quality

- [ ] All variables use `DEVOPS_<TOOL>_` prefix
- [ ] All functions use `devops::<tool>::` prefix
- [ ] Internal functions use `devops::<tool>::internal::` prefix
- [ ] `core::exists <tool>` guard in load function
- [ ] `message_info` / `message_success` for user feedback
- [ ] `main::factory` for auto-install
- [ ] `render` function for gomplate-based config generation
- [ ] `sync` function for rsync data/ → ~/.config/

### Shell Integration (if applicable)

- [ ] `eval "$(tool init zsh)"` in load function
- [ ] Configurable flags via `DEVOPS_<TOOL>_INIT_FLAGS`
- [ ] `path::prepend` for custom bin directories

### Registration

- [ ] Added to `DEVOPS_TOOLS` array in `config/base.zsh`

### Testing

- [ ] Module loads without errors
- [ ] Functions are available: `type devops::<tool>::install`
- [ ] Auto-install works (if tool missing)

### Never Do This (Anti-patterns)

- [ ] ❌ Don't use single underscore `devops_<tool>_` — always double colon `devops::<tool>::`
- [ ] ❌ Don't hardcode installation commands — use `DEVOPS_<TOOL>_INSTALL_CMD` variables
- [ ] ❌ Don't skip `core::exists` guard — tools may not be installed yet
- [ ] ❌ Don't put `eval` in config files — shell hooks go in `internal/<tool>.zsh` only
- [ ] ❌ Don't use `echo` for output — always use `message_info` / `message_success` / `message_error`
- [ ] ❌ Don't call internal functions from user code — use `pkg/` wrappers only
- [ ] ❌ Don't use absolute paths — use `${HOME}` or `$DEVOPS_PATH` variables
- [ ] ❌ Don't forget the shebang — always start files with `#!/usr/bin/env ksh`

---

## References

- **Atuin implementation**: `zsh/modules/devops/config/atuin.zsh`, `internal/atuin.zsh`, `pkg/atuin.zsh`
- **Bruno implementation**: `zsh/modules/devops/config/bruno.zsh`, `internal/bruno.zsh`, `pkg/bruno.zsh`
- **noti implementation**: `zsh/modules/notify/config/adapter/noti.zsh`, `internal/adapter/noti.zsh`, `pkg/noti.zsh` (gomplate render + sync example)
- **AI module**: `zsh/modules/ai/` (aggregate sync example via `ai::sync`)
- **Existing guide**: `docs/guides/create-module.md` (for creating new modules)
- **Core utilities**: `zsh/system/core/` (message_*, core::exists, path::prepend)
