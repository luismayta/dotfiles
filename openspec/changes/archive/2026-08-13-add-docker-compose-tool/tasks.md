## 1. Config Layer

- [x] 1.1 Create `zsh/modules/devops/config/docker-compose.zsh` with `DEVOPS_DOCKER_COMPOSE_*` variables (`PACKAGE_NAME`, `INSTALL_CMD`, `CONFIG_DIR`) following the naming convention
- [x] 1.2 Ensure config file uses shebang `#!/usr/bin/env ksh` and no `eval` (PATH-only pattern)

## 2. Internal Layer

- [x] 2.1 Implement `devops::docker-compose::internal::load` with `core::exists docker-compose` guard (PATH-only, silent return when missing)
- [x] 2.2 Implement `devops::docker-compose::internal::install` using `DEVOPS_DOCKER_COMPOSE_INSTALL_CMD` variable (no hardcoded commands) with `message_info`/`message_success`/`message_error` feedback
- [x] 2.3 Implement `devops::docker-compose::internal::upgrade` using the install command variable with `message_*` feedback
- [x] 2.4 Implement `devops::docker-compose::internal::main::factory` for auto-install when binary is missing, invoked at source time

## 3. Public Layer

- [x] 3.1 Implement `devops::docker-compose::install` public wrapper in `zsh/modules/devops/pkg/docker-compose.zsh`
- [x] 3.2 Implement `devops::docker-compose::upgrade` public wrapper in `zsh/modules/devops/pkg/docker-compose.zsh`

## 4. Registration

- [x] 4.1 Register `docker-compose` in the `DEVOPS_TOOLS` array of `zsh/modules/devops/config/base.zsh`

## 5. Verification

- [x] 5.1 Verify module loads without errors: `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh`
- [x] 5.2 Verify functions available: `type devops::docker-compose::install` and `type devops::docker-compose::upgrade` resolve to `function`
- [x] 5.3 Verify all functions use the `devops::docker-compose::` prefix (never single underscore)