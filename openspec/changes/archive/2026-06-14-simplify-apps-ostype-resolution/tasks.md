## 1. Refactor OSTYPE resolution block

- [x] 1.1 Replace the current 3-branch × 12-category if/elif/else (lines 89–129) with a `_APPS_CATEGORIES` array and `nameref` loop in `zsh/modules/apps/config/base.zsh`
- [x] 1.2 Add `unset` for all helper variables (`_category`, `_src`, `_dst`, `_APPS_SUFFIX`, `_APPS_CATEGORIES`) after the resolution loop
- [x] 1.3 Verify `APPS_PACKAGES` aggregate remains unchanged — still references non-suffixed `APPS_<CATEGORY>` arrays

## 2. Verify backward compatibility

- [x] 2.1 Run `shellcheck zsh/modules/apps/config/base.zsh` — 25 warnings (all false positives from nameref dynamic reference — SC2034/SC2154)
- [ ] 2.2 Source the file in a zsh session and confirm all `APPS_<CATEGORY>` arrays and `APPS_PACKAGES` resolve correctly for each OSTYPE branch
- [ ] 2.3 `task validate` — pre-commit hooks pass except false-positive SC2034/SC2154/SC1091
