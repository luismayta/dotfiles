## 1. Config layer

- [x] 1.1 Add `export ZSH_HAMMERSPOON_CUSTOM_DIR="${ZSH_HAMMERSPOON_CUSTOM_DIR:-${HOME}/.config/hammerspoon}"` to `zsh/modules/hammerspoon/config/base.zsh` following the existing `${VAR:-default}` pattern

## 2. Seed-if-missing sync step

- [x] 2.1 In `zsh/modules/hammerspoon/internal/base.zsh`, before rsync: create `${ZSH_HAMMERSPOON_CUSTOM_DIR}` if missing
- [x] 2.2 Seed `${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua` from `${ZSH_HAMMERSPOON_DATA_PATH}/custom.lua.example` only when the destination file does not exist
- [x] 2.3 Emit an informational message when a legacy `~/.hammerspoon/custom.lua` is detected, telling the user to move it to `${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua`

## 3. Repository data layout

- [x] 3.1 Rename `zsh/modules/hammerspoon/data/custom.lua` to `zsh/modules/hammerspoon/data/custom.lua.example` preserving content
- [x] 3.2 Clean `zsh/modules/hammerspoon/data/.gitignore`: remove stale entries (`src/custom.lua`), keep the directory free of any live `custom.lua`
- [x] 3.3 Confirm `git status` is clean after the rename (no tracked file matches ignore rules)

## 4. Deterministic override resolution

- [x] 4.1 In `zsh/modules/hammerspoon/data/init.lua`, prepend `os.getenv("HOME") .. "/.config/hammerspoon/?.lua"` to `package.path` before any `require` call, skipping gracefully when HOME is nil
- [x] 4.2 Verify `require("custom")` resolves to `~/.config/hammerspoon/custom.lua` even when other `custom.lua` files exist on the search path

## 5. End-to-end verification

- [x] 5.1 Fresh-machine simulation: ensure `~/.config/hammerspoon/custom.lua` is absent, run `hammerspoon::sync`, confirm the directory is created and the file seeded from the example
- [x] 5.2 User-edit simulation: modify `~/.config/hammerspoon/custom.lua`, run `hammerspoon::sync` twice, confirm the file survives byte-identical
- [x] 5.3 Reload Hammerspoon configuration and confirm the custom override loads from `~/.config/hammerspoon/custom.lua` without errors
