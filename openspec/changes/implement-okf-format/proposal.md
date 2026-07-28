## Why

The Open Knowledge Format (OKF) is an emerging open standard from Google Cloud for representing knowledge as markdown + YAML frontmatter. Our dotfiles project already has extensive markdown documentation in `docs/`. Adding OKF-compliant YAML frontmatter (`type`, `title`, `description`, `tags`) to these existing files makes them consumable by AI agents and OKF-aware tooling — without any new pipelines, templates, or generated code.

This change brings OKF to the existing documentation by adding frontmatter directly to the source markdown files, keeping the docs human-editable and zero-build.

## What Changes

- Add YAML frontmatter (`type`, `title`, `description`, `tags`) to existing `docs/*.md` files
- Remove Confluence-specific HTML comments from `provision/templates/README.tpl.md` and `docs/functions.md`
- No new directories, no new templates, no generation scripts

## Capabilities

### New Capabilities

- `docs-frontmatter`: OKF v0.1-compliant YAML frontmatter added to existing markdown files in `docs/`. Each file gets `type`, `title`, `description`, `tags` fields.

### Modified Capabilities

- `provision-pipeline`: Remove Confluence comment blocks from README template and docs includes

## Impact

- **No new files** — only edits to existing `docs/*.md` files
- **No new dependencies** — gomplate and task remain untouched
- **Backward compatible** — frontmatter is invisible in rendered markdown
- **Cleaner README generation** — Confluence artifacts removed from template and includes
