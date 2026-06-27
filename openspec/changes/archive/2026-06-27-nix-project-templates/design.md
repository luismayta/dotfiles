## Context

The current `nix::scaffold::init` creates a bare `flake.nix` with an empty `outputs` block. This is useless as a starting point — developers immediately need to add language packages, devShell, and build tools. Rather than editing the bare template every time, we provide pre-built templates per language.

The pattern already exists: `zsh/modules/nix/data/templates/flake.nix` is read by `nix::scaffold::init`. We extend this by nesting templates in subdirectories and adding per-language functions: `nix::scaffold::go`, `nix::scaffold::python`, `nix::scaffold::typescript`, `nix::scaffold::rust`.

## Goals / Non-Goals

**Goals:**
- Provide ready-to-use Nix flake templates for Go, Python, TypeScript, and Rust
- Each template includes devShell with standard tooling for that language
- `nix::scaffold::<language>` copies the correct template for each language
- `nix::scaffold::init` keeps existing behavior: bare template
- Idempotent — never overwrites existing files

**Non-Goals:**
- Not a full project generator (no `go mod init`, `cargo init`, etc.)
- No CI/CD templates (GitHub Actions, etc.)
- No cross-language or monorepo templates

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Template structure | `data/templates/<lang>/flake.nix` | Keeps the existing `data/templates/` pattern; easy to extend; clear hierarchy |
| Template granularity | One flake.nix per language with all standard tools | Avoids combinatorial explosion (e.g., `go-bun` vs `go-std`); users trim what they don't need |
| CLI API | `nix::scaffold::go`, `nix::scaffold::python`, `nix::scaffold::typescript`, `nix::scaffold::rust` | Each language gets its own function; no flags, no dispatch logic, simpler to use and tab-complete |
| Language choices | Go, Python, TypeScript, Rust | Cover the four main ecosystems the user works with |

## Risks / Trade-offs

- **Risk**: Templates become outdated as nixpkgs versions change → **Mitigation**: Keep templates minimal; only pin critical packages, let nixpkgs-unstable float
- **Risk**: Too many tools per template (bloated devShell) → **Mitigation**: Include the canonical toolchain only; users extend as needed
- **Risk**: Template divergence (each language flake looks different) → **Mitigation**: Consistent structure across all templates — same `description`, `inputs`, `outputs.devShells.default` shape
