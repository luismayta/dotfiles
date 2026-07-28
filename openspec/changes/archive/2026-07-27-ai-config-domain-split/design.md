## Context

The AI module (`zsh/modules/ai/`) follows a layered architecture: `config/` → `internal/` → `pkg/`. The `internal/` layer was already split into domain-specific files (opencode.zsh, skills.zsh, graphify.zsh, etc.), but `config/base.zsh` remains monolithic — containing 139 lines of variables for 12+ tools.

Current state:
- `config/base.zsh`: 139 lines, all tool configs mixed
- `config/main.zsh`: OS dispatch, sources base.zsh
- `internal/`: Already split by domain (7 domain files)
- `pkg/`: Already split by domain (7 domain files)

The internal/pkg layers source their domain files via `internal/main.zsh` and `pkg/main.zsh`. Config should follow the same pattern.

## Goals / Non-Goals

**Goals:**
- Split `config/base.zsh` into domain-specific files matching the internal/pkg pattern
- Each domain file exports only its relevant variables
- Maintain identical exported environment (no behavioral change)
- Keep `config/base.zsh` as a thin dispatcher

**Non-Goals:**
- Changing variable names or values
- Modifying `config/main.zsh`, `config/linux.zsh`, or `config/osx.zsh`
- Adding new tools or configurations
- Refactoring the internal/pkg layers (already done)

## Decisions

### Decision 1: Mirror the internal/ domain split

**Choice**: Create config files with identical names to internal/ domain files.

**Rationale**: Consistency. When a developer opens `internal/opencode.zsh`, they know `config/opencode.zsh` contains its configuration. This reduces cognitive load and makes the architecture self-documenting.

**Alternatives considered**:
- Group by category (e.g., `config/llm.zsh` for ollama/openai) — rejected: breaks 1:1 mapping with internal/
- Single `config/tools.zsh` for all small tools — rejected: creates a new monolith

### Decision 2: Shared variables stay in base.zsh

**Choice**: Keep `AI_TOOLS`, `AI_OLLAMA_MODELS`, `AI_INSTALL_URL_*`, and `ARCH_NAME` in `config/base.zsh`.

**Rationale**: These are cross-cutting concerns used by multiple domains (e.g., `AI_TOOLS` is iterated by `internal/tools.zsh::packages::install`). Moving them would create circular dependencies.

### Decision 3: Source order in main.zsh unchanged

**Choice**: Keep `config/main.zsh` sourcing `config/base.zsh` first, then OS-specific files.

**Rationale**: `base.zsh` must be sourced before domain files because domain files reference variables defined in `base.zsh` (e.g., `AI_PATH`). The dispatcher pattern handles the rest.

## Risks / Trade-offs

**[Risk]** Domain files might reference variables not yet defined → **Mitigation**: `base.zsh` is always sourced first (via `main.zsh`), so all shared variables are available.

**[Risk]** New developers might not know where to add config for a new tool → **Mitigation**: The pattern is self-documenting — `internal/foo.zsh` implies `config/foo.zsh` exists.

**[Trade-off]** More files to navigate → **Benefit**: Each file is focused and under 30 lines, making them easy to read and maintain.
