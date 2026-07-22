## Context

The devops module integrates 15+ tools (atuin, helm, k9s, tfenv, etc.) following a consistent three-layer architecture. Each tool has config variables, internal logic, and a public API. The pattern is well-established but undocumented — new contributors must reverse-engineer existing implementations.

The existing `docs/guides/create-module.md` covers creating new modules, not adding tools to existing modules. This guide fills that gap by documenting the tool integration pattern using atuin as the reference implementation.

## Goals / Non-Goals

**Goals:**
- Document the three-layer pattern for adding tools to existing modules
- Provide annotated atuin code as the reference implementation
- Explain naming conventions, guard patterns, and auto-install behavior
- Cover the complete lifecycle: config → internal → pkg → registration

**Non-Goals:**
- Not covering module creation (covered in `create-module.md`)
- Not documenting provider/adapter patterns (advanced, separate guide)
- Not explaining core utilities (assume readers know `core::exists`, `message_info`, etc.)

## Decisions

**1. Single guide file vs. multi-page documentation**
→ Single file at `docs/guides/implement-tool-in-module.md`
Rationale: Matches existing guide structure (`create-module.md` is single-file). Keeps discovery simple.

**2. Reference implementation choice: atuin + bruno**
→ Atuin (shell hooks) + Bruno (PATH-only)
Rationale: Two reference implementations cover the main tool integration patterns. Atuin demonstrates shell integration via `eval`, while bruno shows the simpler PATH-only pattern. This gives developers a clear decision point: "Does my tool need shell hooks?"

**3. Guide structure**
→ Follow the same section pattern as `create-module.md`:
1. Overview (what we're building)
2. File structure
3. Config layer
4. Internal layer
5. Public layer
6. Registration
7. Testing
8. Checklist

Rationale: Consistency with existing documentation reduces cognitive load.

**4. Code examples: annotated vs. raw**
→ Annotated with inline comments explaining each decision
Rationale: The guide's purpose is to explain "why" not just "what". Annotations make the pattern self-documenting.

## Risks / Trade-offs

**[Risk] Guide becomes stale as tools evolve** → Mitigation: Reference implementations (atuin, bruno) are stable and unlikely to change significantly. Guide focuses on patterns, not implementation details.

**[Risk] Readers may copy reference code without adapting** → Mitigation: Include clear "adapt to your tool" notes in each section. Two examples show the pattern range.

**[Risk] Missing edge cases (OS-specific tools, complex config)** → Mitigation: Explicitly state this guide covers the simple case. Link to existing tools for advanced patterns.
