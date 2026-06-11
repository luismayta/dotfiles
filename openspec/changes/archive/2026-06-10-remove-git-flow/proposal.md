## Why

Git-flow is no longer used as a workflow in this repository. We exclusively use GitHub Flow (trunk-based development with short-lived feature branches). Maintaining git-flow installation, helpers, branch detection, and workflow integration adds unnecessary complexity, dependency requirements, and maintenance overhead.

## What Changes

- Remove git-flow package installation (ensure/pkg layer)
- Remove `gff` (git-flow feature) helper function
- Remove git-flow branch detection functions (`develop`, `master`, setup, validation)
- Remove git-flow workflow detection and execution in `issues/` module
- Delete `issues/workflow/gitflow.zsh` entirely
- Clean up `GIT_FLOW_PACKAGE_NAME` configuration
- Simplify git module by removing all git-flow references

## Capabilities

### New Capabilities
- `git-module-simplify`: Remove git-flow dependencies, helpers, and branch logic from the git zsh module, leaving only the GitHub Flow workflow path
- `issues-workflow-simplify`: Remove git-flow workflow detection and execution from the issues module, defaulting to the existing non-gitflow (GitHub Flow) path

### Modified Capabilities
- (none — no spec-level behavior changes, only removal of unused functionality)

## Impact

- **Dependencies**: `git-flow` / `gitflow-avh` package no longer installed
- **Git module**: 6 files modified (`internal/main.zsh`, `internal/base.zsh`, `pkg/base.zsh`, `config/linux.zsh`, plus removal of related lines)
- **Issues module**: 2 files modified (`internal/base.zsh`, `workflow/main.zsh`), 1 file deleted (`workflow/gitflow.zsh`)
- **Documentation**: Minor update to `docs/contribute/github-flow.md` (remove comparative reference)