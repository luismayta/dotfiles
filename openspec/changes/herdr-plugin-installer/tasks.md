## 1. Config — Add plugin array to config/base.zsh

- [ ] 1.1 Add `ZSH_HERDR_INSTALL_PLUGINS` array declaration with commented example
- [ ] 1.2 Add `ZSH_HERDR_PLUGIN_ENABLED` feature flag (default: true)
- [ ] 1.3 Add a commented-out example entry documenting the GitHub shorthand format

## 2. Internal — Add plugin management functions

- [ ] 2.1 Add `herdr::internal::plugin::install` — install single plugin via `herdr plugin install <shorthand> --yes`
- [ ] 2.2 Add `herdr::internal::plugin::install::all` — iterate `ZSH_HERDR_INSTALL_PLUGINS` and install missing
- [ ] 2.3 Add `herdr::internal::plugin::list` — run `herdr plugin list` and display output
- [ ] 2.4 Add `herdr::internal::plugin::update` — reinstall single plugin
- [ ] 2.5 Add `herdr::internal::plugin::update::all` — reinstall all configured plugins
- [ ] 2.6 Add `herdr::internal::plugin::uninstall` — remove plugin via `herdr plugin uninstall`

## 3. Internal — Wire auto-install in internal/main.zsh

- [ ] 3.1 After herdr binary is confirmed installed, add guard for `ZSH_HERDR_PLUGIN_ENABLED`
- [ ] 3.2 Call `herdr::internal::plugin::install::all` during module load

## 4. Pkg — Add public API wrappers

- [ ] 4.1 Add `herdr::plugin::install`, `herdr::plugin::list`, `herdr::plugin::update`, `herdr::plugin::uninstall` in `pkg/base.zsh`
- [ ] 4.2 Add `herdr::plugin::update::all` wrapper

## 5. Pkg — Add interactive helper (pkg/helper.zsh)

- [ ] 5.1 Add `hrd::plugin` function with fzf-based action selector (install/list/update/uninstall)
- [ ] 5.2 Wire fzf prompts for each action matching existing `hrd`/`hrdk` style
- [ ] 5.3 Ensure uninstall action uses fzf to select from installed plugins

## 6. Verify

- [ ] 6.1 Run `shellcheck` on all modified/new files
- [ ] 6.2 Validate module loads cleanly when `ZSH_HERDR_INSTALL_PLUGINS` is empty
- [ ] 6.3 Validate module loads cleanly with plugins configured
