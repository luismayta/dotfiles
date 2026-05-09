---
name: release
description: Run a release bump (major/minor/patch) and generate next changelog from the updated pyproject.toml version.
license: Proprietary
---

# Release Skill

## Trigger phrases

- "haz un release:major"
- "haz un release:minor"
- "haz un release:patch"
- "haz un release:pre_release"

## Source of truth

- `pyproject.toml` under `[project].version`

## What to do

- If the user requests `release:major`, run: `task release:major`
- If the user requests `release:minor`, run: `task release:minor`
- If the user requests `release:patch`, run: `task release:patch`
- If the user requests `release:pre_release`, run: `task release:pre_release`

## Expected result

- Version is bumped (including `pyproject.toml`).
- Next-tag changelog is generated with `APP_TAG` equal to the updated version.

## Implementation detail

- Always run: `task changelog:next APP_TAG=$(uv run bump-my-version show current_version)`
