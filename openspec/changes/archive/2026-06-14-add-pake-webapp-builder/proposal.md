## Why

The apps module manages desktop application installation and configuration, including web apps via `APPS_WEB_APPS`. Currently there is no way to build native desktop wrappers from web URLs using `pake` — each web app must be built manually with the full `pake` CLI invocation. This adds a function to automate building web apps from a declarative config, so users can define their desired web apps once and build them with a single command.

## What Changes

- Add `APPS_WEB_APPS_BUILD` config array in `apps/config/base.zsh` with url/name pairs for web apps to build as native desktop apps
- Add `apps::internal::webapp::build` function in `internal/base.zsh` that accepts a URL and name and runs `pake <url> --name <name> --width 1200 --height 800 --hide-title-bar --targets zst`
- Add `apps::internal::webapp::all::build` function that iterates `APPS_WEB_APPS_BUILD` and builds each entry
- Add corresponding public functions `apps::webapp::build` and `apps::webapp::all::build` in `pkg/base.zsh`

## Capabilities

### New Capabilities
- `webapp-build`: Build a single desktop web app from a URL using pake, accepting url and name as arguments
- `webapp-build-all`: Build all configured web apps from the `APPS_WEB_APPS_BUILD` config array

### Modified Capabilities

None — no existing specs are changing.

## Impact

- **`zsh/modules/apps/config/base.zsh`**: New `APPS_WEB_APPS_BUILD` config array (associative, url → name pairs)
- **`zsh/modules/apps/internal/base.zsh`**: New `apps::internal::webapp::build` and `apps::internal::webapp::all::build` functions
- **`zsh/modules/apps/pkg/base.zsh`**: New `apps::webapp::build` and `apps::webapp::all::build` public delegating functions
