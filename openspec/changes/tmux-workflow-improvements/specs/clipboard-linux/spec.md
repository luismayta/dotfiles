## ADDED Requirements

### Requirement: OSC 52 clipboard passthrough
The linux.conf SHALL enable `set-clipboard external` for OSC 52 clipboard passthrough, allowing copy/paste operations to work across SSH sessions and remote connections.

#### Scenario: OSC 52 enabled by default
- **WHEN** tmux starts on Linux
- **THEN** `set-clipboard external` SHALL be set in the tmux configuration

### Requirement: Mouse-based text selection copies to system clipboard
The linux.conf SHALL bind `MouseDragEnd1Pane` to copy the selected text directly to the system clipboard, and `DoubleClick1Pane` to select a word and copy it.

#### Scenario: Mouse drag copies text
- **WHEN** user selects text with mouse in a tmux pane
- **THEN** the selected text SHALL be automatically copied to the system clipboard
- **AND** the text SHALL remain in the tmux buffer as well

#### Scenario: Double-click copies word
- **WHEN** user double-clicks a word in a tmux pane
- **THEN** the word SHALL be selected and copied to the system clipboard

### Requirement: Enter key in copy-mode copies to clipboard
The linux.conf SHALL bind `Enter` in copy-mode-vi to pipe the selection to the system clipboard, in addition to copying to the tmux buffer.

#### Scenario: Enter copies selection
- **WHEN** user presses Enter after selecting text in copy-mode-vi
- **THEN** the selected text SHALL be copied to the system clipboard

### Requirement: Buffer-to-clipboard command
The linux.conf SHALL provide a `prefix C-c` binding that copies the current tmux buffer to the system clipboard.

#### Scenario: Buffer copied to system clipboard
- **WHEN** user presses `prefix C-c`
- **THEN** the content of the tmux buffer SHALL be piped to the system clipboard tool (xclip/wl-copy/pbcopy)

### Requirement: System clipboard paste into tmux
The linux.conf SHALL provide `prefix C-v` and `prefix P` bindings to paste from the system clipboard into the current tmux pane.

#### Scenario: Paste from clipboard with prefix C-v
- **WHEN** user presses `prefix C-v`
- **THEN** the system clipboard content SHALL be loaded into the tmux buffer
- **AND** pasted into the current pane
- **AND** removed from the tmux buffer after paste

#### Scenario: Paste from clipboard with prefix P
- **WHEN** user presses `prefix P`
- **THEN** the system clipboard content SHALL be loaded into the tmux buffer
- **AND** pasted into the current pane
- **AND** kept in the tmux buffer after paste

### Requirement: C-c in copy-mode copies without cancel
The linux.conf SHALL bind `C-c` in both copy-mode and copy-mode-vi to copy the selection to the system clipboard without canceling copy mode.

#### Scenario: Copy without canceling
- **WHEN** user presses `C-c` during an active selection in copy-mode
- **THEN** the selection SHALL be copied to the system clipboard
- **AND** copy-mode SHALL remain active

### Requirement: Clipboard tool detection with fallback chain
The linux.conf SHALL detect the available clipboard tool using a fallback chain: `xclip` → `wl-copy` (Wayland) → display error message if none found.

#### Scenario: xclip available
- **WHEN** `xclip` is installed
- **THEN** it SHALL be used for clipboard operations

#### Scenario: wl-copy available (Wayland)
- **WHEN** `xclip` is not available but `wl-copy` is
- **THEN** `wl-copy` SHALL be used for clipboard operations

#### Scenario: No clipboard tool
- **WHEN** neither `xclip` nor `wl-copy` is available
- **THEN** a display message SHALL inform the user that no clipboard tool was found
