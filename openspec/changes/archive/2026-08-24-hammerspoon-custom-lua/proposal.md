## Why

`hammerspoon::sync` copies the entire module `data/` directory over `~/.hammerspoon/` on every run, silently destroying any user edits to `custom.lua` — the file the Lua config explicitly treats as the highest-priority user override layer. Additionally, `require("custom")` can resolve to two different locations (`~/.hammerspoon/custom.lua` or `~/.hammerspoon/src/custom.lua`) because both are on `package.path`. User-owned overrides belong outside the managed tree entirely: in `~/.config/hammerspoon/`.

## What Changes

- Relocate the user customization file out of the managed tree: `custom.lua` lives at `~/.config/hammerspoon/custom.lua`, which the module sync never touches — protection becomes structural, not flag-based
- Ship `data/custom.lua.example` instead of a live `data/custom.lua`; the module seeds `~/.config/hammerspoon/custom.lua` from the example only when it is missing
- Expose the customization location as a module config variable (`ZSH_HAMMERSPOON_CUSTOM_DIR`) driving the seed step
- Make `require("custom")` resolve deterministically to `~/.config/hammerspoon/custom.lua` by prepending that directory to `package.path` in `init.lua` (derived from `os.getenv("HOME")` — Hammerspoon is a GUI app and does not inherit shell environment variables)
- Fix `data/.gitignore`: the repo tracks only the example; no live `custom.lua` is ever committed

## Capabilities

### New Capabilities
- `hammerspoon-module`: Customization-file handling of the hammerspoon zsh module — where the user override lives, how it is seeded on first run, how sync guarantees it is never modified, and deterministic resolution of the override from Lua

### Modified Capabilities
- (none — no existing specs are affected)

## Impact

- `zsh/modules/hammerspoon/config/base.zsh`: new `ZSH_HAMMERSPOON_CUSTOM_DIR` variable
- `zsh/modules/hammerspoon/internal/base.zsh`: sync gains a seed-if-missing step targeting `~/.config/hammerspoon/`
- `zsh/modules/hammerspoon/data/`: `custom.lua` renamed to `custom.lua.example`; `.gitignore` cleaned up
- `zsh/modules/hammerspoon/data/init.lua`: `package.path` gains the customization directory before any `require` runs
- No public API changes: `hammerspoon::install`, `hammerspoon::sync`, `hammerspoon::setup`, `edithammerspoon` keep their signatures
- Coordination: the sibling change `improve-hammerspoon-config` owns generating `custom.lua` content from a template; this change owns where the file lives and that sync never touches it. Both are complementary.
