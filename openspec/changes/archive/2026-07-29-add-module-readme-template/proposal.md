## Why

Each zsh module in `zsh/modules/` currently lacks a dedicated README. Module documentation is scattered across code comments and the main docs. The terraform-aws project solves this with a shared `README.module.tpl.md` template and per-module `README.yaml` config + `Taskfile.yml` readme task. Bringing this pattern to dotfiles means every module gets a consistent, generated README — reducing onboarding friction and making module purposes discoverable at a glance.

## What Changes

- Add `provision/templates/README.module.tpl.md` — a gomplate template for module READMEs, adapted from terraform-aws's version
- Add `README_MODULE_TEMPLATE` env var to root `Taskfile.yml`
- Add a `README.yaml` and `readme` task to one pilot module (`zsh/modules/git/`)
- The template renders module metadata (name, description, features, usage, requirements) from the per-module `README.yaml`

## Capabilities

### New Capabilities

- `module-readme-template`: Shared gomplate template at `provision/templates/README.module.tpl.md` for generating module-level `README.md` files from per-module `README.yaml` datasources.
- `module-readme-infra`: Root Taskfile env var (`README_MODULE_TEMPLATE`) and per-module `Taskfile.yml` readme task pattern that calls gomplate with the shared template and the module's README.yaml.

### Modified Capabilities

- `provision-pipeline`: Extend the existing gomplate pipeline with a module-specific template alongside the root `README.tpl.md`.

## Impact

- **New file**: `provision/templates/README.module.tpl.md`
- **New env var**: `README_MODULE_TEMPLATE` in root `Taskfile.yml`
- **Pilot module**: `zsh/modules/git/` gets `README.yaml` + readme task in its `Taskfile.yml`
- **No breaking changes** — existing root README generation is untouched
