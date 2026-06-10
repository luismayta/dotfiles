## ADDED Requirements

### Requirement: Automatic tool installation on shell start

The system SHALL auto-install common development tools (axel, ripgrep, fzf, jq, bat, coreutils, the_silver_searcher) if they are not present when the shell starts.

#### Scenario: Missing ripgrep auto-installed

- **WHEN** the shell starts and `rg` is not in `PATH`
- **THEN** the system SHALL run `brew install ripgrep`

#### Scenario: Missing fzf auto-installed

- **WHEN** the shell starts and `fzf` is not in `PATH`
- **THEN** the system SHALL run `brew install fzf`

#### Scenario: Missing bat auto-installed

- **WHEN** the shell starts and `bat` is not in `PATH`
- **THEN** the system SHALL run `brew install bat`

#### Scenario: Missing jq auto-installed

- **WHEN** the shell starts and `jq` is not in `PATH`
- **THEN** the system SHALL run `brew install jq`

### Requirement: cat override with bat

The system SHALL override the `cat` command to use `bat` for syntax-highlighted output.

#### Scenario: cat shows highlighted output

- **WHEN** `cat file.py` is called
- **THEN** the output SHALL be displayed with `bat` syntax highlighting

### Requirement: FZF integration helpers

The system SHALL provide FZF-based interactive helper functions.

#### Scenario: fkill kills process interactively

- **WHEN** `fkill` is called
- **THEN** the system SHALL show a process list via `ps -ef | sed 1d | fzf -m` and `kill -9` the selection

#### Scenario: fa navigates to directory via fd+fzf

- **WHEN** `fa` is called
- **THEN** the system SHALL show directories via `fd --type d --hidden --follow --exclude .git | fzf +m` and `cd` into the selection

#### Scenario: fcs selects and copies git commit hash

- **WHEN** `fcs` is called in a git repository
- **THEN** the system SHALL show `git log --oneline --reverse` via fzf and copy the selected commit hash to clipboard

#### Scenario: fgb switches git branches

- **WHEN** `fgb` is called in a git repository
- **THEN** the system SHALL show the 30 most recent branches via `git for-each-ref` and fzf-tmux and `git checkout` the selection

#### Scenario: ftm switches tmux sessions

- **WHEN** `ftm` is called inside tmux
- **THEN** the system SHALL show a fzf picker to switch sessions

#### Scenario: fgr searches code with ripgrep+fzf

- **WHEN** `fgr pattern` is called
- **THEN** the system SHALL search via `rg --no-heading --line-number` and open the selected file in `$EDITOR`

### Requirement: Network utilities

The system SHALL provide quick network utility functions.

#### Scenario: ip shows public IP

- **WHEN** `ip` is called
- **THEN** the output SHALL be the current public IP via `dig +short myip.opendns.com @resolver1.opendns.com`

#### Scenario: localip shows LAN IP

- **WHEN** `localip` is called on macOS
- **THEN** the output SHALL be the LAN IP via `ipconfig getifaddr en0`

#### Scenario: net shows ping latency

- **WHEN** `net` is called
- **THEN** the output SHALL show ping latency to 8.8.8.8

### Requirement: Linux compatibility polyfills

The system SHALL provide Linux polyfills for macOS-specific commands when running on Linux.

#### Scenario: open uses xdg-open on Linux

- **WHEN** `open file.pdf` is called on Linux
- **THEN** it SHALL execute `xdg-open file.pdf`

#### Scenario: pbcopy uses xclip or xsel on Linux

- **WHEN** `pbcopy` is called on Linux
- **THEN** it SHALL pipe input to `xclip -selection clipboard` or `xsel --clipboard --input`

#### Scenario: pbpaste uses xclip or xsel on Linux

- **WHEN** `pbpaste` is called on Linux
- **THEN** it SHALL output from `xclip -selection clipboard -o` or `xsel --clipboard --output`

### Requirement: SSH public key copy utility

The system SHALL provide `pubkey()` to copy the SSH public key to the clipboard.

#### Scenario: pubkey copies key to clipboard

- **WHEN** `pubkey` is called
- **THEN** the contents of `~/.ssh/id_rsa.pub` SHALL be copied to the clipboard

### Requirement: axel-based download accelerator

The system SHALL provide `download()` that downloads files using axel with 20 connections.

#### Scenario: download uses axel

- **WHEN** `download https://example.com/file.tar.gz` is called
- **THEN** it SHALL execute `axel -n 20 -av https://example.com/file.tar.gz`