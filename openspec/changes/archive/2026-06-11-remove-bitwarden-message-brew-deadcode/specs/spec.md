## ADDED Requirements

*(None — this change removes dead code with no new behavioral requirements.)*

## MODIFIED Requirements

*(None — no existing spec-level behavior is changing.)*

## REMOVED Requirements

### Requirement: BITWARDEN_MESSAGE_BREW environment variable

The `BITWARDEN_MESSAGE_BREW` environment variable was previously exported in `zsh/modules/bitwarden/config/base.zsh`. It is dead code with zero consumers.

**Reason**: Dead code removal — centralized into `CORE_MESSAGE_BREW` during HAD-62. This variable was missed in that cleanup.

**Migration**: Use `$CORE_MESSAGE_BREW` instead.

### Requirement: SSH_MESSAGE_BREW environment variable

The `SSH_MESSAGE_BREW` environment variable was previously exported in `zsh/modules/ssh/config/base.zsh`. It is dead code with zero consumers.

**Reason**: Dead code removal — centralized into `CORE_MESSAGE_BREW` during HAD-62. This variable was missed in that cleanup.

**Migration**: Use `$CORE_MESSAGE_BREW` instead.

### Requirement: TMUX_MESSAGE_BREW environment variable

The `TMUX_MESSAGE_BREW` environment variable was previously exported in `zsh/modules/tmux/config/base.zsh`. It is dead code with zero consumers.

**Reason**: Dead code removal — centralized into `CORE_MESSAGE_BREW` during HAD-62. This variable was missed in that cleanup.

**Migration**: Use `$CORE_MESSAGE_BREW` instead.

### Requirement: DOCKER_MESSAGE_BREW environment variable

The `DOCKER_MESSAGE_BREW` environment variable was previously exported in `zsh/modules/docker/config/base.zsh`. It is dead code with zero consumers.

**Reason**: Dead code removal — centralized into `CORE_MESSAGE_BREW` during HAD-62. This variable was missed in that cleanup.

**Migration**: Use `$CORE_MESSAGE_BREW` instead.