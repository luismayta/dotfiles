## 1. Config variable: ANDROID_CMDLINE_TOOLS_VERSION

- [x] 1.1 Add `export ANDROID_CMDLINE_TOOLS_VERSION="${ANDROID_CMDLINE_TOOLS_VERSION:-11076708}"` to `config/android.zsh`
- [x] 1.2 Replace the hardcoded version in `internal/base.zsh:38` — change `commandlinetools-linux-11076708_latest.zip` to `commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip`

## 2. Config variable: SDKMAN_DIR

- [x] 2.1 Add `export SDKMAN_DIR="${SDKMAN_DIR:-${HOME}/.sdkman}"` to `config/android.zsh`
- [x] 2.2 Replace the hardcoded path in `internal/base.zsh:18` — change `"${HOME}/.sdkman/bin/sdkman-init.sh"` to `"${SDKMAN_DIR}/bin/sdkman-init.sh"`
- [x] 2.3 Update the SDKMAN install guard on line 18 — change `[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]]` to `[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]`

## 3. Verify

- [x] 3.1 Run `shellcheck zsh/modules/mobile/internal/base.zsh` — no new warnings
- [x] 3.2 Source the module and confirm `echo $ANDROID_CMDLINE_TOOLS_VERSION` outputs `11076708`
- [x] 3.3 Source the module and confirm `echo $SDKMAN_DIR` outputs the home-expanded path
