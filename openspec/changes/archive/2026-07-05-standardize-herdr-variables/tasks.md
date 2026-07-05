## 1. Rename definitions in config/base.zsh

- [x] 1.1 Rename `HERDR_PACKAGE_NAME` → `ZSH_HERDR_PACKAGE_NAME` with backward-compat alias
- [x] 1.2 Rename `HERDR_INSTALL_URL` → `ZSH_HERDR_INSTALL_URL` with backward-compat alias
- [x] 1.3 Rename `HERDR_WORKSPACE_PREFIX` → `ZSH_HERDR_WORKSPACE_PREFIX` with backward-compat alias
- [x] 1.4 Rename `ZSH_HRD_PROJECT_TEMPLATE_PATH` → `ZSH_HERDR_PROJECT_TEMPLATE_PATH` with backward-compat alias

## 2. Rename clipboard variables in platform configs

- [x] 2.1 Rename `HERDR_CLIPBOARD_COPY_CMD` → `ZSH_HERDR_CLIPBOARD_COPY_CMD` in `config/linux.zsh`
- [x] 2.2 Rename `HERDR_CLIPBOARD_PASTE_CMD` → `ZSH_HERDR_CLIPBOARD_PASTE_CMD` in `config/linux.zsh`
- [x] 2.3 Rename `HERDR_CLIPBOARD_COPY_CMD` → `ZSH_HERDR_CLIPBOARD_COPY_CMD` in `config/osx.zsh`
- [x] 2.4 Rename `HERDR_CLIPBOARD_PASTE_CMD` → `ZSH_HERDR_CLIPBOARD_PASTE_CMD` in `config/osx.zsh`

## 3. Update references in internal/base.zsh

- [x] 3.1 Replace all `${HERDR_PACKAGE_NAME}` → `${ZSH_HERDR_PACKAGE_NAME}`
- [x] 3.2 Replace `${HERDR_INSTALL_URL}` → `${ZSH_HERDR_INSTALL_URL}`
- [x] 3.3 Replace `${ZSH_HRD_PROJECT_TEMPLATE_PATH}` → `${ZSH_HERDR_PROJECT_TEMPLATE_PATH}`

## 4. Update references in pkg/

- [x] 4.1 Replace `${HERDR_PACKAGE_NAME}` → `${ZSH_HERDR_PACKAGE_NAME}` in `pkg/base.zsh`
- [x] 4.2 Replace `${ZSH_HRD_PROJECT_TEMPLATE_PATH}` → `${ZSH_HERDR_PROJECT_TEMPLATE_PATH}` in `pkg/helper.zsh`

## 5. Update plugin.zsh

- [x] 5.1 Replace `${HERDR_PACKAGE_NAME:-herdr}` → `${ZSH_HERDR_PACKAGE_NAME:-herdr}` in `plugin.zsh`

## 6. Verify

- [x] 6.1 Run `grep -rn 'HERDR_' zsh/modules/herdr/` — confirm zero remaining unprefixed variables
- [x] 6.2 Run `grep -rn 'ZSH_HRD_' zsh/modules/herdr/` — confirm zero remaining HRD_ references
