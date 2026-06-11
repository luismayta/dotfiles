## 1. Fix linux.conf clipboard quoting

- [x] 1.1 Replace the nested quoted `if-shell` chain with the curly brace `{}` syntax, one block per clipboard tool (pbcopy → xclip → wl-copy → fallback display-message)
- [x] 1.2 Verify by running `tmux -f /dev/null source-file zsh/modules/tmux/data/sync/tmux/linux.conf` — must produce no "too many arguments" error
- [x] 1.3 Clean up: remove the old `\` line continuations and ensure consistent 4-space indentation

## 2. Modernize osx.conf

- [x] 2.1 Remove redundant `mode-keys vi` settings (lines 3-5) — already set in `.tmux.conf`
- [x] 2.2 Change `set -g set-clipboard off` → `set -g set-clipboard external`
- [x] 2.3 Remove `set-option -g default-command "exec reattach-to-user-namespace -l $SHELL"` (line 11)
- [x] 2.4 Verify macOS clipboard still works: copy in tmux, paste in native macOS app

## 3. Update .tmux.conf OS-specific sources

- [x] 3.1 Convert OS-specific `if-shell` source-file lines (107-108) to curly brace `{}` syntax
- [x] 3.2 Verify full config loads without errors: `tmux -f zsh/modules/tmux/data/conf/.tmux.conf source-file /dev/null`
