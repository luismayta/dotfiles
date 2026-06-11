## Why

Currently all modules under `zsh/modules/` are loaded unconditionally. If a module (e.g., tmux) has a bug or dependency issue, the user cannot source their zshrc without either moving the directory or editing the loading loop. A simple opt-out mechanism is needed to skip failing modules without structural changes.

## What Changes

- Add `ZSH_DISABLED_MODULES` environment variable support in the module loading loop in `zsh/.zshrc`
- Modules listed in this variable (space-separated directory names) will be skipped during load
- Document the mechanism so users know how to disable a module

## Capabilities

### New Capabilities

- `module-disable`: Allow users to selectively disable zsh modules by setting `ZSH_DISABLED_MODULES` in their environment or `~/.zshrc.local`

### Modified Capabilities

<!-- No existing specs change -- this is a new mechanism, not a requirement change to existing specs -->

## Impact

- `zsh/.zshrc`: Add skip logic inside the existing `for __module_dir` loop
- `zsh/modules/README.md`: Document the disable mechanism
- Existing configurations are unaffected: when `ZSH_DISABLED_MODULES` is unset or empty, all modules load as before
