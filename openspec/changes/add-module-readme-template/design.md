## Context

The project already has a mature gomplate pipeline:
- Root `README.md` generated from `provision/templates/README.tpl.md` + `provision/generators/README.yaml`
- `Taskfile.yml` `readme` task that runs gomplate with the template and datasource

The terraform-aws project extends this pattern per-module:
- `provision/templates/README.module.tpl.md` — shared module template
- Each module has its own `README.yaml` and `Taskfile.yml` with a `readme` task referencing the shared template
- `README_MODULE_TEMPLATE` env var in the root Taskfile.yml points to the shared template

This design adapts that pattern for zsh modules, using the same gomplate tooling already in place.

## Goals / Non-Goals

**Goals:**
- Create `provision/templates/README.module.tpl.md` adapted from terraform-aws
- Add `README_MODULE_TEMPLATE` env var to root `Taskfile.yml`
- Add `README.yaml` to `zsh/modules/git/` as pilot
- Add `readme` task to `zsh/modules/git/Taskfile.yml`
- Generate `zsh/modules/git/README.md` from the template

**Non-Goals:**
- Not migrating all 40+ modules at once — pilot first, then iterative
- Not changing the root `README.tpl.md` or root README generation
- Not adding new runtime dependencies

## Decisions

1. **Direct adaptation** — the module template mirrors terraform-aws's structure: badges, name, description, features, requirements, usage, include sections. Confluence blocks are stripped (alignment with previous OKF cleanup).
2. **Pilot on `git` module** — git is the most widely used module and has clear documentation needs.
3. **Per-module `README.yaml` at module root** — follows terraform-aws convention. Contains `name`, `description`, `features`, `requirements`, `usages`, `include`.
4. **Per-module `readme` task** — each module's `Taskfile.yml` gets a readme task referencing `{{.README_MODULE_TEMPLATE}}` and the module's own `README.yaml`.

## Risks / Trade-offs

- **[Risk] Template drift** — module template may diverge from root README template. **Mitigation**: both live in `provision/templates/`; changes can be made in tandem.
- **[Risk] Manual per-module setup** — each module needs its own README.yaml + task. **Mitigation**: pilot first, document the pattern, automate later if adoption grows.
