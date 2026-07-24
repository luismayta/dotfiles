## Context

Neovim config defines two conflicting keybinding sets using the `<C-x>` prefix:
- `opencode.lua:15` maps `<C-x>` to `opencode.select()` (opencode plugin)
- `config/keymaps.lua:47-60` maps `<C-x>{1,2,3,h,j,k,l,v,s,o,c,q}` to window management

The opencode `<C-x>` mapping fires immediately, intercepting the prefix and breaking all 14 window management shortcuts. This is a LazyVim-based setup using `keys` lazy-loading in the opencode plugin spec.

## Goals / Non-Goals

**Goals:**
- Eliminate the `<C-x>` conflict between opencode and window management
- Remap opencode's "select" action to a non-conflicting, ergonomic key
- Preserve all existing `<C-x>*` window management bindings unchanged

**Non-Goals:**
- Restructuring the window management keymap scheme
- Changing other opencode bindings (`<C-a>`, `go`, `goo`, etc.)
- Modifying tmux or Zed keybindings (separate systems)

## Decisions

### Remap opencode from `<C-x>` to `<C-z>`

**Chosen**: `<C-z>` for `opencode.select()`

**Why `<C-z>`**:
- Adjacent to `<C-x>` on QWERTY — minimal muscle memory disruption
- Not used by any existing keymap in the config
- Consistent with `<C-a>` (ask) pattern — both are Ctrl+letter shortcuts
- Single keypress, no leader dependency

**Alternatives considered**:
- `<leader>x` — two-key combo, slower for frequent use
- `<C-q>` — commonly mapped to quit/force-quit in terminal emulators
- `,oc` — custom mnemonic but requires leader key overhead
- `<C-s>` — already mapped to Save

## Risks / Trade-offs

- **[Risk]** User has muscle memory for `<C-x>` → opencode → **[Mitigation]** Adjacent key `<C-z>` minimizes disruption; user can update
- **[Risk]** `<C-z>` may be captured by terminal (suspend) → **[Mitigation]** Neovim overrides terminal suspend when in normal/visual mode; verified no conflict in LazyVim defaults
