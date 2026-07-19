## 1. Environment Auto-Loading

- [x] 1.1 Add `bw::load::env` call at the start of `bw::search` function in `pkg/base.zsh`
- [x] 1.2 Add `bw::load::env` call at the start of each `bw::search::*` function in `pkg/base.zsh`

## 2. Error Handling

- [x] 2.1 Remove `2>/dev/null` from `bw list items` calls in `pkg/base.zsh`
- [x] 2.2 Add exit code checking after `bw list items` calls
- [x] 2.3 Add `message_warning` calls for authentication failures
- [x] 2.4 Ensure functions return empty results on error

## 3. Cleanup

- [x] 3.1 Remove `rsync` dependency check from `internal/main.zsh`
- [x] 3.2 Remove duplicate `_get_type`, `_get_type_field`, `_get_item_by_type` from `internal/helper.zsh`

## 4. Verification

- [ ] 4.1 Test `bw::search` with valid `~/.bw_env` file
- [ ] 4.2 Test `bw::search` without `~/.bw_env` file
- [ ] 4.3 Test authentication failure error messages
- [ ] 4.4 Verify no regressions in existing functionality

## 5. Interactive Environment Selection

- [x] 5.1 Add `BITWARDEN_VARS_LIST` variable definition in `config/base.zsh`
- [x] 5.2 Modify `bw::load::env` in `internal/base.zsh` to support interactive selection
- [x] 5.3 Add fzf integration for variable selection when multiple values exist
- [x] 5.4 Add fallback behavior when `BITWARDEN_VARS_LIST` is not set
- [x] 5.5 Add error handling for missing variables in `~/.bw_env`
