## 1. Clipboard Linux — Full port from macOS parity

- [ ] 1.1 Enable `set-clipboard external` for OSC 52 passthrough in `data/sync/tmux/linux.conf`
- [ ] 1.2 Add copy-mode-vi bindings in `linux.conf`: `Enter` → copy-pipe-and-cancel (clipboard), `C-c` → copy-pipe-no-clear (clipboard)
- [ ] 1.3 Add mouse bindings in `linux.conf`: `MouseDragEnd1Pane` and `DoubleClick1Pane` → copy-pipe to clipboard
- [ ] 1.4 Add buffer-to-clipboard binding in `linux.conf`: `prefix C-c` → `run-shell "tmux save-buffer - | xclip/wl-copy"`
- [ ] 1.5 Add system paste bindings in `linux.conf`: `prefix C-v` (load-buffer + paste -d) and `prefix P` (load-buffer + paste)
- [ ] 1.6 Implement clipboard tool detection chain with fallback: `xclip` → `wl-copy` → error message
- [ ] 1.7 Add `prefix y` display-message toggle feedback in `.tmux.conf`: show "ON"/"OFF" for synchronize-panes

## 2. Pane Navigation — Faster movement between panes

- [ ] 2.1 Add `Alt+h/j/k/l` bindings in `.tmux.conf` for direct pane navigation without prefix
- [ ] 2.2 Add `TMUX_NO_ALT_NAV` conditional guard to skip Alt navigation bindings if set
- [ ] 2.3 Add `Alt+0..9` bindings in `.tmux.conf` for direct window switching without prefix
- [ ] 2.4 Add `prefix Tab` binding for `last-pane` toggle
- [ ] 2.5 Add `prefix {` and `prefix }` bindings for swapping panes
- [ ] 2.6 Add `prefix C-h/j/k/l` bindings for larger resize increments (10 units vs 5)

## 3. Quick Actions — Common tasks without entering copy-mode

- [ ] 3.1 Add `prefix .` binding to copy current pane path to clipboard (via `display-message -p "#{pane_current_path}"`)
- [ ] 3.2 Add `prefix C-o` binding to capture visible pane content to clipboard
- [ ] 3.3 Verify `prefix z` (zoom toggle), `prefix x` (kill pane with confirm), `prefix ?` (show bindings) work as expected

## 4. Session & Window Management — Improved session handling

- [ ] 4.1 Add `prefix ,` binding for window rename prompt
- [ ] 4.2 Add `prefix W` binding to launch fzf window picker across all sessions
- [ ] 4.3 Update `prefix X` to kill current window (with confirm) instead of entire session

## 5. Helper Functions — Zsh-level improvements

- [ ] 5.1 Enhance `ftm` in `pkg/helper.zsh` to show fzf preview with session windows
- [ ] 5.2 Enhance `ftmk` in `pkg/helper.zsh` to show fzf preview with session windows
- [ ] 5.3 Add fzf window picker function (called by `prefix W`) to `pkg/helper.zsh`

## 6. Final Review

- [ ] 6.1 Run `tmux::sync` to verify rsync pushes all files correctly
- [ ] 6.2 Reload tmux config with `prefix r` and verify no errors
- [ ] 6.3 Test each new binding on Linux end-to-end
- [ ] 6.4 Test that existing macOS config is unaffected
