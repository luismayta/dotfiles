## 1. Create module directory structure

- [x] 1.1 Create `zsh/modules/zed/` directory with subdirectories: `config/`, `internal/`, `pkg/`, `resources/`

## 2. Create entry point (plugin.zsh)

- [x] 2.1 Create `zsh/modules/zed/plugin.zsh` with guard variable `__ZSH_ZED_LOADED` and source all three layers (config → internal → pkg), following the goenv pattern

## 3. Create config layer

- [x] 3.1 Create `zsh/modules/zed/config/main.zsh` with OS dispatch sourcing base.zsh + osx.zsh/linux.zsh
- [x] 3.2 Create `zsh/modules/zed/config/base.zsh` solo con variables usadas: `ZED_INSTALL_URL`, `ZED_CONFIG_PATH`, `ZED_SETTINGS_FILE`, `ZED_KEYMAP_FILE` (YAGNI: eliminar `ZED_PACKAGE_NAME`, `ZED_MESSAGE_BREW`, `ZED_MESSAGE_PYENV`, `ZED_MESSAGE_NOT_FOUND` que nunca se usan)
- [x] 3.3 Create `zsh/modules/zed/config/osx.zsh` (empty placeholder)
- [x] 3.4 Create `zsh/modules/zed/config/linux.zsh` (empty placeholder)

## 4. Create internal layer (implementation)

- [x] 4.1 Create `zsh/modules/zed/internal/main.zsh` con OS dispatch, `core::ensure curl`, y llamado a `zed::internal::install`
- [x] 4.2 Create `zsh/modules/zed/internal/base.zsh` con funciones: `zed::internal::install`, `zed::internal::config::sync` (rsync como hyprland), `zed::post_install` llama a sync
- [x] 4.3 Create `zsh/modules/zed/internal/helper.zsh` con función `zed::exists` que usa `core::exists zed` directamente (KISS: sin wrapper interno innecesario)
- [x] 4.4 Create `zsh/modules/zed/internal/osx.zsh` (empty placeholder)
- [x] 4.5 Create `zsh/modules/zed/internal/linux.zsh` (empty placeholder)

## 5. Create pkg layer (public API)

- [x] 5.1 Create `zsh/modules/zed/pkg/main.zsh` with OS dispatch
- [x] 5.2 Create `zsh/modules/zed/pkg/base.zsh` con wrappers que delegan a internal
- [x] 5.3 Create `zsh/modules/zed/pkg/helper.zsh` con API pública minimalista: `zed::install`, `zed::sync`, `zed::exists`, `zed::setup` (KISS: 4 funciones, justas y necesarias — sync llama internamente a rsync como hyprland)
- [x] 5.4 Create `zsh/modules/zed/pkg/alias.zsh` (empty placeholder)
- [x] 5.5 Create `zsh/modules/zed/pkg/osx.zsh` (empty placeholder)
- [x] 5.6 Create `zsh/modules/zed/pkg/linux.zsh` (empty placeholder)

## 6. Migrate Zed configuration files

- [x] 6.1 Copy `settings.jsonc` from `zsh-zed/conf/` to `zsh/modules/zed/resources/settings.jsonc`
- [x] 6.2 Copy `keymap.jsonc` from `zsh-zed/conf/` to `zsh/modules/zed/resources/keymap.jsonc`

## 7. Verify and clean up

- [x] 7.1 Verify module loads without errors: `source zsh/modules/zed/plugin.zsh`
- [x] 7.2 Verify public functions: `zed::install`, `zed::sync`, `zed::exists`, `zed::setup`
- [x] 7.3 Verify guard prevents double-loading
- [x] 7.4 Remove old zsh-zed module reference from dotfiles loader if present — no references found
