## Architecture

Migrates binary download functionality into the existing `zsh/modules/bitwarden/` module, replacing the vulnerable yarn-based installation.

## Changes

### config/base.zsh

Add binary installation variables:
```zsh
export BITWARDEN_INSTALL_URL="https://bitwarden.com/download/cli"
export BITWARDEN_BIN_DIR="${HOME}/.local/bin"
export BITWARDEN_BIN_PATH="${BITWARDEN_BIN_DIR}/bw"
```

### internal/base.zsh

Replace vulnerable install function:
```zsh
# BEFORE (vulnerable):
function bitwarden::internal::bitwarden::install {
    yarn global add @bitwarden/cli
}

# AFTER (secure):
function bitwarden::internal::bitwarden::install {
    # Architecture detection (arm64/amd64)
    # OS detection (darwin/linux)
    # Binary download from official URL
    # Extract to BITWARDEN_BIN_DIR
    # chmod +x BITWARDEN_BIN_PATH
}
```

Add upgrade function:
```zsh
function bitwarden::internal::bitwarden::upgrade {
    rm -f "${BITWARDEN_BIN_PATH}"
    bitwarden::internal::bitwarden::install
}
```

### internal/main.zsh

Replace `core::install bw` with binary download:
```zsh
# BEFORE:
if ! core::exists bw; then core::install bw; fi

# AFTER:
if ! core::exists bw; then bitwarden::internal::bitwarden::install; fi
```

## Testing

1. Source the module: `source zsh/modules/bitwarden/plugin.zsh`
2. Verify binary download: `bitwarden::internal::bitwarden::install`
3. Verify binary works: `bw --version`
4. Verify existing functionality: `bw::search` (fzf search)
