## REMOVED Requirements

### Requirement: Docker-based AWS CLI

**Reason**: Migrated to `zsh/modules/docker/pkg/base.zsh` for better domain organization.
**Migration**: `awscli()` relocated to `zsh/modules/docker/pkg/base.zsh`. Same signature and behavior.

### Requirement: Docker-based AWS Shell

**Reason**: Migrated to `zsh/modules/docker/pkg/base.zsh`.
**Migration**: `aws-shell()` relocated to `zsh/modules/docker/pkg/base.zsh`. Same signature and behavior.

### Requirement: Docker-based YouTube-DL

**Reason**: Migrated to `zsh/modules/docker/pkg/base.zsh`.
**Migration**: `ytdl()`, `ytd-mp3()`, `youtube-dl()` relocated to `zsh/modules/docker/pkg/base.zsh`. Same signatures and behavior.

### Requirement: Docker-based nyan cat

**Reason**: Migrated to `zsh/modules/docker/pkg/base.zsh`.
**Migration**: `nyancat()` relocated to `zsh/modules/docker/pkg/base.zsh`. Same signature and behavior.

### Requirement: Docker-based Komiser dashboard

**Reason**: Migrated to `zsh/modules/docker/pkg/base.zsh`.
**Migration**: `komiser()` relocated to `zsh/modules/docker/pkg/base.zsh`. Same signature and behavior.