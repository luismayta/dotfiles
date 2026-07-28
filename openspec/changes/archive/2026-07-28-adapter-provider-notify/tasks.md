## 1. Adapter Directory Structure

- [x] 1.1 Create `config/adapter/` directory
- [x] 1.2 Create `internal/adapter/` directory
- [x] 1.3 Move `config/noti.zsh` → `config/adapter/noti.zsh`
- [x] 1.4 Move `config/notify-send.zsh` → `config/adapter/notify-send.zsh`
- [x] 1.5 Move `internal/noti.zsh` → `internal/adapter/noti.zsh`
- [x] 1.6 Move `internal/notify-send.zsh` → `internal/adapter/notify-send.zsh`

## 2. Adapter Contract

- [x] 2.1 Update `internal/adapter/noti.zsh` — wrap existing functions as `notify::adapter::*`
- [x] 2.2 Update `internal/adapter/notify-send.zsh` — wrap existing functions as `notify::adapter::*`
- [x] 2.3 Create empty stubs for `notify::adapter::render` and `notify::adapter::sync` in notify-send (no-op)

## 3. Config Layer Dispatch

- [x] 3.1 Add `ZSH_NOTIFY_PROVIDER` variable to `config/base.zsh`
- [x] 3.2 Update `config/main.zsh` — dispatch adapter config based on provider
- [x] 3.3 Remove old `config/noti.zsh` and `config/notify-send.zsh` source lines

## 4. Internal Layer Dispatch

- [x] 4.1 Update `internal/main.zsh` — dispatch adapter internal based on provider
- [x] 4.2 Remove old `internal/noti.zsh` and `internal/notify-send.zsh` source lines
- [x] 4.3 Define `notify::adapter::send` in OS-specific popup files (fallback stub)

## 5. OS Popup Delegation

- [x] 5.1 Replace `internal/linux.zsh` — popup delegates to `notify::adapter::send`
- [x] 5.2 Replace `internal/osx.zsh` — popup delegates to `notify::adapter::send`

## 6. Pkg Layer Update

- [x] 6.1 Update `pkg/main.zsh` — point to adapter paths
- [x] 6.2 Ensure backward compatibility: `notify::noti::send` still works

## 7. Verification

- [x] 7.1 Module loads without errors: `source plugin.zsh`
- [x] 7.2 `ZSH_NOTIFY_PROVIDER=noti` → uses noti
- [x] 7.3 `ZSH_NOTIFY_PROVIDER=notify-send` → uses notify-send
- [x] 7.4 `ZSH_NOTIFY_PROVIDER=auto` → auto-detect (default)
- [x] 7.5 `notify::noti::send` still works (backward compat)
