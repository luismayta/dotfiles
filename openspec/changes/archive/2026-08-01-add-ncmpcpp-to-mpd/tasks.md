## 1. Config Layer

- [x] 1.1 Add `NCMP_CPP_PACKAGE_NAME="ncmpcpp"` to `zsh/modules/mpd/config/base.zsh`

## 2. Internal Layer

- [x] 2.1 Add ncmpcpp installation logic to `zsh/modules/mpd/internal/base.zsh` (check and install if missing)

## 3. Data Files

- [x] 3.1 Create `zsh/modules/mpd/data/ncmpcpp/config` with default ncmpcpp configuration
- [x] 3.2 Create `zsh/modules/mpd/data/ncmpcpp/bindings` with default key bindings

## 4. Config Deployment

- [x] 4.1 Add config deployment function to `zsh/modules/mpd/internal/base.zsh` (copy config to `~/.ncmpcpp/` if not exists)

## 5. Public API

- [x] 5.1 Add `mpd::ncmpcpp()` function to `zsh/modules/mpd/pkg/base.zsh`

## 6. Aliases

- [x] 6.1 Add `ncmp` and `ncmpcpp` aliases to `zsh/modules/mpd/pkg/alias.zsh`

## 7. Verification

- [x] 7.1 Test module loads correctly on Linux (source plugin.zsh)
- [x] 7.2 Verify ncmpcpp launches with `ncmp` alias
- [x] 7.3 Verify `mpd::ncmpcpp` function works
