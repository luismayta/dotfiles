## Context

OKF v0.1 defines concepts as markdown files with YAML frontmatter (`type`, `title`, `description`, `resource`, `tags`, `timestamp`). Our existing `docs/` directory already contains markdown documentation. Adding frontmatter directly to these files requires no generation pipeline — just edit the files.

The `provision/templates/README.tpl.md` and `docs/functions.md` had Confluence-specific HTML comments that are no longer needed.

## Goals / Non-Goals

**Goals:**
- Add OKF-compliant YAML frontmatter to every `.md` file under `docs/`
- Remove Confluence HTML comments from the README template and docs includes
- Ensure `type` and `title` are present in every frontmatter block

**Non-Goals:**
- No generated files or bundles
- No new template system or DSL
- No changes to documentation content, only frontmatter additions

## Decisions

1. **Direct editing** — frontmatter is written directly into each `.md` file. No generation step.
2. **Minimal fields** — each file gets `type`, `title`, `description`, `tags`. Optional fields (`resource`, `timestamp`) can be added per-file if relevant.
3. **Type taxonomy** — use descriptive types: `Guide`, `Reference`, `Example`, `Contributing`, `FAQ`, `Component`, `Command`, `Environment`.
4. **No structural changes** — frontmatter is additive; no content reorganization.

## Risks / Trade-offs

- **[Risk] Manual process** — frontmatter must be maintained by hand. **Mitigation**: minimal fields keep the burden low.
- **[Risk] Inconsistency** — different authors may use different types/tags. **Mitigation**: document the type taxonomy in the change.
