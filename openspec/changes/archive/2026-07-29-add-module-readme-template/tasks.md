## 1. Module template

- [x] 1.1 Create `provision/templates/README.module.tpl.md` adapted from terraform-aws (strip Confluence blocks, adapt for zsh modules)
- [x] 1.2 Add `README_MODULE_TEMPLATE` env var to root `Taskfile.yml`

## 2. All modules — README.yaml + Taskfile.yml

- [x] 2.1 Create `README.yaml` for all 39 modules (ai → zed) with name, description, features, requirements
- [x] 2.2 Create `Taskfile.yml` with `readme` task for 33 modules (git/hyprland/nvim already had Taskfile.yml)
- [x] 2.3 Add `readme` task to existing hyprland and nvim Taskfile.yml
- [x] 2.4 Register all 39 modules as `module-*` includes in root `Taskfile.yml`
- [x] 2.5 Run `task module-*:readme` for all 39 modules → all README.md generated
- [x] 2.6 Added `readme:modules` task (deps on all module readmes) and wired as `deps` of root `readme` task

## 3. Documentation

- [x] 3.1 Add README template section to `docs/guides/create-module.md` (scaffold, Taskfile + README.yaml instructions, checklist items)
